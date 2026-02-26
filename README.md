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















<!-- # SkWEからskript-reflectへの移行
import:
    com.sk89q.worldedit.WorldEdit
    com.sk89q.worldedit.math.BlockVector3
    com.sk89q.worldedit.regions.CuboidRegion
    com.sk89q.worldedit.world.block.BlockTypes
    com.fastasyncworldedit.core.FaweAPI
    com.sk89q.worldedit.extent.clipboard.io.ClipboardFormats
    com.sk89q.worldedit.function.operation.Operations
    com.sk89q.worldedit.session.ClipboardHolder
    java.io.File
    java.io.FileInputStream
# ========================================
# TestA: 指定範囲を air で塗りつぶす
# function TestA():
    # wait 5 tick
#     set {_map} to a new cuboid region from location(-200,-64,-200,"world") to location(200,319,200,"world")
#     use we to set blocks in {_map} to "air"
# ========================================
function TestA():
    wait 5 tick

    # ワールドの取得
    set {_faweWorld} to FaweAPI.getWorld("world")

    # CuboidRegion の作成
    set {_min} to BlockVector3.at(-200, -64, -200)
    set {_max} to BlockVector3.at(200, 319, 200)
    set {_region} to new CuboidRegion({_faweWorld}, {_min}, {_max})

    # EditSession の作成 (制限なし)
    set {_editSession} to WorldEdit.getInstance().newEditSessionBuilder().world({_faweWorld}).limitUnlimited().build()

    # air で塗りつぶし
    {_editSession}.setBlocks({_region}, BlockTypes.AIR.getDefaultState())
    {_editSession}.close()
# ========================================
# TestB: スケマティックを貼り付ける
# function TestB():
    # wait 5 tick
#     paste schematic named "%{selected_map::1}%" at location(0,100,0):
#         paste entities: true
#         paste biomes: true
#         ignore air: true
# ========================================
function TestB():
    wait 5 tick
    set {_name} to "%{selected_map::1}%"

    # スケマティックファイルの読み込み (.schem / .schematic 自動判別)
    set {_file} to new File("plugins/FastAsyncWorldEdit/schematics/%{_name}%.schem")
    if {_file}.exists() is false:
        set {_file} to new File("plugins/FastAsyncWorldEdit/schematics/%{_name}%.schematic")
    if {_file}.exists() is false:
        broadcast "[TestB] スケマティックが見つかりません: %{_name}%"
        stop

    set {_format} to ClipboardFormats.findByFile({_file})
    if {_format} is not set:
        broadcast "[TestB] 対応フォーマットが見つかりません: %{_name}%"
        stop

    # クリップボードへ読み込み
    set {_fis} to new FileInputStream({_file})
    set {_reader} to {_format}.getReader({_fis})
    set {_clipboard} to {_reader}.read()
    {_reader}.close()

    # 貼り付け先ワールドと座標
    set {_faweWorld} to FaweAPI.getWorld("world")
    set {_to} to BlockVector3.at(0, 100, 0)

    # EditSession の作成
    set {_editSession} to WorldEdit.getInstance().newEditSessionBuilder().world({_faweWorld}).limitUnlimited().build()

    # ペースト操作の組み立て
    set {_holder} to new ClipboardHolder({_clipboard})
    set {_op} to {_holder}.createPaste({_editSession}).to({_to}).ignoreAirBlocks(true).copyEntities(true).copyBiomes(true).build()

    Operations.complete({_op})
    {_editSession}.close() -->