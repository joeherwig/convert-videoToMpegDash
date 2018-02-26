[CmdletBinding()]
param(
    [String]$original
)
${inputBaseName} = ""
$inputFile = get-childitem $original
$outFileDirectory = $inputFile.Directory

$inputBaseName = $inputFile.BaseName

write-host "${outFileDirectory}\${inputBaseName}_audio.webm"

# remove previously created files
try {
    rm "${outFileDirectory}\${inputBaseName}_audio.webm"
    rm "${outFileDirectory}\${inputBaseName}_video_160x90_250k.webm"
    rm "${outFileDirectory}\${inputBaseName}_video_320x180_500k.webm"
    rm "${outFileDirectory}\${inputBaseName}_video_640x360_750k.webm"
    rm "${outFileDirectory}\${inputBaseName}_video_640x360_1000k.webm"
    rm "${outFileDirectory}\${inputBaseName}_video_1280x720_1500k.webm"
    rm "${outFileDirectory}\${inputBaseName}_video_1920x1080_3000k.webm"
}
Catch {
}


# create audio only file
ffmpeg.exe -i $inputFile -vn -acodec libvorbis -ab 128k -dash 1 "${outFileDirectory}\${inputBaseName}_audio.webm"

# render different video only resolutions
ffmpeg.exe -i $inputFile `
-c:v libvpx-vp9 `
-keyint_min 150 -g 150 `
-tile-columns 4 `
-frame-parallel 1 `
-f webm -dash 1 `
-an -vf scale=160:190 -b:v 250k -dash 1 "${outFileDirectory}\${inputBaseName}_video_160x90_250k.webm" `
-an -vf scale=320:180 -b:v 500k -dash 1 "${outFileDirectory}\${inputBaseName}_video_320x180_500k.webm" `
-an -vf scale=640:360 -b:v 750k -dash 1 "${outFileDirectory}\${inputBaseName}_video_640x360_750k.webm" `
-an -vf scale=640:360 -b:v 1000k -dash 1 "${outFileDirectory}\${inputBaseName}_video_640x360_1000k.webm" `
-an -vf scale=1280:720 -b:v 1500k -dash 1 "${outFileDirectory}\${inputBaseName}_video_1280x720_1500k.webm" `
-an -vf scale=1920:1080 -b:v 3000k -dash 1 "${outFileDirectory}\${inputBaseName}_video_1920x1080_3000k.webm"

ffmpeg.exe `
-f webm_dash_manifest -i "${inputBaseName}_video_160x90_250k.webm" `
-f webm_dash_manifest -i "${inputBaseName}_video_320x180_500k.webm" `
-f webm_dash_manifest -i "${inputBaseName}_video_640x360_750k.webm" `
-f webm_dash_manifest -i "${inputBaseName}_video_1280x720_1500k.webm" `
-f webm_dash_manifest -i "${inputBaseName}_video_1920x1080_3000k.webm" `
-f webm_dash_manifest -i "${inputBaseName}_audio.webm" `
-c copy -map 0 -map 1 -map 2 -map 3  -map 4  -map 5 `
-f webm_dash_manifest -adaptation_sets "id=0,streams=0,1,2,3,4 id=1,streams=5" `
"${outFileDirectory}\${inputBaseName}.mpd"
