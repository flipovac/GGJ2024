-----------------------------------------------------------------------------------------
--
-- intro-backstory.lua
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
	composer.removeScene( "intro-backstory", false )
	-- go to level1.lua scene
	composer.gotoScene( "intro-backstory", "fade", 500 )
	
	return true	-- indicates successful touch
end


function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImageRect( "res/img/background/intro-backstory.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY


    local storyText1 = display.newText( "Hello", 0, 0, native.systemFont, 26 )
    storyText1.x = 50 ; storyText1.y = 120
    storyText1:setFillColor( 0, 0, 0 )
    storyText1.alpha = 0
    storyText1.anchorX = 0
    storyText1.text = "In the lively town of dreams, I, Oliver, aspired to be a doctor or lawyer, \nbut my comedy-loving parents thrust me onto the stage."


    local storyText2 = display.newText( "Hello", 0, 0, native.systemFont, 26 )
    storyText2.x = 50 ; storyText2.y = 190
    storyText2:setFillColor( 0, 0, 0 )
    storyText2.alpha = 0
    storyText2.anchorX = 0
    storyText2.text = "Armed with amazing jokes, I now embrace the challenge, \naiming to be the town's worst comedian."


    local storyText3 = display.newText( "Hello", 0, 0, native.systemFont, 26 )
    storyText3.x = 50 ; storyText3.y = 260
    storyText3:setFillColor( 0, 0, 0 )
    storyText3.alpha = 0
    storyText3.anchorX = 0
    storyText3.text = "It's not just laughs I'm after; \nit's the freedom to pursue my dreams beyond the spotlight."


    local storyText4 = display.newText( "Hello", 0, 0, native.systemFont, 26 )
    storyText4.x = 50 ; storyText4.y = 320
    storyText4:setFillColor( 0, 0, 0 )
    storyText4.alpha = 0
    storyText4.anchorX = 0
    storyText4.text = "Let the rebellious journey begin!"


    transition.to( storyText1, { time=1500, delay=0, alpha=1 } )
    transition.to( storyText2, { time=1500, delay=1500, alpha=1 } )
    transition.to( storyText3, { time=1500, delay=3000, alpha=1 } )
    transition.to( storyText4, { time=1500, delay=4500, alpha=1 } )


    playBtn = widget.newButton{
		defaultFile = "res/img/button/arrow-next-button.png",
		overFile = "res/img/button/arrow-next-button-clicked.png",
		width = 210, height = 100,
		onRelease = onPlayBtnRelease	-- event listener function
	}
    playBtn.anchorX = -1
    playBtn.anchorY = -1
	playBtn.x = display.contentWidth - 125
	playBtn.y = display.contentHeight - 125
	

    sceneGroup:insert( background )
    sceneGroup:insert( storyText1 )
    sceneGroup:insert( storyText2 )
    sceneGroup:insert( storyText3 )
    sceneGroup:insert( storyText4 )

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
