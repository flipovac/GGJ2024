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
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local function onNextBtnRelease()

	composer.removeScene( "intro-backstory", false )
	composer.gotoScene( "rules", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )

	local options =
	{
		channel = 1,
		loops = -1,
		fadein = 2000,
	}

	audio.play( introSound, options )
    local sceneGroup = self.view
	local nextBtn
	local playBtn

    local background = display.newImageRect( "res/img/background/intro-backstory.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	local paperOrnamentFoxy = display.newImageRect( "res/img/foxy-drawing.png", 462 * 0.9, 366 * 0.9 )
	paperOrnamentFoxy.anchorX = 1
	paperOrnamentFoxy.anchorY = 1
	paperOrnamentFoxy.x = screenW * 0.65
	paperOrnamentFoxy.y = screenH * 1.06

	local shiftDown = 20

    local storyText1 = display.newText( "In the bustling town of dreams, I, Oliver, \naspired to be a doctor or lawyer, \nbut my comedy-loving parents, \nshut down my career plans with a resounding, \n\"No, you're going to be a comedian!\"", 0, 0, native.systemFont, 24 )
    storyText1.x = halfW + 90 ; storyText1.y = 230 + shiftDown
    storyText1:setFillColor( 0, 0, 0 )
    storyText1.alpha = 0
    storyText1.anchorX = 0

    local storyText2 = display.newText( "Armed with jokes that even dad would cringe at, \nI now embrace the challenge, \naiming to be the town's worst comedian.", 0, 0, native.systemFont, 24 )
    storyText2.x = halfW + 90 ; storyText2.y = 360 + shiftDown
    storyText2:setFillColor( 0, 0, 0 )
    storyText2.alpha = 0
    storyText2.anchorX = 0

    local storyText3 = display.newText( "It's not laughs I'm after, \nit's the freedom to pursue my dreams \nbeyond the spotlight.", 0, 0, native.systemFont, 24 )
    storyText3.x = halfW + 90 ; storyText3.y = 465 + shiftDown
    storyText3:setFillColor( 0, 0, 0 )
    storyText3.alpha = 0
    storyText3.anchorX = 0

    local storyText4 = display.newText( "Let the rebellious journey begin!", 0, 0, native.systemFont, 24 )
    storyText4.x = halfW + 160 ; storyText4.y = 570 + shiftDown
    storyText4:setFillColor( 0, 0, 0 )
    storyText4.alpha = 0
    storyText4.anchorX = 0


    nextBtn = widget.newButton{
		defaultFile = "res/img/button/arrow-next-button.png",
		overFile = "res/img/button/arrow-next-button-clicked.png",
		width = 210, height = 100,

		onRelease = onNextBtnRelease,
		isEnabled = false,
	}
    nextBtn.anchorX = 0.5
    nextBtn.anchorY = 0.5
	nextBtn.x = display.contentWidth + display.screenOriginX + 220
	nextBtn.y = display.contentHeight - 80 + display.screenOriginY


    local curtainLeft = display.newImageRect( "res/img/background/curtain-left.png", display.actualContentWidth, display.actualContentHeight )
	curtainLeft.anchorX = 0
	curtainLeft.anchorY = 0
	curtainLeft.x = 0 + display.screenOriginX 
	curtainLeft.y = 0 + display.screenOriginY
	-- curtainLeft.alpha = 0

	
	local curtainRight = display.newImageRect( "res/img/background/curtain-right.png", display.actualContentWidth, display.actualContentHeight )
	curtainRight.anchorX = 0
	curtainRight.anchorY = 0
	curtainRight.x = 0 + display.screenOriginX 
	curtainRight.y = 0 + display.screenOriginY
	-- curtainRight.alpha = 0


	local function onPlayBtnRelease()

		transition.to(
			playBtn, 
			{
				time=700, 
				delay=100,
				alpha=0,     
				onComplete = function()
					if playBtn then
						playBtn:removeSelf()
						playBtn = nil
					end
					nextBtn:setEnabled( true )
				end
			}
		)

		transition.to(
			curtainLeft, 
			{
				time=3300, 
				delay=700,
				x=-screenW,     
				onComplete = function()
				end
			}
		)

		transition.to(
			curtainRight, 
			{
				time=3600, 
				delay=800,
				x=screenW + display.screenOriginX,     
				onComplete = function()
					-- isShowCardsTransition = false
				end
			}
		)

		transition.to( storyText1, { time=2500, delay=2000, alpha=1 } )
		transition.to( storyText2, { time=2500, delay=4500, alpha=1 } )
		transition.to( storyText3, { time=2500, delay=6000, alpha=1 } )
		transition.to( storyText4, { time=2500, delay=8500, alpha=1 } )
		
		return true	-- indicates successful touch
	end
	
    playBtn = widget.newButton{
		defaultFile = "res/img/button/play-button.png",
		overFile = "res/img/button/play-button-pressed.png",
		width = 537 * 0.5, height = 476 * 0.5,
		onRelease = onPlayBtnRelease	-- event listener function
	}
    playBtn.anchorX = -0.5
    playBtn.anchorY = -0.5
	playBtn.x = halfW + display.screenOriginX + 20
	playBtn.y = display.contentHeight * 0.6


    sceneGroup:insert( background )
	sceneGroup:insert( paperOrnamentFoxy )
    sceneGroup:insert( storyText1 )
    sceneGroup:insert( storyText2 )
    sceneGroup:insert( storyText3 )
    sceneGroup:insert( storyText4 )
	sceneGroup:insert( nextBtn )

	sceneGroup:insert( curtainLeft )
	sceneGroup:insert( curtainRight )
	sceneGroup:insert( curtainRight )
	sceneGroup:insert( curtainRight )
	sceneGroup:insert( curtainRight )
	sceneGroup:insert( playBtn )

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

		local options =
		{
			channel = 1,
			loops = -1,
			fadein = 2000,
		}

		audio.play( introSound, options )
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

    -- if nextBtn then
	-- 	nextBtn:removeSelf()	-- widgets must be manually removed
	-- 	nextBtn = nil
	-- end

	-- if playBtn then
	-- 	playBtn:removeSelf()	-- widgets must be manually removed
	-- 	playBtn = nil
	-- end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
