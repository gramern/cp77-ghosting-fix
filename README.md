![FrameGen Ghosting 'Fix' logo](docs/assets/images/fgghostingfix_title_2000_500.png)
![Preem Compatibility Edition logo](docs/assets/images/fgghostingfix_title_2000_preem.png)

# FrameGen Ghosting 'Fix' Preem Compatibility Edition - ArchiveXL mod for Cyberpunk 2077
Limits ghosting behind some moving 3D objects caused by modded FSR3 frame generation in Cyberpunk 2077. Achieves that by putting almost invisible HUD masks that block frame generation from presenting in certain parts of a screen.

**Improved compatibility with other mods compared to the 'classic' version.**

# Requirements
+ Cyberpunk 2.12+
+ [redscript](https://github.com/jac3km4/redscript) 0.5.17+
+ [Cyber Engine Tweaks](https://github.com/maximegmd/CyberEngineTweaks) 1.31.0+
+ [ArchiveXL](https://github.com/psiberx/cp2077-archive-xl) 1.14.3+

# Intended results
Since 4.0.0-alpha, thanks to the major change in how masks are projected (uses the game's world space-to-screen space method, vehicle's position and camera data to project and transform masks in real-time), the mod is usable with FSR3 FG ON in lower framerates (30+ fps interpolated 60+ fps e.g.). The new mask mapping algorithm for vehicles in 4.8.0xl-alpha2 brings further improvements in smoothness in lower framerates. Alpha versions are available on the `develop-xl` and  `develop` branches.

# Using the repo from within the mod's WolvenKit project folder
The repo is configured to be placed 'as is' in the `source` folder of the mod's WolvenKit project. To avoid `*.reds` files being indexed twice by Redscript extensions for VSCode, open the `source` folder in the IDE directly.

The 'xl' edition has been the base for the other editions since 4.8.0xl-alpha2.

# The mod's whiteboard on Miro (rough design notes)
[https://miro.com/app/board/uXjVNrZBovU=/](https://miro.com/app/board/uXjVNrZBovU=/)

# The mod's releases
I publish all the mod's releases on [this Nexus Mods page](https://www.nexusmods.com/cyberpunk2077/mods/13029).
