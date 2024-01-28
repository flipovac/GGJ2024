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

-- ##############################################
-- variables
-- ##############################################
local helper = require "helper"
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

math.randomseed(os.time())

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local stageCrowd = {}

local MAX_CROWD_SCORE = 100.0
local MIN_CROWD_SCORE = 0.0

local crowdSatisfaction = 0.0

local currentJokeCards = {}

local sceneGoup = nil

local guestImages = {}

local MAX_STATUS_HEIGHT = screenH / 3.0
local statusRect = {}

local jokeTextIndex = {}

local CARD_HEIGHT = 750 
local CARD_WIDTH = CARD_HEIGHT * 0.69
local CARD_ROTATION = 3

local CARD_TEXT_WIDTH = CARD_WIDTH * 0.5
local CARD_TEXT_HEIGHT = 300 --CARD_HEIGHT * 0.58 
local CARD_TEXT_SIZE = 20

local jokeCards = {}
local playedCardIndex = 0

local showCardsBtn = {}
local foxy = {}

local negativeSounds = {}
local negativeSoundsIndex = 1

local positiveSounds = {}
local positiveSoundsIndex = 1

-- Class definitions

local Crowd = {}
local Guest = {}
local Cards = {}
local Card = {}

function Crowd:new()
    local newObject = setmetatable({}, self)
	self.__index = self

    self.guests = {}

	print("kreiran crowd");
	return newObject
end

function Crowd:createStageCrowd()
	print("create guests function! ")
	local positions = jsonConfiguration["guest_positions"]
	if not positions then
		error("ERROR! Missing positions ")
	end

	for i, position in ipairs(positions) do
		print("dodan guest!");
		local newGuest = Guest:new()

		newGuest.positionIndex = i
		newGuest.position = position 
		newGuest:reset(getNextGuestType())

		self.guests[i] = newGuest 
	end
end

function Crowd:switchAngryGuests()
	for i, guest in ipairs(stageCrowd.guests) do
		if guest.state == "negative" then
			guest:reset(getNextGuestType())
		end
	end
end

function Crowd:prepareGuestImages()
	for i, guest in ipairs(stageCrowd.guests) do
		-- samo rect , fill dolazi kasnije u displayu
		guest.image = display.newRect(0, 0, 0.977 * guest.position[3], guest.position[3] )
		guest.image.anchorX = 0.5
		guest.image.anchorY = 0.5
		guest.image.x = screenW * guest.position[1] + display.screenOriginX 
		guest.image.y = screenH * guest.position[2] + display.screenOriginY 
		guest.image.isVisible = false

		guest.annoyedSymbol = display.newImageRect( "res/img/anger_symbol.png", 0.2 * guest.position[3], 0.2 * guest.position[3] )
		guest.annoyedSymbol.anchorX = 0.5
		guest.annoyedSymbol.anchorY = 0.5
		guest.annoyedSymbol.rotation = 30
		guest.annoyedSymbol.x = screenW * guest.position[1] + display.screenOriginX + guest.position[3] / 4.5 
		guest.annoyedSymbol.y = screenH * guest.position[2] + display.screenOriginY - guest.position[3] / 4
		guest.annoyedSymbol.isVisible = false

		sceneGroup:insert(guest.image)
		sceneGroup:insert(guest.annoyedSymbol)
	end
end

function Crowd:display()
	for i, guest in ipairs(stageCrowd.guests) do
		guest.image.fill = guestImages[guest.type][guest.state]
		guest.image.isVisible = true;

		guest.annoyedSymbol.isVisible = guest.state == "negative"
	end
end

function Guest:new()
	local newObject = setmetatable({}, self)
	self.__index = self

    self.positionIndex = {}
    self.position = {}

    self.type = nil
    self.scoreModifier = 1.0
    self.state = "neutral"

	self.image = {}
	self.annoyed_symbol = {}

	return newObject
end

