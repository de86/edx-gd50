CountDownState = Class{__includes = State}

local COUNT_TIME = 0.75;

function CountDownState:init()
    self.count = 3;
    self.timer = 0;
end

function CountDownState:update(dt)
    self.timer = self.timer + dt;

    if self.timer > COUNT_TIME then
        self.timer = self.timer % COUNT_TIME;
        self.count = self.count - 1;

        if self.count <= 0 then
            gStateMachine:change('play');
        end
    end
end

function CountDownState:render()
    love.graphics.setFont(hugeFont);
    love.graphics.printf(self.count, 0, 120, VIRTUAL_WIDTH, 'center');
end