PlayState = Class{__includes = State}

PIPE_SCROLL_SPEED = -60;
PIPE_HEIGHT = 288;
PIPE_WIDTH = 70;

BIRD_WIDTH = 38;
BIRD_HEIGHT = 24;

function PlayState:init()
    self.bird = Bird();
    self.pipePairs = {};
    self.spawnTimer = 0;
    self.SPAWN_INTERVAL = 2;
    self.score = 0

    self.lastPipeY = -PIPE_HEIGHT + math.random(80) + 20;
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt;

    if self.spawnTimer > self.SPAWN_INTERVAL then
        local newPipePairY = math.max(
            -PIPE_HEIGHT + 10,
            math.min(self.lastPipeY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)
        )
        self.lastPipeY = newPipePairY;

        table.insert(self.pipePairs, PipePair(newPipePairY));
        self.spawnTimer = 0;
    end

    
    for key, pair in pairs(self.pipePairs) do
        
        if not pair.isScored then
            if pair.x + PIPE_WIDTH <  self.bird.x then
                self.score = self.score + 1;
                pair.isScored = true;
            end
        end
        
        pair:update(dt);
    end
    
    -- Second loop required to remove pipePairs from table as deleting
    -- items from a table in place can cause items to be skipped due to everything
    -- being move down by 1 index
    for key, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(pair, key)
        end
    end

    self.bird:update(dt);

    for key, pair in pairs(self.pipePairs) do
        for lKey, pipe in pairs(pair.pipes) do
            if self.bird:isCollidingWith(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                });
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        });
    end
end

function PlayState:render()
    for key, pair in pairs(self.pipePairs) do
        pair:render();
    end

    self.bird: render();

    love.graphics.setFont(flappyFont);
    love.graphics.print('Score: ' .. self.score, 8, 8);
end