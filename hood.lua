local counterhood 
local heart 
function hoodload()
    h = 3
    counterhood = love.graphics.newImage("assets/balalayka.png")
    heart = love.graphics.newImage("assets/heart.png")
    xh = love.graphics.getWidth() - love.graphics.getWidth()/6.2
end

function hooddraw(player)
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.print("X:"..player.BalalaikaCapacity, smallfont, xh+60, 55)
    love.graphics.draw(counterhood, xh, 35, 0, 2, 2)
    for i = 1, h, 1 do
        love.graphics.draw(heart, 10 + i * 40, 50, 0, 4, 4)
    end
end