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

math.randomseed(os.time())

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local stageCrowd = {}

local MAX_CROWD_SCORE = 100.0
local MIN_CROWD_SCORE = 0.0

local crowdSatisfaction = 0.0

local currentJokeCards = {}

local jokeModifier = {}

-- Class definitions

local Crowd = {}
local Guest = {}
local Cards = {}

function Crowd:new()
    local newObject = setmetatable({}, self)
	self.__index = self

    self.guests = {}
	
	Crowd:createStageCrowd()
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

function Crowd:resetAngryGuests()
	for i, guest in ipairs(stageCrowd.guests) do
		if guest.state == "negative" then
			guest:reset(getNextGuestType())
		end
	end
end


function Crowd:display()
	-- todo: prikaz na svaki update crowda, 
	-- crtaju se indeksom od prvog indeksa koji je u zadnjem redu lijevo do prvog reda desno 
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
	self.annoying_symbol = {}

	return newObject
end

function Guest:rateJoke(_joke)
	local score = 0;
	local jokeEffect = "neutral"
	local jokeEffects = jsonConfiguration["joke_effects"]

	if not jokeEffects["positive"][self.type] then
		if not jokeEffects["negative"][self.type] then
			jokeEffect = "neutral"
		else
			jokeEffect = "negative"
		end
	else
		jokeEffect = "positive"
	end
	
	score = jokeModifier[jokeEffect] * self.scoreModifier

	return score, jokeEffect;
end

function Guest:reset( _type )
	self.type = _type
	self.scoreModifier = 1.0
	self.state = "negative"
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

function Cards:new()
	local newObject = setmetatable({}, self)
	self.__index = self

	self.cards = {}

	return newObject
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

function getNextGuestType()
	local guestTypes = jsonConfiguration["guest_types"]
	local guestIndex = math.random(0, 100) % #guestTypes + 1;

	return guestTypes[guestIndex] 

-- todo: novi tip gosta na random ili da se ne ponovi svi isti, da postoji omjer
end

function getNextJoke()
	-- todo: dohvati novi joke iz deka/ random ali da nisu u ruci svi istog tipa
end

function playJoke( _joke )
	local totalScore = 0.0

	for i, guest in ipairs(stageCrowd.guests) do
		local score, jokeEffect = guest:rateJoke(_joke)
		
		guest:setState(jokeEffect)

		totalScore = totalScore + score
	end

	return totalScore
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
			endgame(false)
		end
	end

	return 
end

function endGame( _isWin )

	--todo: endgame, switch scenswitchAe and destroy current
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
	
	print("pocetak ---------------------");

	crowdSatisfcation = jsonConfiguration["init_crowd_satisfaction"] * MAX_CROWD_SCORE
	
	crowdObjectiveEffect = jsonConfiguration["crowd_objective"]
	
	stageCrowd = Crowd:new()

	shuffleAllJokes()

	local sceneGroup = self.view
	
	local background = display.newImageRect( "res/img/background/scene.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY

	sceneGroup:insert( background )

	for i, guest in ipairs(stageCrowd.guests) do
		guest.image = display.newImageRect( "res/img/characters/" .. guest.type .. "-".. guest.state .. ".png", 0.977 * guest.position[3], guest.position[3] )
		guest.image.anchorX = 0.5
		guest.image.anchorY = 0.5
		guest.image.x = background.width * guest.position[1] + display.screenOriginX 
		guest.image.y = background.height * guest.position[2] + display.screenOriginY 
		guest.image.isVisible = true

		guest.annoying_symbol = display.newImageRect( "res/img/anger_symbol.png", 0.2 * guest.position[3], 0.2 * guest.position[3] )
		guest.annoying_symbol.anchorX = 0.5
		guest.annoying_symbol.anchorY = 0.5
		guest.annoying_symbol.rotation = 30
		guest.annoying_symbol.x = background.width * guest.position[1] + display.screenOriginX + guest.position[3] / 4.5 
		guest.annoying_symbol.y = background.height * guest.position[2] + display.screenOriginY - guest.position[3] / 4
		guest.annoying_symbol.isVisible = true
		sceneGroup:insert(guest.image)

		sceneGroup:insert(guest.annoying_symbol)
	end

	-- draw status

	-- status border
	local statusBorderRect = display.newRect(-100, background.height / 2, background.width * 0.05, background.height/3 )
	statusBorderRect.strokeWidth = 5
	statusBorderRect.anchorX = 0
	statusBorderRect.anchorY = 1
	statusBorderRect:setFillColor(0,0,0,0)
	statusBorderRect:setStrokeColor(.1,.2,1)

	local statusRect = display.newRect(-100, background.height / 2, background.width * 0.05, background.height/3)
	statusRect.anchorX = 0
	statusRect.anchorY = 1
	statusRect:setFillColor(1,1,0)
	statusRect.height = background.height/3 * (70/ MAX_CROWD_SCORE)

	sceneGroup:insert(statusRect)
	sceneGroup:insert(statusBorderRect)

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