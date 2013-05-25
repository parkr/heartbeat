I was interested in the a [post about measuring my heartbeat](http://blog.airbrake.io/guest-post/exploring-everything/)
from Airbrake's blog that I decided to put it together. All you need to do is
record a video, call it `heartbeat.mov` and put it in this folder. Then run:

```bash
$ ruby extract_data_from_video.rb
$ bash install-r-packages.sh
$ r --save < heartbeat_waveform.r
```

And kablam. Mine was measured as 112 BPM so I'm either nearly dead or was way
too excited that I could programmatically measure my heartbeat. Kewl stuff.
