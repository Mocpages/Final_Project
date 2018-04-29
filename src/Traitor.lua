Traitor = Class{} --this really should extend player - TODO

function Traitor:init(x, y, world, player)
    self.x = x
    self.y = y

    self.angle = 0


    self.texture = 'SoldierSprites'
    self.skin = 1--math.random(6)

    --self.width = self.texture:getWidth()
    --self.height = self.texture['player']:getHeight()

    self.width = 25
    self.height = 34

    self.originX = 12
    self.originY = 9

    self.world = world
    self.player = player
    self.rect = {name = "traitor", parent = self}

    self.rangeRect = {name = "vision"}
    self.rangeRect.filter = function(item, other) print("hi") return 'cross' end

    self.world:add(self.rect, self.x, self.y, self.width, self.height)
     self.world:add(self.rangeRect, self.x, self.y, 192, 192)

     self.health = 5
     self.dead = false

    --shooting! Has to be done here, or we end up with dozens of timers.
    self.shoot = false
    Timer.every(0.2, function()
            --local gunshot = love.audio.newSource('sounds/gunshot.mp3')
            --gunshot:play()
            self.shoot = true

            Timer.after(0.001, function ()
                self.shoot = false
                   -- local shellcase = love.audio.newSource('sounds/shellcase.mp3')
                    --shellcase:play() 
                end
            )
        end
    )
end

function Traitor:update(dt)
    if self.dead then return end --don't update if we're dead, just wait for trash collection.
    --always point towards player
    self.angle = self.angle + 0.01

    --local actX, actY, collisions, lenCol = self.world:check(self.rect, newX, newY)

    local othX, othY, spotted, lenSpotCol = self.world:check(self.rangeRect, self.x, self.y)
    --print(lenSpotCol)
    for k,v in pairs(spotted) do
        if v.other.name == 'player' then
            --print("Player spotted")
            self.angle = findRotation(self.x, self.y, self.player.x, self.player.y), math.pi * 2
            if self.shoot then self:fire() end
        end
    end

    --if love.keyboard.isDown("space") then print("x: " .. self.x .. " y: " .. self.y .. " angle: " .. self.angle) end --for debugging
end

function Traitor:fire()
    b = Bullet(self.x, self.y, self.angle, 10, self.player.map, self.rect)
    table.insert(self.player.map.entities, b)

    local gunshot = love.audio.newSource('sounds/gunshot.mp3')
    gunshot:play()

    Timer.after(math.random(), function ()
        local shellcase = love.audio.newSource('sounds/shellcase.mp3')
        shellcase:play() 
    end
    )
end

function Traitor:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Traitor:render()
    if not self.dead then 
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.skin], self.x, self.y, self.angle, 1, 1, self.originX, self.originY)
    end
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

function Traitor:damage(damage, source)
    print(self.health)
    self.health = self.health - damage
    if self.health <= 0 then 
        self.dead = true
        self.world:remove(self.rect)
    end 
end