DeathState = Class{__includes = BaseState}

function DeathState:init()

end

function DeathState:enter(params)

end

function DeathState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function DeathState:render()
    love.graphics.draw(gTextures['death'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['death']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['death']:getHeight())

     love.graphics.setFont(gFonts['extra-large'])
     love.graphics.printf('Game Over!', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

     love.graphics.setFont(gFonts['large'])
     love.graphics.printf('Press Enter to continue', 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')
end

function DeathState:exit()

end