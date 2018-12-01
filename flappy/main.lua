push = require 'push';
Class = require 'class';

require 'StateMachine';
require 'states/State';
require 'states/CountDownState';
require 'states/PlayState';
require 'states/ScoreState';
require 'states/TitleScreenState';

require 'Bird';
require 'Pipe';
require 'PipePair';

WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WIDTH = 512;
VIRTUAL_HEIGHT = 288;

local background = love.graphics.newImage('background.png');
local backgroundScroll = 0;
local BACKGROUND_LOOP_POINT = 413;

local ground = love.graphics.newImage('ground.png');
local groundScroll = 0;

local BACKGROUND_SCROLL_SPEED = 30;
local GROUND_SCROLL_SPEED = 60;

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest');

    smallFont = love.graphics.newFont('font.ttf', 8);
    mediumFont = love.graphics.newFont('flappy.ttf', 14);
    flappyFont = love.graphics.newFont('flappy.ttf', 28);
    hugeFont = love.graphics.newFont('flappy.ttf', 56);
    love.graphics.setFont(flappyFont);

    love.window.setTitle('flappy');

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = false,
        resizable = true,
        fullscreen = false
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountDownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title');

    love.keyboard.keysPressed = {};
end

function love.resize(width, height)
    push:resize(width, height);
end

function love.keypressed(key)
    print(key);
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true;
    else
        return false;
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOP_POINT;
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH;

    gStateMachine:update(dt);

    love.keyboard.keysPressed = {};
end

function love.draw()
    push:start();

    love.graphics.draw(background, -backgroundScroll, 0);    

    gStateMachine:render();

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16);
    
    push:finish();
end