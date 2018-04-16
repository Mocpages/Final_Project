Bullet = Class{}

function Bullet:init(x, y, angle, damage, map)
	--print("x: " .. x .. " y: " .. y .. " angle: " .. angle)
	self.x = x
	self.y = y
	self.angle = angle
	self.damage = damage
	self.map = map
	self.dx = math.sin(self.angle) 
    self.dy = math.cos(self.angle)
    self.dead = false

    print("x: " .. x .. " y: " .. y .. " angle: " .. angle)
    self.x = self.map.player.x
    self.y = self.map.player.y
    print("x: " .. x .. " y: " .. y .. " angle: " .. angle)
end

function Bullet:update(dt)
  	newX = self.x + self.dx
    newY = self.y + self.dy

       --isInTable(self.map.tiles[math.floor(y)][math.floor(x)], TILE_FLOORS)
    if isInTable(self.map.tiles[math.floor(y)][math.floor(x)], TILE_FLOORS) or isInTable(self.map.tiles[math.floor(y)][math.floor(x)], SYMBOLS) then 
    	self.x = newX
    	self.y = newY
    else
    	self.dead = true
    end
end

function Bullet:render()
	if not self.dead then
		love.graphics.rotate(self.angle)
		love.graphics.setColor(255, 0, 0, 255)

		love.graphics.rectangle('fill', self.x, self.y, 2, 6)

		love.graphics.rotate(-self.angle)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function isInTable(value, table)
    for k, v in pairs(table) do
        if v == value then return true end
    end
    return false
end