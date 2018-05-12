Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
bump = require 'lib/bump.bump'
--LightWorld = require 'lib/light_world.main'


require 'src/StateMachine'
require 'src/Util'
require 'src/constants'
require 'src/Player'
require 'src/Map'
require 'src/Animation'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/Hitbox'
require 'src/Bullet'
require 'src/Traitor'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerWalkState'


require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/DeathState'

gTextures = {
	['background'] = love.graphics.newImage('graphics/background.png'), --from https://opengameart.org/content/bulkhead-walls-hangar
	['tiles'] = love.graphics.newImage('graphics/tilesheet.png'), --from 
	['player'] = love.graphics.newImage('graphics/MainSprite.png'),
	['SoldierSprites'] = love.graphics.newImage('graphics/SoldierSprites.png'),
	['death'] = love.graphics.newImage('graphics/gameOver.jpg'),
	['plasma'] = love.graphics.newImage('graphics/plasma.png')
}

gFrames = {
	['tiles'] = GenerateQuads(gTextures['tiles'], 48, 48),
	['SoldierSprites'] = GenerateQuads(gTextures['SoldierSprites'], 25, 34)
}

gSounds = {
	['music'] = love.audio.newSource('sounds/music.mp3'),
	['footsteps'] = love.audio.newSource('sounds/footsteps.mp3'),
	['gunshot'] = love.audio.newSource('sounds/gunshot.mp3'),
	['shellcase'] = love.audio.newSource('sounds/shellcase.mp3'),
	['autofire'] = love.audio.newSource('sounds/autofire.mp3')
}

gFonts = {
	['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 64),
	['large'] = love.graphics.newFont('fonts/font.ttf', 32),
	['extra-large'] = love.graphics.newFont('fonts/font.ttf', 64),
}

 cooldowns = {
    [1] = 1,
    [2] = 1,
    [3] = 1,
    [4] = 0.2,
    [5] = 1,
    [6] = 1,
}