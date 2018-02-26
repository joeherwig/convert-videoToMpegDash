# convert-videoToMpegDash
Powershell script to convert a MP4 or webm video into [MPEG-DASH](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP)

- Creates the multiple bitrate versions to a pre-defined set of resolutions ('160', '320', '640', '1280', '1920')
- Splits the versions into segments of 1 second (by default)
- Creates the main MPEG-DASH manifest file.

## Dependencies

- FFmpeg https://www.ffmpeg.org/
- Microsoft Powershell

## Installation
Install all dependencies.
Please ensure that the path to the ffmpeg.exe is available via the environment-variable PATH like via command line:

`set PATH=C:\ffmpeg\bin`

Download the convert-videoToMpegDash.ps1 from this repo and save it to the folder of your choice.

# Usage
Execute the powershell-script eg with

`.\convert-movieToDash.ps1 -original ~\Videos\myVideo.mp4`

## Parameter
`-original` gets the path to the video which should be converted to a MPEG-DASH set.

# Result
The results are stored at the location of the original video source.

# What to do with the mpeg-dash stuff?
- add dashjs to your website eg via:
`<script src="https://cdn.dashjs.org/latest/dash.all.min.js"></script>`
then upload the generated files to your favorite HTTPS-Server and include the HTML Video snippet eg.:

```<video data-dashjs-player="" autoplay="" src="myVideo.mpd" controls="" preload="auto">
    <source src="myVideo.webm" type="video/webm">
    <source src="myVideo.mp4" type="video/mp4">
    Your browser does not support the video tag!
  </video>
```
