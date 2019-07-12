#!/bin/bash

# INFO

# This script helps to encode two pass x.265 (HEVC) files via libx265 ffmpeg framework under Linux based machines. Put script into folder with files
# and run script

# NOTICE

# To calculate the bitrate to use for multi-channel audio: (bitrate for stereo) x (channels / 2).
# Example for 5.1 (6 channels) Vorbis audio: 128Kbps x (6 / 2) = 384Kbps
# (200 MiB * 8192 [converts MiB to kBit]) / 600 seconds = ~2730 kBit/s total bitrate
# 2730 - 128 kBit/s (desired audio bitrate) = 2602 kBit/s video bitrateThe value of K (Kilo) during calculations can take two values 1024 or 1000, depends on which type of calculation you want to perform. Consider using K = 1024 when you are considering storage capacity whether in hard disk, DVDs, flash drives or other devices and storage media. K = 1000 should be used when you are thinking of throughput, ie the speed at which information is transferred.
# The value of K (Kilo) during calculations can take two values 1024 or 1000,
# depends on which type of calculation you want to perform.
# Consider using K = 1024 when you are considering storage
# capacity whether in hard disk, DVDs, flash drives or other devices and storage media.
# K = 1000 should be used when you are thinking of throughput, ie the speed at which information is transferred.
# Whitespaces are not allowed in file names

ffmpeg -h &>/dev/null

if [ $? -ne 0 ]
  then
    printf "%s\n" "ffmpeg is not installed!"
    exit 1
fi

printf "%s\n" "Enter output file size in MiB [MiB]";
read capacity
capacity=`echo "scale=0;$capacity*8192" | bc`;

printf "%s\n" "Enter preset, the preset determines how fast the encoding process will be [medium | slow | slower | veryslow | fast | superfast | faster | ultrafast]"
read preset

printf "%s\n" "Determine file extension input files [mp4 | mov | mkv]";
read fileformat;

# Export folder name
mkdir -p x265-converted

for name in *.$fileformat; do
    durationTable+=(`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $name`)
    thebitrate=`echo "scale=0;$capacity/$durationTable-$audiobitrate" | bc`;
    parameter=$(printf "%s\n" "${thebitrate}k");
    ffmpeg -y -i $name -c:v libx265 -preset $preset -b:v $parameter \
    -x265-params pass=1:qcomp=0.8:aq-mode=1:aq_strength=1.0:qg-size=16:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1:merange=44 -max_muxing_queue_size 1024 -an -f mov /dev/null && \
    ffmpeg -i $name -c:v libx265 -preset $preset -b:v $parameter \
    -x265-params pass=2:qcomp=0.8:aq-mode=1:aq_strength=1.0:qg-size=16:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1:merange=44 -max_muxing_queue_size 1024 -c:a copy "x265-converted/film_${name%.*}.mkv"
done
