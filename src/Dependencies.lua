Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/StateMachine'
require 'src/Util'
require 'src/constants'
require 'src/Player'
require 'src/Map'

require 'src/states/PlayState'
require 'src/states/StartState'

gTextures = {
	['background'] = love.graphics.newImage('graphics/background.png'), --from https://opengameart.org/content/bulkhead-walls-hangar
	['tiles'] = love.graphics.newImage('graphics/tilesheet.png') --from https://opengameart.org/content/basic-32x32-sci-fi-tiles-for-roguelike
}

gFrames = {
	['tiles'] = GenerateQuads(gTextures['tiles'], 64, 64)
}

gSounds = {
	['music'] = love.audio.newSource('sounds/music.mp3')
}

gFonts = {
	['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 64),
	['large'] = love.graphics.newFont('fonts/font.ttf', 32),
	['extra-large'] = love.graphics.newFont('fonts/font.ttf', 64),
}