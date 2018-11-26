Paddle = Class{};

function Paddle:init(x, y, width, height, isAI)
    self.x = x;
    self.y = y;
    self.dy = 0;
    self.width = width;
    self.height = height;
    self.isAI = isAI;
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt);
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy *dt);
    end
end

function Paddle:updateWithAI(dt, ball)
    offset = (self.height - ball.height) / 2;
    paddleCentre = self.y + self.height / 2;
    ballCentre = ball.y + ball.height / 2;
    maxMoveDistance = 150 * dt;

    if ball.dx > 0 and ball.x > 55 then
        if ballCentre > paddleCentre then
            if (ballCentre - paddleCentre < maxMoveDistance) then
                self.y = ball.y - offset;
            else
                self.y = self.y + maxMoveDistance;
            end
        elseif ballCentre < paddleCentre then
            if (ballCentre - paddleCentre < maxMoveDistance) then
                self.y = ball.y - offset;
            else
                self.y = self.y - maxMoveDistance;
            end
        end
    end

    self:update(dt);
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height);

    if DEBUG then
        love.graphics.setColor(0, 1, 0, 1);
        love.graphics.points(self.x, self.y);
        love.graphics.print(tostring(self.y), self.x, self.y - 20);
        love.graphics.setColor(1, 1, 1, 1);
    end
end
