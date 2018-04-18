Bullet = Class{}

function Bullet:init(x, y, angle, damage, map, parent)
	--print("x: " .. x .. " y: " .. y .. " angle: " .. angle)
	self.offsetX = x
	self.offsetY = y

	self.x = x
	self.y = y

	self.angle = angle + math.pi
	self.damage = damage
	self.map = map
	self.parent = parent

	self.dx = math.sin(self.angle) 
    self.dy = -math.cos(self.angle)

    self.canvas = love.graphics.newCanvas(2, 6)
    self.dead = false


    --self.x = self.map.player.x
    --self.y = self.map.player.y
    
    self.rect = {name = "bullet"}
    self.map.world:add(self.rect, self.x, self.y, 2, 2)

    self:offset() --So we don't shoot ourselves
end

function Bullet:offset()
	dx = -math.sin(self.angle)
	dy = math.cos(self.angle)

	self.x = self.x + dx * 40
	self.y = self.y + dy * 40
end

function Bullet:update(dt)
  	newX = self.x + self.dx * 5
    newY = self.y + self.dy * 5

    collidables = {"top_wall", "bottom_wall", "left_wall", "right_wall"}
    local actualX, actualY, cols, len = self.map.world:move(self.rect, newX, newY)
    --print(len)
    if len > 0 then --if we collided with something
    	for i=1,len do
    		if cols[i].other.name == self.parent.name then 
    			--doesn't work with a not-statement, so we're doing an empty if-else ¯\_(ツ)_/¯
    		else
    			self.dead = true
    			--Why does this work but the other way doesn't? He screams, for he does not know.
    		end
    	end
    end
    self.x = actualX
    self.y = actualY

    self.map.world:update(self.rect, actualX, actualY)

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