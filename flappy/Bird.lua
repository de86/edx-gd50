Bird = Class{}

local GRAVITY = 20;

function Bird:init()
    self.image = love.graphics.newImage('bird.png');
    self.width = self.image:getWidth();
    self.height = self.image:getHeight();

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2);
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2);

    self.dy = 0;
end

function Bird:isCollidingWith(pipe)
    birdLeftEdgeWithOffset = self.x + 2;
    birdRightEdgeWithOffset = (birdLeftEdgeWithOffset) + (self.width - 4);
    birdTopEdgeWithOffset = self.y + 2;
    birdBottomEdgeWithOffset = (birdTopEdgeWithOffset) + (self.height - 4);

    pipeLeftEdge = pipe.x;
    pipeRightEdge = pipeLeftEdge + PIPE_WIDTH;
    pipeTopEdge = pipe.y;
    pipeBottomEdge = pipeTopEdge + PIPE_HEIGHT;

    if birdRightEdgeWithOffset >= pipeLeftEdge and birdLeftEdgeWithOffset <= pipeRightEdge then
        if birdBottomEdgeWithOffset >= pipeTopEdge and birdTopEdgeWithOffset <= pipeBottomEdge then
            print('collision');
            return true;
        end
    end

    -- If we get here there is no collision
    return false;
end

function Bird:update(dt)
    -- Add gravity to velocity
    self.dy = self.dy + (GRAVITY * dt);

    -- Move by current velocity
    self.y = self.y + self.dy;

    if love.keyboard.wasPressed('space') then
        self.dy = -5;
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end