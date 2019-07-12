#!/bin/bash

# Conversion interlaced MTS to FHD progressive 1080p

ffmpeg -h &>/dev/null

if [ $? -ne 0 ]
  then
    printf "%s\n" "ffmpeg is not installed!"
    exit 1
fi

printf "%s\n" "Choose yadif filter option [ 1 | 0 ]"
read yadif

if [ $yadif -eq 1 ]
  then
    yadif=1
  elif [ $yadif -eq 0 ]
    then
    yadif=0
  else
    printf "%s\n" "Bad parameter given! Choose"
    exit 1
fi

printf "%s\n" "Enter CRF parameter quality [18 - 32]"
read crf

if [ $crf -gt 32 ] || [ $crf -lt 18 ]
  then
    printf "%s\n" "Error bad parameter given!"
    exit 1
fi

printf yadif

mkdir -p archive

for name in *.mts *.MTS; do
  ffmpeg -i $name \
  -vf yadif=$yadif \
  -c:v libx264 -preset slow -tune film -profile:v high -level 4.1 -crf $crf \
  -c:a aac -b:a 112k "archive/archive_x265_${name%.*}.mp4" && \
  touch -r $name "archive/archive_x265_${name%.*}.mp4"
done
