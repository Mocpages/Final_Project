Map = Class{}


function Map:init(player)
	self.player = player

	self.tiles = {}
	self.entities = {}
	self.objects = {}

	self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

	self.cameraX = 0
    self.cameraY = 0

    self.rooms = {}

    self:generateMap(self)

end

function Map:update()
	for k, v in pairs(self.entities) do
		v:update()
	end

	for k,v in pairs(self.objects) do
		v:update()
	end
end

function Map:render()
	--love.graphics.push()

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

	--love.graphics.pop()
end

function Map:GenerateRoom(xOffset, YOffset, height, width, floor)
	maxDoors = MAP_HEIGHT / 2 + MAP_WIDTH / 2
	baseDoor = math.random(1, maxDoors)

	markerX = math.random(2 + xOffset, width-1 + xOffset)
	markerY = math.random(2 + YOffset, height-1 + YOffset)

	for y = 1 + YOffset, height + YOffset do
		table.insert(self.tiles, {})
		for x = 1 + xOffset, width + xOffset do
			local id = TILE_EMPTY

            if x == 1 + xOffset and y == 1 + YOffset then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 + xOffset and y == height + YOffset then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == width + xOffset and y == 1 + YOffset then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == width + xOffset and y == height + YOffset then
                id = TILE_BOTTOM_RIGHT_CORNER
            
            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 + xOffset then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
               -- if not self.tiles[y][x-1] == 48 then self.tiles[y][x-1] = 3 end
            elseif x == width + xOffset then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
                --if not self.tiles[y][x+1] == 48 then self.tiles[y][x+1] = 2  end
            elseif y == 1 + YOffset then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
                if y<=1 then goto top end
                --if not self.tiles[y-1][x] == 48 then self.tiles[y-1][x] = 1 end
                ::top::
            elseif y == height + YOffset then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
                --if not self.tiles[y+1][x] == 48 then self.tiles[y+1][x] = 5 end
            elseif x == markerX and  y == markerY then
            	id = TILE_FLOOR_SYMBOLS[floor]
            else
				id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end
            
            if y == yOffset and x == xOffset then id = 10 end
            self.tiles[y][x] = id
		end
	end
end

function Map:interiorWalls(x, y, id)
	--if adjacent tile is blank, do nothing
	if self.tiles[y][x] == 48 then return end
	--if adj. tile is a floor, replace with the other-side wall
	if isInTable(self.tiles[y][x], TILE_FLOORS) or isInTable(self.tiles[y][x], SYMBOLS) then
		if id == 2 then
			return 3
		elseif id == 3 then
			return 2
		elseif id == 1 then
			return 5
		else
			return 1
		end
	end
	--if adj. tile is a wall, 

end

function Map:getInteriorWalls(x, y, id)
	--get all interior walls in the room and send to array, so that I can later add a door.
	if self.tiles[y][x] == 48 then return false end
	table.insert()
	return true
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
	--self:GenerateRoom(50, 50, 100, 100, floor)

	--for i=1,10 do
	--	self:generateRandomRoom(floor)
	--end

	--table.insert(self.rooms, {{0,0}, {100, 100}})
	self:generateLoopDungeon(100)

	
end

function Map:generateRandomRoom(floor)
	self:GenerateRoom(math.random(0, 20), math.random(0, 20), math.random(1, 4)*3, math.random(1, 4)*3, floor)
end

function Map:generateVerticalWall(startX, startY, endY)
	--direction of 0 = vertical, 1 = horizontal
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
	--direction of 0 = vertical, 1 = horizontal
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

--function Map:generateRecursiveDungeon(iterations, maxIterations)
--	if iterations > maxIterations then return end --this is our recursion end condition
--
--	isVertical = (math.random(0,1)==1)

--	if isVertical then
--		self:generateVerticalWall()
--	else
--		self:generateHorizontalWall()
--	end

--	return self:generateRecursiveDungeon(iterations + 1, maxIterations)
--end

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