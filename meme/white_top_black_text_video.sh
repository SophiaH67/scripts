#!/bin/bash
# Usage: ./white_top_black_text.sh <input_video> <text> <output_video>

input_video=$1
text=$2
output_video=$3

if [ -z "$input_video" ] || [ -z "$text" ] || [ -z "$output_video" ]; then
    echo "Usage: ./white_top_black_text.sh <input_video> <text> <output_video>"
    exit 1
fi

input_video_width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 $input_video)
input_video_height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 $input_video)

new_video_width=$input_video_width
# Add some padding to the video
padding=50
new_video_height=$((input_video_height + padding))

# Use ffmpeg to add white padding to the video and then overlay the text
ffmpeg -i $input_video -filter_complex "[0:v]pad=iw:$new_video_height:y=$padding:color=white[padded];[padded]drawtext=text=$text:fontcolor=black:fontsize=30:x=10:y=10[out]" -map "[out]" $output_video