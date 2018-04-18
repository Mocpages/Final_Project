Player = Class{__includes = Entity}

function Player:init(x, y)
    self.x = x
    self.y = y

    self.angle = 0


    self.texture = 'SoldierSprites'
    self.skin = 4--math.random(6)

    --self.width = self.texture:getWidth()
    --self.height = self.texture['player']:getHeight()

    self.width = 25
    self.height = 34

    self.originX = 12
    self.originY = 9

    self.map = nil
    self.rect = {name = "player"}
end

function Player:setMap(map)
    self.map = map
    self.map.world:add(self.rect, self.x, self.y, self.width, self.height)
end

function Player:update(dt)

    mX, mY = push:toGame(love.mouse.getPosition())
    mX = mX + (self.x - VIRTUAL_WIDTH / 2)
    mY = mY + (self.y - VIRTUAL_HEIGHT / 2)

    self.angle = findRotation(self.x, self.y, mX, mY), math.pi * 2

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

    speed = 1
    if love.keyboard.isDown('lshift') then speed = 20 end

    dx = dx * speed
    dy = dy * speed

    newX = self.x + dx
    newY = self.y + dy

    local actX, actY, collisions, lenCol = self.map.world:check(self.rect, newX, newY)

    self.rect.x = newX
    self.rect.y = newY

    local actualX, actualY, cols, len = self.map.world:move(self.rect, newX, newY)
    self.x = actualX
    self.y = actualY

    self.map.world:update(self.rect, actualX, actualY)

    --get shot! yaa- um. Well. (handles collisions which do stuff, I.E. bullets, grenades, etc) 
    if len > 0 then --if we collided with something
        for i=1,len do --go over everything we collided with
            if cols[i].other.name == 'bullet' then  end --If it's a bullet, crash the game!
        end
    end

    if dx == 0 then --not moving
        gSounds['footsteps']:stop()
    else
        gSounds['footsteps']:play()
    end

    --shooting! Just sounds right now.
    if love.mouse.wasPressed(1) then
        local gunshot = love.audio.newSource('sounds/gunshot.mp3')
        gunshot:play()
        self:fire()

        Timer.after(math.random(), function ()
                local shellcase = love.audio.newSource('sounds/shellcase.mp3')
                shellcase:play() 
            end
        )
    end

    if love.keyboard.isDown("space") then print("x: " .. self.x .. " y: " .. self.y .. " angle: " .. self.angle) end --for debugging
end

function Player:fire()
    b = Bullet(self.x, self.y, self.angle, 10, self.map, self.rect)
    table.insert(self.map.entities, b)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.skin], self.x, self.y, self.angle, 1, 1, self.originX, self.originY)
    --love.graphics.draw(gTextures['player'], VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, self.angle, 1, 1, self.originX, self.originY)
end

function findRotation(x1,y1,x2,y2)
    return math.atan2(y2 - y1, x2 - x1) - (0.5 * math.pi)
end

function isInTable(value, table)
    for k, v in pairs(table) do
        if v == value then return true end
    end
    return false
end