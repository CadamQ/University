var ship;
var asteroids = []; 
var lasers = [];
var score = 0;
var gameOver = false;
var shieldTime = 180;
var graceModeActive = false;
var level = 1;


function setup()
{

	this.initialAsteroids = 5 + 2*level;

	createCanvas(windowWidth, windowHeight); //full screen canvas.
	ship = new ship();
	nextLevel();
}

function draw()
{
	background(0);
	ship.render();
	ship.turn();
	ship.update();
	ship.edges();

	for (var i = 0; i < asteroids.length; i++)
	{
		push();
		textSize(32);
		fill(0,255,0);
		text('Score: ' + score, width/2 - 200, height/2 - 400);
		text('Level: ' + level, width/2 + 50, height/2 - 400);
		pop();
		
		if (ship.hits(asteroids[i]) && !gameOver)
		{
			noLoop();
			push();
			gameOver = true;
			textSize(32);
	    	fill(255,0,0);
			text("GAME OVER", (width / 2) - 100, height / 2);
			text("REFRESH PAGE TO TRY AGAIN!", (width / 2) - 250, height / 2 + 100);
			pop();
		}
		asteroids[i].render();
		asteroids[i].update();
		asteroids[i].edges();
		}

	

	for (var i = lasers.length-1; i >=0; i--)
	{
		lasers[i].render();
		lasers[i].update();

		if (lasers[i].offscreen())
		{
			lasers.splice(i, 1); //This stops the lasers array becoming too big by removing the laser from the array when leaving the game area
		}
		else
		{
			for (var j = asteroids.length-1; j >= 0; j--)
			{
				if (lasers[i].hits(asteroids[j]))
				{
					if (asteroids[j].r > 10)
					{
						score += 10;
						var newAsteroids = asteroids[j].breakup();
						asteroids = asteroids.concat(newAsteroids);
					}
					else
					{
						score += 25;
					}


					asteroids.splice(j, 1);
					lasers.splice(i, 1);
					break;
				}
			}
			if (asteroids.length == 0)
			{
				level++;
				nextLevel();
			}
		}
	}}

function nextLevel()
{
	for(var i = 0; i < level + 5; i++)
	{
    asteroids.push(new asteroid(null, null, 2));
	}
}

function keyReleased()
{
	ship.setRotation(0);
	ship.boosting(false);
}

function  keyPressed() //if possible, change this to the keyIsDown() function. (also change the keyRelesed() function.)
{
	if (keyCode == 32) // Spacebar 
	{
		lasers.push(new laser(ship.pos, ship.heading));
	}
	else if (keyCode == RIGHT_ARROW)
	{
		ship.setRotation(0.1);
	}
	else if (keyCode == LEFT_ARROW)
	{
		ship.setRotation(-0.1);
	}
	else if (keyCode == UP_ARROW)
	{
		ship.boosting(true);
	}	
}