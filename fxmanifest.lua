fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
games { 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
name 'w_inventory'
author 'Initial Commit made by younNGG97 on Discord'
version '2.4.5'
repository ''
description 'Slot-based inventory with item metadata support'

dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql',
    'w_lib',
}

-- Drop-in replacements: resources that depend on a native framework inventory
-- are allowed to start while w_inventory provides its compatibility API.
provide 'vorp_inventory'
provide 'rsg-inventory'
provide 'qbr-inventory'

-- w_lib's bootstrap runs first: it defines w / lib / cache / locale for every later script.
shared_scripts {
    '@w_lib/init.lua',
    'config.lua',
}

-- modules loaded ahead of time (w_lib 4.0 module folders)
w_lib {
    'locale',
    'table',
    'math',
    'rawKeys',   -- client: raw keys for opening the bag and the shortcuts
    'prompt',    -- client: the walk-up prompt of shops / benches / stashes / evidence
    'dataview',  -- GUID stores for the dual-wield system
    'component', -- client: the clothing tab (what is worn, taking it off and putting it back on)
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua',
    'server_debt.lua',
    'server_purge.lua', -- PurgeCharacter: w_core's character deletion
}

client_script 'init.lua'

ui_page 'web/build/index.html'

files {
    'client.lua',
    'server.lua',
    'config.lua',
    'locales/*.json',
    'web/build/index.html',
    'web/build/*.css',
    'web/build/assets/*.js',
    'web/build/assets/*.png',
    'web/build/assets/*.ttf',
    'web/build/assets/*.woff2',
    'web/build/fonts/*.otf',
    'web/build/fonts/*.ttf',
    'web/build/fonts/*.woff2',
    'web/build/fonts/*.css',
    -- w_crafting's art and sounds (RDR2 textures + the menu's sounds)
    'web/build/tex/ui/*.png',
    'web/build/sounds/*.mp3',
    'web/images/*.png',
    'modules/items/catalog.lua',
    'modules/items/native_assets.lua',
    'modules/mysql/rsg.lua',
    'modules/weapon/rsg.lua',
    'modules/bridge/rsg/native_client.lua',
    'modules/**/shared.lua',
    'modules/**/client.lua',
    -- The patterns above match the file's name and not its path, so any module with another name is named explicitly
    'modules/weapon/dualwield.lua',
    'modules/bridge/rsg/client.lua',
    'modules/bridge/rsg/server.lua',
    'modules/bridge/rsg/compat.lua',
    'modules/bridge/vorp/client.lua',
    'modules/bridge/vorp/server.lua',
    'modules/bridge/vorp/compat.lua',
    'modules/bridge/qbr/client.lua',
    'modules/bridge/qbr/server.lua',
    'modules/bridge/qbr/compat.lua',
    'modules/bridge/wlib/client.lua',
    'modules/bridge/wlib/server.lua',
    'data/*.lua',
}
