PipePair = Class{};

local GAP_HEIGHT = 90;

TOP = 'top';
BOTTOM = 'bottom';

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32;
    self.y = y;

    self.pipes = {
        [TOP] = Pipe(TOP, self.y),
        [BOTTOM] = Pipe(BOTTOM, self.y + PIPE_HEIGHT + GAP_HEIGHT)
    };

    self.remove = false;
    self.isScored = false;
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x + PIPE_SCROLL_SPEED * dt;
        self.pipes[TOP].x = self.x;
        self.pipes[BOTTOM].x = self.x;
    else
        self.remove = true;
    end
end

function PipePair:render()
    -- print('y:' .. self.pipes[TOP].y)
    self.pipes[TOP]:render();
    -- print('y:' .. self.pipes[BOTTOM].y)
    self.pipes[BOTTOM]:render();
end