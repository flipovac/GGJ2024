-----------------------------------------------------------------------------------------
--
-- cards-show.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------
local widget = require "widget"

-- forward declarations and other locals
local showCardsBtn
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImageRect( "res/img/background/scene.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY

	local cardsGroup = display.newGroup()
	local isShowCardsTransition = false

	local function onShowCardsBtnRelease()
		if ( isShowCardsTransition ~= true ) then
			isShowCardsTransition = true
			transition.to(
				cardsGroup, {
					time=1500, 
					delay=100,
					y=screenH/2,     
					onComplete = function()
						isShowCardsTransition = false
					end
				}
			)
		end
		return true	-- indicates successful touch
	end

    showCardsBtn = widget.newButton{
		label = "SHOW CARDS",
		defaultFile = "res/img/button/arrow-next-button.png",
		overFile = "res/img/button/arrow-next-button-clicked.png",
		width = 210, height = 100,
		onRelease = onShowCardsBtnRelease	-- event listener function
	}
    showCardsBtn.anchorX = -1
    showCardsBtn.anchorY = -1
	showCardsBtn.x = display.contentWidth - 125
	showCardsBtn.y = display.contentHeight - 125

	local cards = {}


	local function selectCard( cardIndex ) 
		for i, card in pairs(cards) do
			if ( i == cardIndex ) then
				transition.to(
					card, {
						time=1000, 
						delay=2000,
						alpha=0,     
						-- onComplete = function()
						-- 	isShowCardsTransition = false
						-- end
					}
				)
			else
				transition.to(
					card, {
						time=1000, 
						delay=50,
						alpha=0,     
						-- onComplete = function()
						-- 	isShowCardsTransition = false
						-- end
					}
				)
			end
			-- print(i, card)
		end
	end

	local function cardTapListener( event )
		-- TODO handle only one tap
		-- cards[1]:removeEventListener()
		-- cards[2]:removeEventListener()
		-- cards[3]:removeEventListener()	

		print(event.target.id)
		selectCard( event.target.id )

	end


	local cardWidth = 600

	cards[1] = display.newImageRect( "res/img/note.png", cardWidth * 0.69, cardWidth )
	cards[1].id = 1
	cards[1].anchorX = 0.5
	cards[1].anchorY = 0.5
	cards[1]:rotate( -3 )
	cards[1].x = -530 * 0.69
	cards[1].y = 0
	cards[1]:addEventListener( "tap", cardTapListener ) 


	cards[2] = display.newImageRect( "res/img/note.png", cardWidth * 0.69, cardWidth )
	cards[2].id = 2
	cards[2].anchorX = 0.5
	cards[2].anchorY = 0.5
	cards[2].x = 0
	cards[2].y = 0 - 30
	cards[2]:addEventListener( "tap", cardTapListener ) 

	cards[3] = display.newImageRect( "res/img/note.png", cardWidth * 0.69, cardWidth )
	cards[3].id = 3
	cards[3].anchorX = 0.5	
	cards[3].anchorY = 0.5
	cards[3]:rotate( 3 )
	cards[3].x = 530 * 0.69
	cards[3].y = 0
	cards[3]:addEventListener( "tap", cardTapListener ) 



	cardsGroup:insert( cards[1] )
    cardsGroup:insert( cards[2] )
    cardsGroup:insert( cards[3] )

	cardsGroup.x = halfW
	cardsGroup.y = screenH * 2	
	

    sceneGroup:insert( background )
    sceneGroup:insert( cardsGroup )
	-- sceneGroup:insert( card1 )
    -- sceneGroup:insert( card2 )
    -- sceneGroup:insert( card3 )

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
