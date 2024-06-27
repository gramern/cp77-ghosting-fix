# Create custom translation for FrameGen Ghosting 'Fix'

FrameGen Ghosting 'Fix' uses a localization system that automatically reads the UI language setting from the game and then looks for the appropriate translation file. This means that translations must follow a precise structure in order to be displayed.

**Some knowledge of how Lua's tables are built and skills on how to follow a presented pattern without breaking it are required.**

## Creating your anti-ghosting translation
1. Download the translation blueprint and open the `Translations` folder which you can find in `.../bin/x64/plugins/cyber_engine_tweaks/mods/FrameGenGhostingFix/Translations`.
2. Open the `Translation-Blueprint.lua` file with your preferred text editor
3. Rename the file to fit to your translation's language:

    | Language             | Filename             |
    | ----------------- | ----------------------- |
    | Arabic | `ar-ar.lua` |
    | Chinese (Simplified) | `zh-cn.lua` |
    | Chinese (Traditional) | `zh-tw.lua` |
    | Czech | `cz-cz.lua` |
    | French | `fr-fr.lua` |
    | German |`de-de.lua` |
    | Hungarian | `hu-hulua` |
    | Italian | `it-it.lua` |
    | Japanese | `jp-jp.lua` |
    | Korean | `kr-kr.lua` |
    | Polish | `pl-pl.lua` |
    | Portuguese (Brazillian) | `pr-br.lua` |
    | Russian | `ru-ru.lua` |
    | Spanish | `es-es.lua` |
    | Spanish (Latin American) | `es-mx.lua` |
    | Thai | `th-th.lua` |
    | Turkish | `tr-tr.lua` |
    | Ukrainian | `ua-ua.lua` |
4. Transalte the values of each key with string values. If you don't know a specifc translation, just keep it in english or comment it out by putting `-- ` at the beginning of the line.
5. Presets are using IDs. The ID has to be the key and between brackets `[]`. Here is the structure for the preset with the ID `99`:
  ```lua
    -- inside translation file
    Presets = {
        -- Other keys
        Info = {
            [99] = {
                name = "Name of the preset",
                description = "Description of the preset",
            },
        },
    },
  ```
5. Save the file.
6. Go pack to your root path with the `bin` folder. Right click the folder and press `compress in ZIP` or use any other preferred Tool for it.
7. Upload your `.zip` file if you want to publish it.

