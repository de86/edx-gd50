Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x;
    self.y = y;
    
    self.width = width;
    self.height = height;
    
    vel = self.getRandomVelocity();
    self.dx = vel.dx;
    self.dy = vel.dy;
end



function Ball:getRandomVelocity()
    return {
        dx = math.random(2) == 1 and 100 or -100,
        dy = math.random(-50, 50)
    }
end



function Ball:collidesWith(paddle)
    -- Check if the left edge of either is beyond than the right edge of the other.
    -- If so not colliding
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Check if the top edge of either is beyond than the bottom edge of the other.
    -- If so not colliding
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- If above checks failed then we must be colliding
    return true
end



function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2;
    self.y = VIRTUAL_HEIGHT / 2 - 2;

    vel = self.getRandomVelocity();
    self.dx = vel.dx;
    self.dy = vel.dy;
end



function Ball:update(dt)
    self.x = self.x + self.dx * dt;
    self.y = self.y + self.dy * dt;
end



function Ball:render()
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.width,
        self.height
    );

    if DEBUG then
        love.graphics.setColor(0, 1, 0, 1);
        love.graphics.points(self.x, self.y);
        love.graphics.print(tostring(self.y), self.x, self.y - 10);
        love.graphics.setColor(1, 1, 1, 1);
    end
end