function Guest:rateJoke(_jokeType)
	local jokeEffects = jsonConfiguration["joke_effects"]
	local jokeModifier = jsonConfiguration["joke_modifiers"]
	
	local jokeEffect = "neutral"
	
	-- print("Joke type: " .. _jokeType)

	-- if not jokeEffects[_jokeType]["positive"][self.type] then
	-- 	if not jokeEffects[_jokeType]["negative"][self.type] then
	-- 		jokeEffect = "neutral"
	-- 	else
	-- 		jokeEffect = "negative"
	-- 	end
	-- else
	-- 	jokeEffect = "positive"
	-- end

	-- print("Joke effect: " .. jokeEffect)

	if _jokeType == "cat" then
		if self.type == "dog" or self.type == "bird" then
			jokeEffect = "positive"
		elseif self.type == "cat" or self.type == "pirate" then 
			jokeEffect ="negative"
		end
	elseif _jokeType == "dog" then
		if self.type == "cat" then
			jokeEffect = "positive"
		elseif self.type == "dog" or self.type == "shark" then 
			jokeEffect ="negative"
		end
	elseif _jokeType == "shark" then

		if self.type == "bird" or self.type == "pirate" then
			jokeEffect = "positive"
		elseif self.type == "dog" or self.type == "shark" then 
			jokeEffect ="negative"
		end
	elseif _jokeType == "bird" then
		
		if self.type == "cat" or self.type == "shark" then
			jokeEffect = "positive"
		elseif self.type == "bird" or self.type == "pirate" then 
			jokeEffect ="negative"
		end 
	elseif _jokeType == "pirate" then
		if self.type == "shark" or self.type == "pirate" then
			jokeEffect = "positive"
		elseif self.type == "cat" or self.type == "bird" then 
			jokeEffect ="negative"
		end 
	end	

	local score = jokeModifier[jokeEffect] * self.scoreModifier

	return score, jokeEffect;
end

function Guest:reset( _type )
	self.type = _type
	self.scoreModifier = 1.0
	self.state = "neutral"
end

function Guest:setState ( _state )
	self.state = _state
end

function Guest:setType(_type)
	self.type = _type
end

function Guest:incrementModifier()
	self.scoreModifier = self.scoreModifier + 0.1
end

function Card:new()
	local newObject = setmetatable({}, self)
	self.__index = self

	self.jokeType = ""
	self.jokeText = ""
	self.isPlayed = false

	self.image = {}
	self.textRect = {}
	self.cardGroup = {}

	return newObject
end

