# フレンドリー・ファイア ∅ (The Friendly Fire)
—「理不尽すぎるかもだけど、好きでしょ？　こういうの」
<!-- \#ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
\#
\#  00  11                  1            1                  11  00  |
\#  1100  0000 1000          1          1          0001 0000  0011  |
\#    0000000       1          0      0          1      00000000    |
\#    1000 0    11    110      1      1      011    11    0 0001    |
\#   1100 0    1001      100     1  1     001      1001    0 0011   |
\#    10000   100001  111   101  1  1  101   111  100001   00001    |
\#     0000 0  10010 1        0   00   0        1 01001  0 0000     |
\#      000     11000 1          0110          1 00011     000      |
\#      000000     0 1 111    00 1  1 00   111 1 0     000000       |
\#       00000            111  00111100  111            00000       |
\#       00   0        000      011110      000        0   00       |
\#         0000  000000       0 0 11 0 0       000000  0000         |
\#             1 000     00    11 11 11    00     000 1             |
\#               00           01  11  10           00               |
\#              100  1000100 001  11   100 0100001  001             |
\#                100   101                  101   001              |
\#                 0     1                    1     0               |
\#                       1                    1                     |
\#
\#ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー -->


### Requirements
| Component | Version |
|---|---|
| Java | Temurin 21.0.10+7 LTS |
| Paper | 1.21.8#60 |
| Skript | 2.14.1 |
| SkBee | 3.17.0 |
| skript-reflect | 2.6.3 |
| FastAsyncWorldEdit | 2.15.0 |

<!-- | Minecraft | 1.21.x |
| ProtocolLib | 5.4.0 |
| skript-packet | latest |
| PlaceholderAPI | 2.11.7 | -->

### Migration
Replaced the built-in Skript-WorldEdit integration with direct Java API calls instead of:
```java
function ClearMap():
    set {_map} to a new cuboid region from location(-200,-64,-200,"world") to location(200,319,200,"world")
    use we to set blocks in {_map} to "air"
function LoadMap():
    wait a tick
    paste schematic named "%{selected_map::1}%" at location(0,100,0):
        paste entities: true
        paste biomes: true
        ignore air: true
```
With the new implementation using the FAWE API directly:
```java
import:
    java.io.File
    java.io.FileInputStream
    com.sk89q.worldedit.WorldEdit
    com.sk89q.worldedit.math.BlockVector3
    com.sk89q.worldedit.regions.CuboidRegion
    com.sk89q.worldedit.bukkit.BukkitAdapter
    com.sk89q.worldedit.world.block.BlockTypes
    com.sk89q.worldedit.session.ClipboardHolder
    com.sk89q.worldedit.function.operation.Operations
    com.sk89q.worldedit.extent.clipboard.io.ClipboardFormats
function ClearMap():
    set {_max} to BlockVector3.at(300, 319, 300)
    set {_min} to BlockVector3.at(-300, -64, -300)
    set {_weWorld} to BukkitAdapter.adapt(world("world"))
    set {_region} to new CuboidRegion({_weWorld}, {_min}, {_max})
    set {_air} to BlockTypes.AIR.getDefaultState()
    create section stored in {_task}:
        set {_builder} to WorldEdit.getInstance().newEditSessionBuilder()
        set {_builder} to {_builder}.world({_weWorld})
        set {_builder} to {_builder}.limitUnlimited()
        set {_builder} to {_builder}.fastMode(true)
        set {_builder} to {_builder}.changeSetNull()
        set {_builder} to {_builder}.checkMemory(false)
        set {_session} to {_builder}.build()
        {_session}.setBlocks({_region}, {_air})
        {_session}.close()
    run section {_task} async
function LoadMap():
    wait a tick
    # Specify the schematic by file path
    set {_file} to new File("plugins/FastAsyncWorldEdit/schematics/%{selected_map::1}%.schem")
    set {_format} to ClipboardFormats.findByFile({_file})
    set {_fis} to new FileInputStream({_file})
    set {_reader} to {_format}.getReader({_fis})
    set {_clipboard} to {_reader}.read()
    {_reader}.close()
    {_fis}.close()
    # Align the center
    set {_cbRegion} to {_clipboard}.getRegion()
    set {_center} to {_cbRegion}.getCenter().toBlockPoint()
    set {_origin} to {_clipboard}.getOrigin()
    set {_centerOffset} to {_center}.subtract({_origin})
    set {_targetVec} to BlockVector3.at(0, 100, 0)
    set {_to} to {_targetVec}.subtract({_centerOffset})
    set {_weWorld} to BukkitAdapter.adapt(world("world"))
    # Paste asynchronously
    create section stored in {_task}:
        set {_builder} to WorldEdit.getInstance().newEditSessionBuilder()
        set {_builder} to {_builder}.world({_weWorld})
        set {_builder} to {_builder}.limitUnlimited()
        set {_builder} to {_builder}.fastMode(true)
        set {_builder} to {_builder}.changeSetNull()
        set {_builder} to {_builder}.checkMemory(false)
        set {_session} to {_builder}.build()
        set {_holder} to new ClipboardHolder({_clipboard})
        set {_pb} to {_holder}.createPaste({_session})
        set {_pb} to {_pb}.to({_to})
        set {_pb} to {_pb}.ignoreAirBlocks(true)
        set {_pb} to {_pb}.copyEntities(true)
        set {_pb} to {_pb}.copyBiomes(true)
        set {_op} to {_pb}.build()
        Operations.complete({_op})
        {_session}.close()
    run section {_task} async
```

### Optimization
Utilizes Aikar's Flags and MiniUPnP.
```bat
@echo off
chcp 65001 > nul
title Friendly Fire 1.1

upnpc-static.exe -r 25565 TCP
upnpc-static.exe -r 24454 UDP

"C:\Users\unluc\AppData\Local\Programs\Eclipse Adoptium\jdk-21.0.10.7-hotspot\bin\java.exe" ^
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

echo Server closed
echo.
pause
```










