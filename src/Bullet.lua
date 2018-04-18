Bullet = Class{}

function Bullet:init(x, y, angle, damage, map)
	--print("x: " .. x .. " y: " .. y .. " angle: " .. angle)
	self.offsetX = x
	self.offsetY = y

	self.x = x + 12
	self.y = y

	self.angle = angle + math.pi
	self.damage = damage
	self.map = map

	self.dx = math.sin(self.angle) 
    self.dy = -math.cos(self.angle)

    self.canvas = love.graphics.newCanvas(2, 6)
    self.dead = false

    --print("x: " .. x .. " y: " .. y .. " angle: " .. angle)
    self.x = self.map.player.x
    self.y = self.map.player.y
    --print("x: " .. self.x .. " y: " .. self.y .. " angle: " .. self.angle)
end

function Bullet:update(dt)
  	newX = self.x + self.dx
    newY = self.y + self.dy

    --if isInTable(self.map.tiles[math.floor(y)][math.floor(x)], TILE_FLOORS) then
    --if isInTable(self.map.tiles[math.floor(y)][math.floor(x)], TILE_FLOORS) or isInTable(self.map.tiles[math.floor(y)][math.floor(x)], SYMBOLS) then 
    --if isInTable(self.map.tiles[math.floor(newY)][math.floor(newX)], TILE_FLOORS) or isInTable(self.map.tiles[math.floor(newY)][math.floor(newX)], SYMBOLS)then 
    	self.x = newX
    	self.y = newY
    --else
    --	self.dead = true
    --end

    self.canvas:renderTo( function() love.graphics.clear(255, 0, 0, 255) end)
end

function Bullet:render()
	if not self.dead then
		love.graphics.draw(self.canvas, self.x, self.y, self.angle)
	end
end

function isInTable(value, table)
    for k, v in pairs(table) do
        if v == value then return true end
    end
    return false
end