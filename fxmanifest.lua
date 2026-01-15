game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'leo-core'
author 'LEO-CORE Development'
description 'Comprehensive Law Enforcement System for RedM with MDT'
version '3.0.0'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js",
    "ui/main.css",
    "ui/styles/police.css",
    "ui/badges/police.png",
    "ui/badges/sheriff.png",
    "ui/badges/marshal.png",
    "ui/badges/ranger.png",
    "ui/badges/army.png",
    "ui/bg.jpg",
    "ui/mugshot.png"
}

shared_scripts {
    'config.lua',
    'config_leo.lua',
}

client_scripts {
    'config.lua',
    'config_leo.lua',
    'cl_mdt.lua',
    'client_leo.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'config_leo.lua',
    'bridge.lua',
    'sv_mdt.lua',
    'server_leo.lua',
    'version.lua',
}

lua54 'yes'