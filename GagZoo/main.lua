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

helper.populateTable( pirateJokes, "res/text/pirate.txt" )
helper.populateTable( catJokes, "res/text/cat.txt" )
helper.populateTable( dogJokes, "res/text/dog.txt" )
helper.populateTable( sharkJokes, "res/text/shark.txt" )
helper.populateTable( birdJokes, "res/text/bird.txt" )

helper.shuffleTable( pirateJokes )

-- print( #pirateJokes )
-- for i,v in ipairs(pirateJokes) do print(i,v) end


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )