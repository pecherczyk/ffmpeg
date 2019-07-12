#!/bin/bash

ffmpeg -h &>/dev/null

if [ $? -ne 0 ]
  then
    printf "%s\n" "ffmpeg is not installed!"
    exit 1
fi

printf "%s\n" "Enter file extension ex [mp4 | mov | mkv ...]";
read extension;

printf "%s\n" "Do you want to scale to 1920x1080? [ y | n ]";
read scale;

mkdir -p prores

if [ $scale == 'y' ]
  then
    scale=scale\=1920\:1080,
  else
    scale=""
fi

for name in *.$extension; do
   ffmpeg -i $name -vf "$scale fps=30000/1001, format=yuv422p" \
   -c:v prores -profile:v 1 -max_muxing_queue_size 1024 \
   -c:a pcm_s16le "prores/prores422LT_${name%.*}.mov" && \
   touch -r $name "prores/prores422LT_${name%.*}.mov"
done
