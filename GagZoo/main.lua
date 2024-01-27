-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local helper = require "helper"

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

helper.shuffleTable( pirateJokes )

-- print( #pirateJokes )
-- for i,v in ipairs(pirateJokes) do print(i,v) end


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )