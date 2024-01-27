-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- function dump(o)
--     if type(o) == 'table' then
--        local s = '{ '
--        for k,v in pairs(o) do
--           if type(k) ~= 'number' then k = '"'..k..'"' end
--           s = s .. '['..k..'] = ' .. dump(v) .. ','
--        end
--        return s .. '} '
--     else
--        return tostring(o)
--     end
--  end


-- -- Path for the file to read
-- local path = system.pathForFile( "/res/texts/pirate.txt", system.ResourceDirectory )

-- print(path)
-- -- Open the file handle
-- local file, errorString = io.open( path, "r" )

-- local pirateJoke = {}
 
-- if not file then
--     -- Error occurred; output the cause
--     print( "File error: " .. errorString )
-- else
--     -- Output lines
--     for line in file:lines() do
--         table.insert( pirateJoke, line )
--         print( line )
--     end
--     -- Close the file handle
--     io.close( file )
-- end

-- -- dump( pirateJoke )
 
-- file = nil


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )