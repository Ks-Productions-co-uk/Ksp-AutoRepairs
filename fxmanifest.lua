fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'The-Last-Knight @ Ks Productions' ("https://discord.gg/7M7tZcKCrM")
description 'Auto Repairs & Car Wash'
version '1.0.0'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/carwash.lua'
}

server_script 'server/main.lua'

shared_scripts {
    'shared/config.lua',
    'lang/en.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}