function Card:getNextJoke()
	-- todo: dohvati novi joke iz deka/ random ali da nisu u ruci svi istog tipa
	local jokeTypes = jsonConfiguration["joke_types"] 
	local jokeIndex = math.random(0, 100) % #jokeTypes + 1
	
	self.jokeType = jokeTypes[jokeIndex]
	
	local jokesForType = jokeTextIndex[self.jokeType]

	self.jokeText = jokesForType.texts[jokesForType.index % #jokesForType.texts + 1]

	jokesForType.index = jokesForType.index + 1
end

function Cards:new()
	local newObject = setmetatable({}, self)
	self.__index = self

	self.cards = {}
	self.cardsGroup = {}
	self.cardPositions = {}
	self.isVisible = false

	return newObject
end

function Cards:createCards()
	self.cardsGroup = display.newGroup()

	local card1 = Card:new()
	card1:getNextJoke()
	self.cards[1] = card1
	self.cardPositions[1] = {
		x = -530 * 0.69,
		y = 0,
		rotation = -CARD_ROTATION
	}

	local card2 = Card:new()
	card2:getNextJoke()
	self.cards[2] = card2
	self.cardPositions[2] = {
		x = 0,
		y = -20,
		rotation = 0
	}

	card3 = Card:new()
	card3:getNextJoke()
	self.cards[3] = card3
	self.cardPositions[3] = {
		x = 530 * 0.69,
		y = 0,
		rotation = CARD_ROTATION
	}
end

function Cards:prepareCardImages()
	local textOptions =
	{
		text = "",
		x = 0,
		y = 0,
		width = CARD_TEXT_WIDTH,
		height = CARD_TEXT_HEIGHT,
		font = native.systemFont,   
		fontSize = CARD_TEXT_SIZE,
		align = "center"
	}

	for i, card in ipairs(self.cards) do
		local cardPosition = self.cardPositions[i]

		card.image = display.newImageRect( "res/img/note.png", CARD_WIDTH * 0.69, CARD_WIDTH )
		card.image.index = i
		card.image.anchorX = 0.5
		card.image.anchorY = 0.5
		card.image.x = cardPosition.x
		card.image.y = cardPosition.y
		card.image.rotation = cardPosition.rotation
		card.image:addEventListener( "tap", pickCardListener ) 
		card.image.isVisible = true

		card.textRect = display.newText(textOptions)
		card.textRect.text = card.jokeText
		card.textRect.x = cardPosition.x
		card.textRect.y = cardPosition.y
		card.textRect.rotation = cardPosition.rotation
		card.textRect:setFillColor(1,1,1)
		card.textRect.isVisible = true

		card.cardGroup = display.newGroup()
		card.cardGroup:insert(card.image)
		card.cardGroup:insert(card.textRect)

		self.cardsGroup:insert(card.cardGroup) 
	end

	self.cardsGroup.x = halfW
	self.cardsGroup.y = screenH
	self.cardsGroup.anchorX = 0.5
	self.cardsGroup.anchorY = 0.5
	self.cardsGroup.isVisible = false

	sceneGroup:insert(self.cardsGroup)
end

function Cards:replaceCardJoke(_cardIndex)
	self.cards[_cardIndex]:getNextJoke()
end

-- ##############################################
-- Functions
-- ##############################################

function shuffleAllJokes( )
	helper.shuffleTable( pirateJokes )
	helper.shuffleTable( catJokes )
	helper.shuffleTable( dogJokes )
	helper.shuffleTable( sharkJokes )
	helper.shuffleTable( birdJokes )
end

function indexJokeTexts()
	jokeTextIndex["pirate"] = {}
	jokeTextIndex["pirate"].index = 1
	jokeTextIndex["pirate"].texts = pirateJokes
	
	jokeTextIndex["cat"] = {}
	jokeTextIndex["cat"].index = 1
	jokeTextIndex["cat"].texts = catJokes
	
	jokeTextIndex["dog"] = {}
	jokeTextIndex["dog"].index = 1
	jokeTextIndex["dog"].texts = dogJokes
	
	jokeTextIndex["shark"] = {}
	jokeTextIndex["shark"].index = 1
	jokeTextIndex["shark"].texts = sharkJokes
	
	jokeTextIndex["bird"] = {}
	jokeTextIndex["bird"].index = 1
	jokeTextIndex["bird"].texts = birdJokes
end

function getNextGuestType()
	-- todo: novi tip gosta na random ili da se ne ponovi svi isti, da postoji omjer
	local guestTypes = jsonConfiguration["guest_types"]
	local guestIndex = math.random(0, 100) % #guestTypes + 1;

	return guestTypes[guestIndex]
end

function pickCardListener( event )
	if not isShowCardsTransition then
		playedCardIndex = event.target.index
		
		for i, card in ipairs (jokeCards.cards) do
			if ( i == playedCardIndex ) then
				transition.to(
					card.cardGroup, {
						time=1000, 
						delay=2000,
						alpha=0,
						onComplete = function()
							playJoke(playedCardIndex)
						end
					}
				)
			else
				transition.to(
					card.cardGroup, {
						time=1000, 
						delay=50,
						alpha=0
					}
				)
			end
		end
	end
end

function getCrowdReaction(_totalScore)
	-- sound i display
	stageCrowd:display()


	-- local options =
	-- {
	-- 	channel = 3,
	-- 	loops = -1,
	-- 	fadein = 2000,
	-- 	onComplete=onCrowdReactionComplete
	-- }

	-- local crowdSound = {}
	-- if _totalScore > 0 then
	-- 	crowdSound = positiveSounds[positiveSoundsIndex % #positiveSounds + 1]
	-- 	positiveSoundsIndex = positiveSoundsIndex + 1
	-- else
	-- 	crowdSound = negativeSounds[negativeSoundsIndex % #negativeSounds + 1]
	-- 	negativeSoundsIndex = negativeSoundsIndex + 1
	-- end

	-- audio.play(crowdSound, options)

	timer.performWithDelay(2000,onCrowdReactionComplete, 1);
end

function onCrowdReactionComplete()
	checkEndgame()

	--else nije kraj igri, promjeni publiku i update status bar-a
	stageCrowd:switchAngryGuests()
	stageCrowd:display()
	jokeCards.cards[playedCardIndex].textRect.text = jokeCards.cards[playedCardIndex].jokeText

	updateStatusBar()
	resetCardsPosition()
end

function playJoke( _cardIndex )
	local totalScore = 0.0
	local playedCard = jokeCards.cards[_cardIndex]

	local jokeType = playedCard.jokeType

	for i, guest in ipairs(stageCrowd.guests) do
		local score, jokeEffect = guest:rateJoke(jokeType)
		
		guest:setState(jokeEffect)

		totalScore = totalScore + score
	end

	playedCard

	crowdSatisfaction = crowdSatisfaction + totalScore

	getCrowdReaction(totalScore)
end


function checkEndgame()
	if crowdObjectiveEffect == "positive" then
		if crowdSatisfaction >= MAX_CROWD_SCORE then
			endGame(true)
		elseif crowdSatisfaction <= MIN_CROWD_SCORE then
			endGame(false)
		end
	else
		if crowdSatisfaction <= MIN_CROWD_SCORE then
			endGame(true)
		elseif crowdSatisfaction >= MAX_CROWD_SCORE then
			endGame(false)
		end
	end
end

function endGame( _isWin )

	local curtainLeft = display.newImageRect( "res/img/background/curtain-left.png", display.actualContentWidth, display.actualContentHeight )
	curtainLeft.anchorX = 0
	curtainLeft.anchorY = 0
	curtainLeft.x = -screenW 
	curtainLeft.y = 0 + display.screenOriginY

	
	-- curtainLeft.alpha = 0

	
	local curtainRight = display.newImageRect( "res/img/background/curtain-right.png", display.actualContentWidth, display.actualContentHeight )
	curtainRight.anchorX = 0
	curtainRight.anchorY = 0
	curtainRight.x = screenW + display.screenOriginX
	curtainRight.y = 0 + display.screenOriginY
	-- curtainRight.alpha = 0


	transition.to(
		curtainLeft, 
		{
			time=3300, 
			delay=500,
			x= 0 + display.screenOriginX,     
			-- onComplete = function()
			-- end
		}
	)

	transition.to(
		curtainRight, 
		{
			time=3200, 
			delay=500,
			x=0 + display.screenOriginX    
			-- onComplete = function()
			-- 	-- isShowCardsTransition = false
			-- end
		}
	)

	local errorText = display.newText( "dadad", 0, 0, native.systemFont, 34 )
    errorText.x = halfW ; errorText.y = screenH / 2
    errorText:setFillColor( 1, 1, 1 )
    errorText.alpha = 0
    -- errorText.anchorX = 0

	
	if _isWin then
		errorText.text = "You win, now you can go and heal people!"
	else
		errorText.text = "You lose, happy parents, happy life"
	end

	errorText:toFront()


	transition.to(
		errorText, 
		{
			time=500, 
			delay=3700,
			alpha=1  
			-- onComplete = function()
			-- 	-- isShowCardsTransition = false
			-- end
		}
	)

	-- composer.removeScene( "stage", false )
	--todo: endgame, switch scenswitchAe and destroy current
end

-----------------------------------------------

function loadGuestImages()
	local guestTypes = jsonConfiguration["guest_types"]
	
	for i, guestType in ipairs(guestTypes) do 
		-- todo: ako dobijemo positive onda promjeniti, inace ne
		local imagePositive = { type="image", filename="res/img/characters/".. guestType .."-neutral.png" }
		local imageNegative = { type="image", filename="res/img/characters/".. guestType .."-negative.png" }
		local imageNeutral = { type="image", filename="res/img/characters/".. guestType .."-neutral.png" }

		guestImages[guestType] = {}
		guestImages[guestType]["positive"] = imagePositive
		guestImages[guestType]["negative"] = imageNegative
		guestImages[guestType]["neutral"] = imageNeutral
 	end
end

function drawStatusElements()
	-- status border
	local statusBorderRect = display.newRect(display.screenOriginX + 100, screenH / 2, screenW * 0.05, MAX_STATUS_HEIGHT)
	statusBorderRect.strokeWidth = 5
	statusBorderRect.anchorX = 0
	statusBorderRect.anchorY = 1
	statusBorderRect:setFillColor(0,0,0,0)
	statusBorderRect:setStrokeColor(.1,.2,1)
	
	-- status rect
	statusRect = display.newRect(display.screenOriginX + 100 , screenH / 2, screenW * 0.05, MAX_STATUS_HEIGHT)
	statusRect.anchorX = 0
	statusRect.anchorY = 1
	statusRect:setFillColor(1,1,0)
	statusRect.height = 0

	sceneGroup:insert(statusRect)
	sceneGroup:insert(statusBorderRect)
end

function updateStatusBar()
	-- update status
	statusRect.height = MAX_STATUS_HEIGHT * (crowdSatisfaction / MAX_CROWD_SCORE)
end

local isShowCardsTransition = false

local function onShowCardsBtnRelease()
	if ( isShowCardsTransition ~= true ) then
		isShowCardsTransition = true

		if jokeCards.cardsGroup.isVisible then
			transition.to(
				jokeCards.cardsGroup, {
					time=500, 
					delay=100,
					x=halfW,
					y=screenH,    
					onComplete = function()
						jokeCards.cardsGroup.isVisible = false
						isShowCardsTransition = false
					end
				}
			)
		else
			jokeCards.cardsGroup.isVisible = true
			transition.to(
				jokeCards.cardsGroup, {
					time=500, 
					delay=100,
					x=halfW,
					y=screenH / 2,     
					onComplete = function()
						isShowCardsTransition = false
					end
				}
			)
		end
	end
	return true	-- indicates successful touch
end

function resetCardsPosition()
	isShowCardsTransition = false
	jokeCards.cardsGroup.isVisible = false
	jokeCards.cardsGroup.x = halfW
	jokeCards.cardsGroup.y = screenH

	for i, card in ipairs(jokeCards.cards) do
		card.cardGroup.alpha = 1.0
	end
end

function drawShowCardsBtn()
	showCardsBtn = widget.newButton{
		defaultFile = "res/img/button/note-btn.png",
		overFile = "res/img/button/note-btn-pressed.png",
		width = 601 * 0.13, height = 842 * 0.13,
		onRelease = onShowCardsBtnRelease
	}

    showCardsBtn.anchorX = 1
    showCardsBtn.anchorY = 0
	showCardsBtn.x = display.contentWidth - display.screenOriginX - 30
	showCardsBtn.y = display.screenOriginY + 30

	sceneGroup:insert( showCardsBtn )
end

function loadSounds()
	positiveSounds[1] = audio.loadSound("res/audio/Cheers3.wav");
	positiveSounds[2] = audio.loadSound("res/audio/Cheers5.wav");

	negativeSounds[1] = audio.loadSound("res/audio/Boo.wav");
	negativeSounds[2] = audio.loadSound("res/audio/Boo2.wav"); 
end

-- ##############################################
-- Framework functions
-- ##############################################

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to
	-- local sceneGroup = self.view 'sceneGroup', add touch listeners, etc.
	
	sceneGroup = self.view
	
	-- load static assets/images
	
	local background = display.newImageRect( "res/img/background/scene.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	foxy = display.newImageRect( "res/img/characters/foxy.png", display.actualContentWidth, display.actualContentHeight )
	foxy.anchorX = 0
	foxy.anchorY = 0
	foxy.x = 0 + display.screenOriginX 
	foxy.y = 0 + display.screenOriginY

	sceneGroup:insert( background )
	sceneGroup:insert( foxy )
	
	loadSounds()
	
	loadGuestImages()

	-- load structures and shuffle 
	
	shuffleAllJokes()
	indexJokeTexts()

	crowdSatisfaction = jsonConfiguration["init_crowd_satisfaction"] * MAX_CROWD_SCORE
	crowdObjectiveEffect = jsonConfiguration["crowd_objective"]

	-- setup game specific parameters
	
	stageCrowd = Crowd:new()
	Crowd:createStageCrowd()
	Crowd:prepareGuestImages()
	stageCrowd:display()
	
	drawStatusElements()

	updateStatusBar()

	jokeCards = Cards:new()
	jokeCards:createCards()
	jokeCards:prepareCardImages()

	drawShowCardsBtn()

	foxy:toFront()

	-- all display objects must be inserted into group
end

function scene:show( event )
	sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
	end
end

function scene:hide( event )
	sceneGroup = self.view
	
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
	sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene