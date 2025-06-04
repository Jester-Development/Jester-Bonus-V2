fx_version 'cerulean'
game 'gta5'

author 'Jester­'
description 'Jester-bonusV2 Custom ui en simple moderne look'
version '2.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

client_scripts {
    'config.lua',
    'client.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',
    'nui/script.js',
}

lua54 'yes'