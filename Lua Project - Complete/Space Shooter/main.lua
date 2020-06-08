require("physics")
physics.start()
physics.setGravity( 0, 0 )
print(display.contentWidth)
print(display.contentHeight)
local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
background.x, background.y = display.contentCenterX, display.contentCenterY
local asteroidCollisionFilter = {categoryBits = 4, maskBits = 3}
local characterCollisionFilter = {categoryBits = 1, maskBits = 4}
local projectileCollisionFilter = {categoryBits = 2, maskBits = 4}

--Score System
local score = 0
scoreDisp = display.newText( "Score: "..score, display.contentCenterX, 100, "Arial", 150 )

local function onCollision(event)
	if event.phase == "began" then
		event.target:removeSelf()
		event.target = nil
	end
	score = score + .5
	scoreDisp.text = "Score: "..score
end

--Ship Creation--
characterSize = display.contentWidth*.1389
local character = display.newImageRect( "Ship.png", characterSize, characterSize ) --Importing the ship sprite
character.x, character.y = display.contentCenterX, display.contentCenterY
physics.addBody( character, {filter = characterCollisionFilter})
local deltaX, deltaY = 0, 0
local normDeltaX, normDeltaY = 0, 0
local speed = 0

local function calcTraj(trajX, trajY)
	speed = math.random(250, 400)
	deltaX = trajX - character.x
	deltaY = trajY - character.y
	normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
	normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
end

--Shooting System--
local projectile = {}
local count = 1
local projectileSize = display.contentWidth * .009
local function shoot(event)
	if count == 1 then
	else
		local diffX = character.x - event.x
    	local diffY = character.y - event.y
 		character.rotation = math.atan2(diffY, diffX) * (180/math.pi) - 90
 		--Creates a sphere to act as a bullet
		projectile[#projectile+1] = display.newCircle( display.contentCenterX, display.contentCenterY, projectileSize) 
		projectile[#projectile]:setFillColor( 0,1,0 )
		physics.addBody( projectile[#projectile], {filter = projectileCollisionFilter} )
		calcTraj(event.x, event.y)
		projectile[#projectile]:setLinearVelocity( normDeltaX*500, normDeltaY*500 )
		projectile[#projectile]:addEventListener( "collision", onCollision )
	end
	count = count + 1
end

--Asteroid Spawning System--
local randomX, randomY = 0, 0
local function randomSpawn()
	--Picks rabdom side of the screen for the asteroid to come from
	local side = math.random(4)
	if side == 1 then
		--Picks a random point on the selected side for the asteroid to spawn
		randomX = math.random(display.contentWidth)
		randomY = 0
	elseif side == 2 then
		randomX = display.contentWidth
		randomY = math.random(display.contentHeight)
	elseif side == 3 then
		randomX = math.random(display.contentWidth)
		randomY = display.contentHeight
	elseif side == 4 then
		randomX = 0
		randomY = math.random(display.contentHeight)
	end
end

local asteroid = {}
local asteroidSize = display.contentWidth*.06945
local function spawnAsteroid()
	randomSpawn()
	asteroid[#asteroid+1] = display.newImageRect("asteroid.png", asteroidSize, asteroidSize) --Imports the asteroid sprite
	asteroid[#asteroid].x, asteroid[#asteroid].y = randomX, randomY
	physics.addBody( asteroid[#asteroid], {filter = asteroidCollisionFilter} )
	calcTraj(randomX, randomY)
	asteroid[#asteroid]:setLinearVelocity(-normDeltaX*speed, -normDeltaY*speed)
	--Collision Detection--
	asteroid[#asteroid]:addEventListener( "collision", onCollision )
end
local spawn = timer.performWithDelay( 1500, spawnAsteroid, 0 )
gameOver = display.newText( "Play Again!", display.contentCenterX, display.contentCenterY, "Arial", 140 )
gameOver.isVisible = false
local function onCollisionAlt(event)
	if event.phase == "began" then
		event.target:removeSelf()
		event.target = nil
		timer.pause( spawn )
		Runtime:removeEventListener( "tap", shoot )
		gameOver.isVisible = true
		score = score - .5
		scoreDisp.text = "Score: "..score
	end
end
--Restart Game Function on Death--
local function restart()
	gameOver.isVisible = false
	character = display.newImageRect( "Ship.png", characterSize, characterSize )
	character.x, character.y = display.contentCenterX, display.contentCenterY
	physics.addBody( character, {filter = characterCollisionFilter})
	count = 1
	Runtime:addEventListener( "tap", shoot )
	character:addEventListener( "collision", onCollisionAlt )
	timer.resume( spawn )
	score = 0
	scoreDisp.text = "Score: "..score
end
character.isVisible = false
timer.pause( spawn )
start = display.newText( "Play Game!", display.contentCenterX, display.contentCenterY, "Arial", 140 )
local function startGame()
	character.isVisible = true
	timer.resume( spawn )
	start.isVisible = false
	Runtime:addEventListener( "tap", shoot ) --Event listener to see when the screen is tapped, will shoot on tap
end
start:addEventListener( "tap", startGame )
gameOver:addEventListener( "tap", restart )
character:addEventListener( "collision", onCollisionAlt ) --Collision detection for asteroid hitting ship
