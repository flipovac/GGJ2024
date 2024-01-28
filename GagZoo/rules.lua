-----------------------------------------------------------------------------------------
--
-- rules.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local widget = require "widget"

-- forward declarations and other locals
local playBtn
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local function onPlayBtnRelease()
	composer.removeScene( "rules", false )
	-- go to level1.lua scene
	composer.gotoScene( "stage", "fade", 500 )
	
	return true	-- indicates successful touch
end


function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImageRect( "res/img/background/rules.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY

    local characterInitialHeight = 400
    local characterFinalHeight = 170

    local categories = { 'cat', 'dog', 'shark', 'bird', 'pirate' }
    local categoryFinalX = { 0.26, 0.38, 0.5, 0.63, 0.74 }

    local crowd = {}

    for index, crowdType in pairs(categories) do
        crowd[index] = display.newImageRect( "res/img/characters/" .. crowdType .. "-neutral.png", 0.977 * characterInitialHeight, characterInitialHeight )
        crowd[index].anchorX = 0.5
        crowd[index].anchorY = 0.5
        crowd[index].x = background.width * 0.5 + display.screenOriginX 
        crowd[index].y = background.height * 0.4 + display.screenOriginY 
        crowd[index].alpha = 0
    end

    local start = 500

    for index, xValue in pairs(categoryFinalX) do
        transition.to( crowd[index], { time=1000, delay=start, alpha=1 } )
        transition.to( crowd[index], { 
            time=1000,
            delay=start + 1000, 
            width=0.977 * characterFinalHeight, 
            height=characterFinalHeight, 
            x = background.width * xValue + display.screenOriginX,
            y = background.height * 0.89 + display.screenOriginY
        } )

        start = start + 2000

    end

    playBtn = widget.newButton{
		defaultFile = "res/img/button/arrow-next-button.png",
		overFile = "res/img/button/arrow-next-button-clicked.png",
		width = 210, height = 100,
		onRelease = onPlayBtnRelease	-- event listener function
	}
    playBtn.anchorX = 0.5
    playBtn.anchorY = 0.5
	playBtn.x = display.contentWidth + display.screenOriginX + 220
	playBtn.y = display.contentHeight - 80 + display.screenOriginY
	

    sceneGroup:insert( background )
    sceneGroup:insert( crowd[1] )
    sceneGroup:insert( crowd[2] )
    sceneGroup:insert( crowd[3] )
    sceneGroup:insert( crowd[4] )
    sceneGroup:insert( crowd[5] )

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

    if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
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
