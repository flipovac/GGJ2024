-----------------------------------------------------------------------------------------
--
-- scene.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local widget = require "widget"

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImageRect( "res/img/background/scene.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY

	local crowdImgs = {}

	-- ------------------------------------------------------ ROW 3 --------------------------------------------------------------

	local lastRowCharHeight = 185

	crowdImgs[1] = display.newImageRect( "res/img/characters/shark-neutral.png", 0.977 * lastRowCharHeight, lastRowCharHeight )
	crowdImgs[1].anchorX = 0.5
	crowdImgs[1].anchorY = 0.5
	crowdImgs[1].x = background.width * 0.325 + display.screenOriginX 
	crowdImgs[1].y = background.height * 0.303 + display.screenOriginY 

	crowdImgs[2] = display.newImageRect( "res/img/characters/bird-angry.png", 0.977 * lastRowCharHeight, lastRowCharHeight )
	crowdImgs[2].anchorX = 0.5
	crowdImgs[2].anchorY = 0.5
	crowdImgs[2].x = background.width * 0.438 + display.screenOriginX 
	crowdImgs[2].y = background.height * 0.303 + display.screenOriginY 

	crowdImgs[3] = display.newImageRect( "res/img/characters/pirate-angry.png", 0.977 * lastRowCharHeight, lastRowCharHeight )
	crowdImgs[3].anchorX = 0.5
	crowdImgs[3].anchorY = 0.5
	crowdImgs[3].x = background.width * 0.548 + display.screenOriginX 
	crowdImgs[3].y = background.height * 0.303 + display.screenOriginY 

	crowdImgs[4] = display.newImageRect( "res/img/characters/cat-neutral.png", 0.977 * lastRowCharHeight, lastRowCharHeight )
	crowdImgs[4].anchorX = 0.5
	crowdImgs[4].anchorY = 0.5
	crowdImgs[4].x = background.width * 0.654 + display.screenOriginX 
	crowdImgs[4].y = background.height * 0.303 + display.screenOriginY 


	-- ------------------------------------------------------ ROW 2 --------------------------------------------------------------

	local middleRowCharHeight = 205

	crowdImgs[5] = display.newImageRect( "res/img/characters/bird-neutral.png", 0.977 * middleRowCharHeight, middleRowCharHeight )
	crowdImgs[5].anchorX = 0.5
	crowdImgs[5].anchorY = 0.5
	crowdImgs[5].x = background.width * 0.25 + display.screenOriginX 
	crowdImgs[5].y = background.height * 0.43 + display.screenOriginY 

	crowdImgs[6] = display.newImageRect( "res/img/characters/bird-neutral.png", 0.977 * middleRowCharHeight, middleRowCharHeight )
	crowdImgs[6].anchorX = 0.5
	crowdImgs[6].anchorY = 0.5
	crowdImgs[6].x = background.width * 0.37 + display.screenOriginX 
	crowdImgs[6].y = background.height * 0.43 + display.screenOriginY 

	crowdImgs[7] = display.newImageRect( "res/img/characters/bird-neutral.png", 0.977 * middleRowCharHeight, middleRowCharHeight )
	crowdImgs[7].anchorX = 0.5
	crowdImgs[7].anchorY = 0.5
	crowdImgs[7].x = background.width * 0.497 + display.screenOriginX 
	crowdImgs[7].y = background.height * 0.43 + display.screenOriginY 

	crowdImgs[8] = display.newImageRect( "res/img/characters/cat-neutral.png", 0.977 * middleRowCharHeight, middleRowCharHeight )
	crowdImgs[8].anchorX = 0.5
	crowdImgs[8].anchorY = 0.5
	crowdImgs[8].x = background.width * 0.626 + display.screenOriginX 
	crowdImgs[8].y = background.height * 0.43 + display.screenOriginY 

	crowdImgs[9] = display.newImageRect( "res/img/characters/bird-neutral.png", 0.977 * middleRowCharHeight, middleRowCharHeight )
	crowdImgs[9].anchorX = 0.5
	crowdImgs[9].anchorY = 0.5
	crowdImgs[9].x = background.width * 0.75 + display.screenOriginX 
	crowdImgs[9].y = background.height * 0.43 + display.screenOriginY 

	-- ------------------------------------------------------ ROW 2 --------------------------------------------------------------

	local firstRowCharHeight = 225

	crowdImgs[10] = display.newImageRect( "res/img/characters/cat-neutral.png", 0.977 * firstRowCharHeight, firstRowCharHeight )
	crowdImgs[10].anchorX = 0.5
	crowdImgs[10].anchorY = 0.5
	crowdImgs[10].x = background.width * 0.293 + display.screenOriginX 
	crowdImgs[10].y = background.height * 0.58 + display.screenOriginY 

	crowdImgs[11] = display.newImageRect( "res/img/characters/shark-neutral.png", 0.977 * firstRowCharHeight, firstRowCharHeight )
	crowdImgs[11].anchorX = 0.5
	crowdImgs[11].anchorY = 0.5
	crowdImgs[11].x = background.width * 0.44 + display.screenOriginX 
	crowdImgs[11].y = background.height * 0.58 + display.screenOriginY 

	crowdImgs[12] = display.newImageRect( "res/img/characters/dog-neutral.png", 0.977 * firstRowCharHeight, firstRowCharHeight )
	crowdImgs[12].anchorX = 0.5
	crowdImgs[12].anchorY = 0.5
	crowdImgs[12].x = background.width * 0.59 + display.screenOriginX 
	crowdImgs[12].y = background.height * 0.58 + display.screenOriginY 

	crowdImgs[13] = display.newImageRect( "res/img/characters/pirate-neutral.png", 0.977 * firstRowCharHeight, firstRowCharHeight )
	crowdImgs[13].anchorX = 0.5
	crowdImgs[13].anchorY = 0.5
	crowdImgs[13].x = background.width * 0.735 + display.screenOriginX 
	crowdImgs[13].y = background.height * 0.58 + display.screenOriginY 

    sceneGroup:insert( background )


	-- crowdImgs[i] = display.newImageRect( "res/img/characters/bird-neutral.png", 0.977 * guestPosition[3], guestPosition[3] )
	-- crowdImgs[i].anchorX = 0.5
	-- crowdImgs[i].anchorY = 0.5
	-- crowdImgs[i].x = background.width * guestPosition[1] + display.screenOriginX 
	-- crowdImgs[i].y = background.height * guestPosition[2] + display.screenOriginY 



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

    if showCardsBtn then
		showCardsBtn:removeSelf()	-- widgets must be manually removed
		showCardsBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
