-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local helper = require "helper"
local json = require "json"

pirateJokes = {}
catJokes = {}
dogJokes = {}
sharkJokes = {}
birdJokes = {}

helper.populateTable( pirateJokes, "res/jokes/pirate.txt" )
helper.populateTable( catJokes, "res/jokes/cat.txt" )
helper.populateTable( dogJokes, "res/jokes/dog.txt" )
helper.populateTable( sharkJokes, "res/jokes/shark.txt" )
helper.populateTable( birdJokes, "res/jokes/bird.txt" )

-- read json configuration and load

jsonConfiguration = {}

local filename = system.pathForFile( "res/config.json", system.ResourceDirectory)
jsonConfiguration, pos, msg = json.decodeFile(filename)
if not jsonConfiguration then
    error(msg)
end
-- print( #pirateJokes )
-- for i,v in ipairs(pirateJokes) do print(i,v) end


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

introSound = audio.loadSound( "res/audio/intro.wav" )
gameplaySound = audio.loadSound( "res/audio/gameplay.wav" )
-- load menu screen
composer.gotoScene( "stage" )