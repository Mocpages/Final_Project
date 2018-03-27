StartState = Class{__includes = BaseState}

function StartState:init()

end

function StartState:enter(params)

end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        VIRTUAL_WIDTH / gTextures['background']:getWidth(),
        VIRTUAL_HEIGHT / gTextures['background']:getHeight())

     love.graphics.setFont(gFonts['extra-large'])
     love.graphics.printf('Project 50', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

     love.graphics.setFont(gFonts['large'])
     love.graphics.printf('Press Enter to continue', 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')
end

function StartState:exit()

end