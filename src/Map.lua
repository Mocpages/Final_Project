Map = Class{}

function Map:init(player)
	self.player = player

	self.tiles = {}
	self.entities = {}
	self.objects = {}

	self.cameraX = 0
    self.cameraY = 0
    self:GenerateRoom()
end

function Map:update()


end

function Map:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
			local tile = self.tiles[y][x]
			love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile], x * 64, y * 64)
		end
	end
end

function Map:GenerateRoom()
	height = 8
	width = 8

	for y = 1, height do
		table.insert(self.tiles, {})
		for x = 1, width do
			local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == width and y == height then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            table.insert(self.tiles[y], id)
		end
	end
end