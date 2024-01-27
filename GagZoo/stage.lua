------------------------------------------
-- Postoji vrsta publike, svaki tip publike ima svoj tip i on reagira na neki nacin na joke 
-- Postoji vrsta joke-a, svaki joke pozitivno, negativno ili neutralno na neku kategoriju publike (+, - , 0)
-- Player ima za izbor jedan od 3-4 kartice, svaka kartica je jedan joke (hoce li biti neki uvijek random)
-- Snimiti prezentaciju likova koji su u publici, zivotinje i onda pirat (wait, a pirat ?!)
-- odlazi publika koja nije zadovoljna i zamjenjuje se random novom publikom
-- kartice koje dolaze sa jokes se prvo sortiraju na random i onda idu po indeksu
------------------------------------------

-----------------------------------------------------------------------------------------
--
-- stage.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	
	-- all display objects must be inserted into group
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene