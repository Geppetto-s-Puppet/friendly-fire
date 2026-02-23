@echo off
chcp 65001 > nul
title Friendly Fire 1.0

"C:\Program Files\Java\jdk-24\bin\java.exe" ^
  -Xms8G ^
  -Xmx8G ^
  -XX:+AlwaysPreTouch ^
  -XX:+DisableExplicitGC ^
  -XX:+ParallelRefProcEnabled ^
  -XX:+PerfDisableSharedMem ^
  -XX:+UnlockExperimentalVMOptions ^
  -XX:+UseG1GC ^
  -XX:G1HeapRegionSize=8M ^
  -XX:G1HeapWastePercent=5 ^
  -XX:G1MaxNewSizePercent=40 ^
  -XX:G1MixedGCCountTarget=4 ^
  -XX:G1MixedGCLiveThresholdPercent=90 ^
  -XX:G1NewSizePercent=30 ^
  -XX:G1RSetUpdatingPauseTimePercent=5 ^
  -XX:G1ReservePercent=20 ^
  -XX:InitiatingHeapOccupancyPercent=15 ^
  -XX:MaxGCPauseMillis=200 ^
  -XX:MaxTenuringThreshold=1 ^
  -XX:SurvivorRatio=32 ^
  -jar paper-1.21.8-60.jar --nogui

echo.
echo Server closed.
pause