function CreateStairs(world, x, y, width, height)
    local stairs = {}
    stairs.body = love.physics.newBody(world, x, y, "static")
    stairs.shape = love.physics.newRectangleShape(width, height)
    stairs.fixture = love.physics.newFixture(stairs.body, stairs.shape, 1)
    stairs.fixture:setFriction(0.1)
    stairs.tag = "stairs"
    stairs.fixture:setUserData(stairs)
    return stairs
end

function DrawStairs(stairs1)
    love.graphics.setColor(0, 1, 1)
    for i = 1, #stairs1, 1 do
        love.graphics.polygon("fill",stairs1[i].body:getWorldPoints(stairs1[i].shape:getPoints()))
    end
end