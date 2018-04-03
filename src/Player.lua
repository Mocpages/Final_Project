Player = Class{__includes = Entity}

function Player:init(x, y)
    self.x = x
    self.y = y

    self.angle = 0

    self.width = gTextures['player']:getWidth()
    self.height = gTextures['player']:getHeight()

    self.originX = self.width / 2
    self.originY = self.height / 2

end

function Player:update(dt)

    --x, y = push:toGame(self.x, self.y)
    mX, mY = push:toGame(love.mouse.getPosition())
    print(self.x .. " " .. self.y)

    self.angle = findRotation(self.x, self.y, mX, mY)

    --handle movement
    local dx, dy = 0, 0

    local vx = math.sin(self.angle) 
    local vy = -math.cos(self.angle)

    if love.keyboard.isDown('s') then
        dx = vx
        dy = vy
    elseif love.keyboard.isDown('w') then
        dx = -vx
        dy = -vy
    elseif love.keyboard.isDown('d') then
        dx = vy
        dy = -vx
    elseif love.keyboard.isDown('a') then
        dx = -vy
        dy = vx
    end

    self.x = self.x + dx
    self.y = self.y + dy

    if dx == 0 then --not moving
        gSounds['footsteps']:stop()
    else
        gSounds['footsteps']:play()
    end

    --shooting!
    if love.mouse.wasPressed(1) then
        gSounds['gunshot']:play() 
        gSounds['shellcase']:play()
    end

    if love.mouse.wasPressed(2) then gSounds['autofire']:play() end
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    love.graphics.draw(gTextures['player'], self.x, self.y, self.angle, 1, 1, self.originX, self.originY)
    --love.graphics.draw(gTextures['player'], VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, self.angle, 1, 1, self.originX, self.originY)
end

function findRotation(x1,y1,x2,y2)
    return math.atan2(y2 - y1, x2 - x1) - 0.5 * math.pi
end