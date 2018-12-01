ScoreState = Class{__includes = State}

function ScoreState:enter(params)
    self.score = params.score;
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown');
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont);
    love.graphics.printf('You died', 0, 64, VIRTUAL_WIDTH, 'center');

    love.graphics.setFont(mediumFont);
    love.graphics.printf('Score: ' .. self.score, 0, 100, VIRTUAL_WIDTH, 'center');

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center');
end