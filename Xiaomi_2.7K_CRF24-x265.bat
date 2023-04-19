@echo off
mkdir x265
for %%j in ("*.mp4") do ^
ffmpeg -i "%%j" ^
-vf "fps=30000/1001, scale=2704:1520" ^
-c:v libx265 -preset medium -x265-params crf=24:qcomp=0.8:aq-mode=1:aq_strength=1.0:qg-size=16:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1:merange=44 ^
-c:a copy "x265\%%~nj_2.7K_x265.mp4" && c:\touch.exe -r "%%j" -- "x265\%%~nj_2.7K_x265.mp4"

pause