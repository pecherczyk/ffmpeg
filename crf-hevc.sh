#!/bin/bash

ffmpeg -h &>/dev/null

if [ $? -ne 0 ]
  then
    printf "%s\n" "ffmpeg is not installed!"
    exit 1
fi

printf "%s\n" "Enter file extension [mp4 | mov | mkv ...]";
read extension;

printf "%s\n" "Reframerate to 29.97 fps? [ y | n ]"
read fps

printf "%s\n" "Do you want to scale to 1920x1080? [ y | n ]";
read scale;

printf "%s\n" "Enter CRF (Quality parameter - number between 18 - 32)";
read crf;

printf "%s\n" "Enter preset, the preset determines how fast the encoding process will be [medium | slow | slower | veryslow | fast | superfast | faster | ultrafast]"
read preset

mkdir -p archive

if [ $fps == 'y' ] && [ $scale == 'y' ]
  then
    video_filter="\"-vf scale=1920:1080, fps=30000/1001\""
  elif [ $fps == 'n' ] && [ $scale == 'n' ]
  then
    video_filter=""
  elif [ $fps == 'y' ] && [ $scale == 'n' ]
  then
  	video_filter="\"-vf fps=30000/1001\""
  elif [ $fps == 'n' ] && [ $scale == 'y' ]
  then
  	video_filter="\"-vf scale=1920:1080\""
  else
  	printf "%s\n" "Wrong parameters given!"
  	exit 1
fi

for name in *.$extension; do
    ffmpeg -i $name $video_filter -c:v libx265 -preset $preset \
    -x265-params crf=$crf:qcomp=0.8:aq-mode=1:aq_strength=1.0:qg-size=16:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1:merange=44 \
    -c:a copy "archive/archive_x265_${name%.*}.mp4" && \
    touch -r $name "archive/archive_x265_${name%.*}.mp4"
done
