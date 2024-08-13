![FrameGen Ghosting 'Fix' logo](docs/assets/images/fgghostingfix_title_2000_500.png)
![Anti-Ghosting & Contextual Frame Generation logo](docs/assets/images/fgghostingfix_title_2000_ag_cfg.png)

# Features
**Anti-ghosting:** 

Limits ghosting behind some moving 3D objects caused by modded FSR3 frame generation in Cyberpunk 2077. Achieves this by placing nearly invisible HUD masks that block frame generation in certain parts of the screen. Offers customization options, including [masking parameters on-foot](docs/assets/images/on-foot-customize.gif), [built-in presets system and presets editor for vehicles](docs/assets/images/vehicles-presets-editor.gif).

**Contextual Frame Generation:** 

Allows prioritizing image quality for [certain in-game events](docs/assets/images/contextual-menu.gif) by automatically turning frame generation on/off without lag or stutter.

# Requirements
**Base (Anti-Ghosting) requirements:**
+ Cyberpunk 2077 2.12+
+ [redscript](https://github.com/jac3km4/redscript) 0.5.17+
+ [Cyber Engine Tweaks](https://github.com/maximegmd/CyberEngineTweaks) 1.32.0+
+ [RED4ext](https://github.com/WopsS/RED4ext) 1.25.0+
+ [ArchiveXL](https://github.com/psiberx/cp2077-archive-xl) 1.14.3+

**Contextual Frame Generation additionally requires:**
+ [DLSS Enabler](https://github.com/artur-graniszewski/DLSS-Enabler) 3.00.000.0+
+ [DLSS Enabler Bridge 2077](https://github.com/gramern/cp77-dlss-enabler-bridge) 0.3.4.0+ _(the dll file is included in this repo)_

# Intended results
**Anti-ghosting:**

Since 4.0.0-alpha, thanks to a major change in how masks are projected (using the game's world space-to-screen space method, vehicle's position, and camera data to project and transform masks in real-time), the mod is usable with FSR3 FG ON at lower framerates (30+ fps interpolated to 60+ fps, e.g.). The new mask mapping algorithm for vehicles introduced in 4.8.0xl-alpha2 brought further improvements in smoothness at lower framerates.

**Contextual Frame Generation:** 

While there are no framerate limits to use this feature, 55+ base FPS (without frame generation) is recommended due to the perceived smoothness difference between frame generation ON and OFF states.

# Supported screens
The mod supports 16:9, 16:10, 21:9, 32:9 and 4:3 screens.

# Installation
Extract the mod's zip archive to your Cyberpunk 2077 folder.

# Using the repo from within the mod's WolvenKit project folder
The repo is configured to be placed 'as is' in the `source` folder of the mod's WolvenKit project. To avoid `*.reds` files being indexed twice by Redscript extensions for VSCode, open the `source` folder in the IDE directly.

# Translations for the mod
The mod supports UI translations. Necessary information on how to prepare a translation (which you can publish later on Nexus) can be found [here](docs/create-custom-translation.md) and [here](resources/bin/x64/plugins/cyber_engine_tweaks/mods/FrameGenGhostingFix/Translations/Translation-Blueprint.lua).

# The mod's whiteboard on Miro (rough design notes)
[https://miro.com/app/board/uXjVNrZBovU=/](https://miro.com/app/board/uXjVNrZBovU=/)

# Collaborators and Contributors
@gramern - the idea, design, programming

@danyalzia - programming (especially the Contextual module's logic), code refactoring and advice

@Neclaex - the mod's translation system base contribution

# The mod's releases
Previous and current releases can be found on [the mod's Nexus Mods page](https://www.nexusmods.com/cyberpunk2077/mods/13029).
