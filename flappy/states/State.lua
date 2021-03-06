--[[
    Base State class with 4 main interface methods defined.
    This allows us to create new state classes without repeatedly
    defining empty functions for the required methods
]]--

State = Class{};

function State:init() end
function State:enter() end
function State:exit() end
function State:update() end
function State:render() end
