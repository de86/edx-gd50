-- Push is a library that allows to use virtual resolution in windows of any defined size
-- https://github.com/Ulydev/push
push = require 'push';

-- Class library makes OOP in Lua easier
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class';

require 'Ball';
require 'Paddle';

WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 432;
VIRTUAL_HEIGHT = 243;

PADDLE_SPEED = 200;

DEBUG = false;

function love.load()
    -- setDefaultFilter removes any anti-aliasing and is best used for pixel-art graphics
    love.graphics.setDefaultFilter('nearest', 'nearest');

    -- set window title
    love.window.setTitle('lu-pong');

    -- Load in a new font and set it's size
    smallFont = love.graphics.newFont('font.ttf', 8);
    scoreFont = love.graphics.newFont('font.ttf', 32);

    -- Sets active font
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = false,
        fullscreen = false
    })

    -- set up sounds table
    sfx = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    }

    -- Initialize player score variables
    player1Score = 0;
    player2Score = 0;

    player1 = Paddle(10, 30, 5, 20, false);
    player2 = Paddle(VIRTUAL_WIDTH -10, 50, 5, 20, true);

    servingPlayer = math.random(1, 2);
    winningPlayer = 0;
    
    -- Init Ball
    ball = Ball(
        VIRTUAL_WIDTH / 2 - 2,
        VIRTUAL_HEIGHT / 2 - 2,
        4,
        4
    )

    -- Game state
    gameState = 'start'
end



function resetGame()
    player1Score = 0;
    player2Score = 0;
    ball:reset();
    servingPlayer = math.random(1, 2);
    winningPlayer = 0;
    gameState = 'serve';
end



function love.keypressed(key)
    if key == 'escape' then
        love.event.quit();
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            resetGame();
        end
    elseif key == 'r' then
        resetGame();
    elseif key == 'd' then
        DEBUG = not DEBUG;
    end
end



-- Runs every frame. dt = DeltaTime (Time since last update)
function love.update(dt)
    if love.keyboard.isDown('v') then
        dt = dt * 2;
    elseif love.keyboard.isDown('c') then
        dt = dt / 4;
    end

    if gameState == 'serve' then
        ball.dy = math.random(-50, 50);

        if servingPlayer == 1 then
            ball.dx = math.random(140, 200);
        else
            ball.dx = -math.random(140, 200);
        end
    elseif gameState == 'play' then
        -- Detect Collision with paddles
        if ball:collidesWith(player1) or ball:collidesWith(player2) then
            prevDy = ball.dy;
            prevDx = ball.dx;
            
            ball.dx = -ball.dx * 1.05;
            ball.dy = math.random(10, 150);

            if prevDy < 0 then
                ball.dy = -ball.dy;
            end
            
            if prevDx > 0 then
                ball.x = player2.x - player2.width;
            else
                ball.x = player1.x + player1.width;
            end

            sfx.paddle_hit:play();
        end

        -- Detect out of bounds top and bottom
        if ball.y <= 0 then
            ball.y = 0;
            ball.dy = -ball.dy;
            sfx.wall_hit:play();
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT -4;
            ball.dy = -ball.dy;
            sfx.wall_hit:play();
        end
    elseif gameState == 'done' then
        ball:reset();
    end

    -- Player 1 movement
    if love.keyboard.isDown('up') then
        player1.dy = -PADDLE_SPEED;
    elseif love.keyboard.isDown('down') then
        player1.dy = PADDLE_SPEED;
    else
        player1.dy = 0;
    end

    -- Player 2 movement
    if player2.isAI == false then
        if love.keyboard.isDown('w') then
            player2.dy = -PADDLE_SPEED;
        elseif love.keyboard.isDown('s') then
            player2.dy = PADDLE_SPEED;
        else
            player2.dy = 0;
        end
    end

    -- Check if scored
    if ball.x > VIRTUAL_WIDTH then
        player1Score = player1Score + 1;
        ball:reset();
        servingPlayer = 2;
        gameState = 'serve';
        sfx.score:play();
    elseif ball.x < 0 - ball.width then
        player2Score = player2Score + 1;
        ball:reset();
        servingPlayer = 1;
        gameState = 'serve';
        sfx.score:play();
    end

    -- Check if we have a winner
    if player1Score >= 10 or player2Score >= 10 then
        winningPlayer = player1Score > player2Score and 1 or 2;
        servingPlayer = player1Score > player2Score and 2 or 1;
        gameState = 'done';
    end

    -- Update balls position if we are in the play state
    if gameState == 'play' then
        ball:update(dt);
    end

    player1:update(dt);

    if player2.isAI then
        player2:updateWithAI(dt, ball);
    else
        player2:update(dt);
    end
end



function renderFPS()
    love.graphics.setFont(smallFont);
    love.graphics.setColor(0, 1, 0, 1);
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), VIRTUAL_WIDTH - 40, 10);
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.setFont(smallFont);
end



function love.draw()
    -- begins rendering at virtual resolution
    push:apply('start');

    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.setFont(smallFont);

    -- Draw Paddles
    player1:render();
    player2:render();

    -- Draw Ball
    ball:render();

    -- Draw HUD

    statusMessage = '';

    if gameState == 'start' then
        statusMessage = 'Welcome to Lu-Pong! Press Enter to begin';
    elseif gameState == 'serve' then
        statusMessage = 'Player ' .. servingPlayer .. ' to serve';
    elseif gameState == 'done' then
        statusMessage = 'Player ' .. winningPlayer .. ' wins!';
    else
        statusMessage = '';
    end

    if gameState == 'done' then
        love.graphics.setColor(0, 1, 0, 1);
    end

    love.graphics.printf(
        statusMessage, -- Text to render
        0,             -- Starting X
        20,            -- Starting Y
        VIRTUAL_WIDTH, -- Width of area to draw text in
        'center'       -- Alignment of text in space starting at X width of WINDOW_WIDTH
    );

    if gameState == 'done' then
        love.graphics.setColor(1, 1, 1, 1);
    end

    love.graphics.printf(
        gameState,     -- Text to render
        0,             -- Starting X
        32,            -- Starting Y
        VIRTUAL_WIDTH, -- Width of area to draw text in
        'center'       -- Alignment of text in space starting at X width of WINDOW_WIDTH
    );

    love.graphics.setFont(scoreFont);

    if winningPlayer == 1 then
        love.graphics.setColor(0, 1, 0, 1);
    end
    love.graphics.print(
        tostring(player1Score),
        VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3
    );

    if winningPlayer == 2 then
        love.graphics.setColor(0, 1, 0, 1);
    end
    love.graphics.print(
        tostring(player2Score),
        VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3
    );

    if DEBUG then
        renderFPS();
    end

    -- begins rendering at virtual resolution
    push:apply('end');
end