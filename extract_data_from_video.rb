require 'csv'
require 'rmagick'
require 'active_support/all'
require 'rvideo'
require './rvideo_fix'
abort "heartbeat.mov doesn't exist" unless File.size?("heartbeat.mov")
vid = RVideo::Inspector.new(:file => "heartbeat.mov")
@raw_response = `ffmpeg -i heartbeat.mox 2>&1`
puts "heartbeat.mov is in an unknown format." if vid.unknown_format?
puts "heartbeat.mov cannot be read." if vid.unreadable_file?
abort "heartbeat.mov isn't a valid video." if vid.invalid?
width, height = [vid.width, vid.height]
fps = vid.fps.to_i
duration = vid.duration/1000
if system("/usr/local/bin/ffmpeg -i heartbeat.mov -f image2 'frames/frame%03d.png'")
  CSV.open("data.csv","w") do |file|
    file << %w(frame intensity)
    (fps*duration).times do |n|
      img = Magick::ImageList.new("frames/frame#{sprintf("%03d",n+1)}.png")
      ch = img.channel(Magick::RedChannel)
      i = 0
      ch.each_pixel {|pix| i += pix.intensity}
      file << [n+1, i/(height*width)]
    end
  end
end
