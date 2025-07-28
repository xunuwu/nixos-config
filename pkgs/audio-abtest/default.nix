{writeShellScriptBin}:
writeShellScriptBin "audio-abtest" ''
  track_1=$(shuf -i 0-1 -n 1)
  track_2=$(( 1 - track_1 ))

  ffmpeg -i "$1" -i "$2" -f lavfi -i color=c=black:s=100x100:r=3 \
    -c:v libx264 -tune stillimage -b:v 100k \
    -c:a copy \
    -map $track_1:a:0 -map $track_2:a:0 -map 2:v:0 \
    -shortest output.mkv
''
