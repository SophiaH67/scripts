#!/bin/bash
# Usage: ./white_top_black_text.sh <input_video> <top text> <bottom text> <output_video>

input_video=$1
top_text=$2
bottom_text=$3
output_video=$4

if [ -z "$input_video" ] || [ -z "$top_text" ] || [ -z "$bottom_text" ] || [ -z "$output_video" ]; then
    echo "Usage: ./white_top_black_text.sh <input_video> <top text> <bottom text> <output_video>"
    exit 1
fi

ffmpeg -i $input_video -filter_complex "[0:v]drawtext=text='$top_text':fontcolor=white:fontsize=32:x=(w-text_w)/2:y=10[top];[top]drawtext=text='$bottom_text':fontcolor=white:fontsize=32:x=(w-text_w)/2:y=h-th-10[out]" -map "[out]" $output_video
