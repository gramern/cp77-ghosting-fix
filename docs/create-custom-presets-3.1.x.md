# Create custom anti-ghosting presets for FrameGen Ghosting 'Fix' 3.1.x

FrameGen Ghosting 'Fix' uses predefined .inkwidget files to store masks (widgets) that are used to locally block certain parts of an interpolated frame from occurring on the screen. For version 3.1.x, masks for vehicles are stored and defined in the `fgfixcars.inkwidget` file. Those masks' visibility and size, while predefined, are dynamically changed to improve frame generation anti-ghosting and improve a player's experience.

This manual will briefly explain how to create your anti-ghosting presets that may be used to better fit your preferences, customize anti-ghosting for your average framerate, or just for fun and learning purposes - this manual is for anyone who likes to tinker and learn new stuff.

**Some knowledge of how Lua's tables are built and skills on how to follow a presented pattern without breaking it are required.**

## Creating your anti-ghosting preset

1. Open the `Presets` folder which you can find in Cyberpunk's `.../bin/x64/plugins/cyber_engine_tweaks/mods/FrameGenGhostingFix` path after installing the mod in version 3.1.x. You will see a few `*.lua` preset files there.

2. Copy and paste in the same `Presets` folder one `*.lua` preset file of your choice.

3. Give the file a new, preferred name, like `MyPreset.lua`. It will be best if you don't use spaces.

4. Open the renamed file using your preferred text editor.

5. Inside you will find a structure similar to [this](https://github.com/gramern/cp77-ghosting-fix/blob/main/cet_lua_addon/Presets/LessMasking_60FPS.lua). It is a Lua's table used to store settings for anti-ghosting presets. Keep your text editor with the file open.

6. Open [`Presets.lua`](https://github.com/gramern/cp77-ghosting-fix/blob/main/cet_lua_addon/Modules/Presets.lua) here and for your convenience, copy lines with a predefined 'Default' preset: lines [39 to 71](https://github.com/gramern/cp77-ghosting-fix/blob/6ad3d9cc76adda9611e71ab21bc8a0d125479b9f/cet_lua_addon/Modules/Presets.lua#L39-L71) for most screens' aspect ratios or [75 to 107](https://github.com/gramern/cp77-ghosting-fix/blob/6ad3d9cc76adda9611e71ab21bc8a0d125479b9f/cet_lua_addon/Modules/Presets.lua#L75-L107) for 4:3.

7. Paste one of those in place of lines [4 to 35](https://github.com/gramern/cp77-ghosting-fix/blob/6ad3d9cc76adda9611e71ab21bc8a0d125479b9f/cet_lua_addon/Presets/LessMasking_60FPS.lua#L4-L35) in your new preset file, opened in the text editor.

8. Now look at the image below:
![dumbo_map](https://github.com/gramern/cp77-ghosting-fix/assets/159150855/8374dc8c-775b-4a54-9716-b03c9ba98f6e)

The picture shows how masks, called 'dumbos' are located on the screen. In a preset file, you can define X and Y dimensions for 'dumbo1', 'dumbo2', and 'dumbo3'. Opacities can be set for all dumbos and additionally for 'dynamic_dumbo1', 'dynamic_dumbo2' and 'dynamic_dumbo3' which aren't shown on the map above. |The mask 'dynamic dumbo1' is located at the bottom of the screen, while '2' and '3' are somewhere on its left and right edges.

**[This](https://miro.com/app/board/uXjVNrZBovU=/) Miro board is handy when understanding how the mod works.**

9. Your new preset's table lets you set dimension and opacity values mentioned above for the game's camera perspectives in vehicles while running at different speeds, as explained in [the first line](https://github.com/gramern/cp77-ghosting-fix/blob/6ad3d9cc76adda9611e71ab21bc8a0d125479b9f/cet_lua_addon/Presets/LessMasking_60FPS.lua#L1) of the file. 'TPP' serves for perspective 'TPPClose' and 'TPPMedium', while 'TPPFar' for 'TPPFar' is the farthest perspective when driving/riding a vehicle.

10. Different speeds ('crawl', 'slow', 'faster', 'full') settings serve to create smooth dimensions and opacity transitions, as the mod turns off masking when a vehicle is stationary. Higher opacity values give better anti-ghosting masking (and frame generation blocking). An opacity value of '0.05' is usually enough to make a mask barely noticeable and fully effective.

11. For starters, change opacities to '1.0' and have fun observing how they cover certain areas of the screen. You can change dimensions for the three main masks, to increase/decrease masking areas.

12. Change the name of your new preset using the `name` and `display` parameter for "My Preset" e.g. Your new preset's displayname will appear in the mod's ImGui window on a dropdown list. You can also set the preset's description and author.

13. To have your preset support translations put `local UITranslation = require("Modules/Translation")` above `local Preset = {`

14. Add `UITranslation.Presets.<AuthorNameHere>.<PresetNameHere>.name or ` before your `display`'s value and `UITranslation.Presets.<AuthorNameHere>.<PresetNameHere>.description or ` before your `description`'s value to allow translations to be shown on the UI

15. Edit the file in different ways following the pattern. Save the file, run the game, observe, and iterate. 

16. Have fun!
