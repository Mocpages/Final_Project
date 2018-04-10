PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player (VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, self)

    self.map = Map(self.player)
    self.player:setMap(self.map)
    self.direction = 0
    self.x = 0
    self.y = 0
end

function PlayState:enter(params)

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.isDown('left') then
        self.direction = 1
    elseif love.keyboard.isDown('right') then
        self.direction = 2
    elseif love.keyboard.isDown('up') then
        self.direction = 3
    elseif love.keyboard.isDown('down') then
        self.direction = 4
    else
        self.direction = 0
    end

    self.player:update(dt)
end

function PlayState:render()
    if self.direction == 1 then
        self.x = self.x + 10
    elseif self.direction == 2 then
        self.x = self.x - 10
    elseif self.direction == 3 then
        self.y = self.y + 10
    elseif self.direction == 4 then
        self.y = self.y - 10
    end

    --love.graphics.translate(self.x, self.y)
    self.map:render()
    self.player:render()
end