module RVideo # :nodoc:
  class Inspector

    attr_reader :filename, :path, :full_filename, :raw_response, :raw_metadata

    attr_accessor :ffmpeg_binary

    #
    # To inspect a video or audio file, initialize an Inspector object.
    #
    #   file = RVideo::Inspector.new(options_hash)
    #
    # Inspector accepts three options: file, raw_response, and ffmpeg_binary.
    # Either raw_response or file is required; ffmpeg binary is optional.
    #
    # :file is a path to a file to be inspected.
    #
    # :raw_response is the full output of "ffmpeg -i [file]". If the
    # :raw_response option is used, RVideo will not actually inspect a file;
    # it will simply parse the provided response. This is useful if your
    # application has already collected the ffmpeg -i response, and you don't
    # want to call it again.
    #
    # :ffmpeg_binary is an optional argument that specifies the path to the
    # ffmpeg binary to be used. If a path is not explicitly declared, RVideo
    # will assume that ffmpeg exists in the Unix path. Type "which ffmpeg" to
    # check if ffmpeg is installed and exists in your operating system's path.
    #

    def initialize(options = {})
      if options[:raw_response]
        @raw_response = options[:raw_response]
      elsif options[:file]
        if options[:ffmpeg_binary]
          @ffmpeg_binary = options[:ffmpeg_binary]
          raise RuntimeError, "ffmpeg could not be found (trying #{@ffmpeg_binary})" unless FileTest.exist?(@ffmpeg_binary)
        else
          # assume it is in the unix path
          raise RuntimeError, 'ffmpeg could not be found (expected ffmpeg to be found in the Unix path)' unless FileTest.exist?(`which ffmpeg`.chomp)
          @ffmpeg_binary = "ffmpeg"
        end

        file = options[:file]
        @filename = File.basename(file)
        @path = File.dirname(file)
        @full_filename = file
        raise TranscoderError::InputFileNotFound, "File not found (#{file})" unless FileTest.exist?(file.gsub("\"",""))
        @raw_response = `#{@ffmpeg_binary} -i #{@full_filename} 2>&1`
      else
        raise ArgumentError, "Must supply either an input file or a pregenerated response" if options[:raw_response].nil? and file.nil?
      end

      # patched in https://github.com/zencoder/rvideo/pull/7
      metadata = /(Input \#.*)\n.+\n\Z/m.match(@raw_response)

      if /Unknown format/i.match(@raw_response) || metadata.nil?
        @unknown_format = true
      elsif /Duration: N\/A/im.match(@raw_response)
#      elsif /Duration: N\/A|bitrate: N\/A/im.match(@raw_response)
        @unreadable_file = true
        @raw_metadata = metadata[1] # in this case, we can at least still get the container type
      else
        @raw_metadata = metadata[1]
      end
    end
  end
end