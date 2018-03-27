PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()
    self.map = Map(self.player)
end

function PlayState:enter(params)

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.map:render()
end