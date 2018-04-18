Map = Class{}


function Map:init(player)
	self.player = player

	self.tiles = {}
	self.entities = {}
	self.objects = {}

	self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    self.rooms = {}

    self.world = bump.newWorld(48)
    self:generateMap(self)

    table.insert(self.entities, Traitor(self.player.x + 100, self.player.y + 100, self.world, self.player))
end

function Map:update()
	for k, v in pairs(self.entities) do
		if v.dead then self.entities[k] = nil end
		v:update()
	end

	for k,v in pairs(self.objects) do
		v:update()
	end
end

function Map:render()

	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.translate(push:toReal(VIRTUAL_WIDTH / 2 - self.player.x,  VIRTUAL_HEIGHT / 2 -self.player.y))
	
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
			local tile = self.tiles[y][x]
			if tile == nil then goto done end
			love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile], 
				(x - 1) * TILE_SIZE + self.renderOffsetX, 
                (y - 1) * TILE_SIZE + self.renderOffsetY)
			::done::
		end
	end

	for k, v in pairs(self.entities) do
		v:render()
	end

	for k,v in pairs(self.objects) do
		v:render()
	end
end

function Map:generateMap()
	walls = {}
	for y= 1, 100 do
		table.insert(self.tiles, {})
		for x=1, 100 do
			--table.insert(self.tiles[y], TILE_FLOORS[math.random(#TILE_FLOORS)])--48)

			if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == 100 then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == 100 and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == 100 and y == 100 then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1  then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == 100  then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == 100 then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
				id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            table.insert(self.tiles[y], id)
		end
	end

	floor = math.random(7)
	self:generateLoopDungeon(100)
	self:generateRectangles()
end

function Map:generateRectangles() --this will add the wall rectangles for Bump, so collisions happen.
	for y= 1, 100 do
		for x=1, 100 do
			local tile = self.tiles[y][x]
			if tile == 5 then --top wall
				local rect = {name = 'top_wall', x = x * 48, y = (y+1) * 48, w=48, h=1}
				self.world:add(rect, x * 48 + 72, (y+1) * 48 - 16, 48, 1)
			elseif tile == 1 then --bottom wall
				local rect = {name = 'bottom_wall', x = x * 48, y = (y+1) * 48 + 16, w=48, h=1}
				self.world:add(rect, x * 48 +72, (y+1) * 48 + 16, 48, 1)
			elseif tile == 2 then --left wall
				local rect = {name = 'left_wall', x = x * 48, y = (y+1) * 48, w=48, h=1}
				self.world:add(rect, (x+3) * 48 - 80, (y-1) * 48 + 72, 1, 48)
			elseif tile == 3 then --right wall
				local rect = {name = 'right_wall', x = x * 48, y = (y+1) * 48, w=48, h=1}
				self.world:add(rect, (x+3) * 48 - 40, (y-1) * 48 + 72, 1, 48)
			end --if it isn't a wall, it doesn't get a collider
		end
	end
end

function Map:generateVerticalWall(startX, startY, endY)
	x = startX
	y = startY+1
	midpoint = ((endY + y) / 2)
	while y <= endY do
		self.tiles[y][x] = 3
		y = y + 1
	end
	--do ends of the wall
	midpoint = math.floor(midpoint)
	self.tiles[midpoint][x] = 10

	self.tiles[startY][startX] = 8
	--self.tiles[endY][x] = 41
end

function Map:generateHorizontalWall(startX, startY, endX)
	if startX == 1 then self.tiles[startY][startX] = 4 end
	x = startX+1
	y = startY
	midpoint = (endX + x) / 2
	while x <= endX do
		self.tiles[y][x] = 5
		x = x + 1
	end
	--do ends of the wall
	self.tiles[y][endX] = 8
	self.tiles[y][math.floor(midpoint)] = 10
end

function isInTable(value, table)
	for k, v in pairs(table) do
		if v == value then return true end
	end
	return false
end

function Map:generateLoopDungeon(numWalls)
	for i=1,numWalls do
		::invalid::
		x = math.random(1, 100)
		y = math.random(1, 100)

		if not isInTable(self.tiles[y][x], TILE_FLOORS) then
			goto invalid
		else 
			isVertical = (math.random(0,1)==1)
		end

		if isVertical then
			endPoints = self:findWallEnds(x, y, true)
			self:generateVerticalWall(x, endPoints[2], endPoints[1])
		else
			endPoints = self:findWallEnds(x, y, false)
			self:generateHorizontalWall(endPoints[2], y, endPoints[1])
		end
	end
end

function Map:findWallEnds(x, y, isVertical)
	firstCoord = 1
	secondCoord = 1

	if isVertical then --find vertical endponts

		for i=y, 100 do --find lower edge
			if not isInTable(self.tiles[i][x], TILE_FLOORS) then
				firstCoord = i
				goto next_1
			end
		end

		::next_1::
		for i=y,0,-1 do --find upper edge
			if not isInTable(self.tiles[i][x], TILE_FLOORS) then
				secondCoord = i
				goto next_2
			end
		end

		::next_2::
	else --find horizontal endpoints

		for i=x, 100 do --find right edge
			if not isInTable(self.tiles[y][i], TILE_FLOORS) then
				firstCoord = i
				goto next_3
			end
		end

		::next_3::
		for i=x,0,-1 do --find left edge
			if not isInTable(self.tiles[y][i], TILE_FLOORS) then
				secondCoord = i
				goto next_4
			end
		end

		::next_4::
	end

	return {firstCoord, secondCoord} --return array
end