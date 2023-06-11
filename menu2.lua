f = love.graphics.newFont("assets/PS.ttf", 43)

local buttons = {}

function ButtonSpawn2(x,y,text,id,font)
    table.insert(buttons,{x = x,y = y , text = text, id = id})
end

function ButtonDraw2()
    for i , v in ipairs(buttons) do
        if v.mouseover == false then 
            love.graphics.setColor(1,1,1)
        end
        if v.mouseover == true then 
            love.graphics.setColor(1,0,0)
        end
        love.graphics.print(v.text,mediumfont,v.x,v.y)
        love.graphics.setColor(1,1,1)
    end
end

function ButtonClick2(x,y)
    for i , v in ipairs(buttons) do
        if x > v.x and x < v.x + f:getWidth(v.text) and y > v.y and y < v.y + f:getHeight(v.text) then 
            if v.id == "quit" then 
                love.audio.play(buttonsound)
                love.timer.sleep(0.3)
                love.event.push("quit")
            end 
            if v.id == "restart" then 
                love.audio.play(buttonsound)
                love.event.quit("restart")
            end 
            if v.id == "continue" then 
                gamestate = "playing"
                love.audio.play(buttonsound)
            end 
        end
    end
end

function ButtonChek2()
    for i,v in ipairs(buttons) do
        if mousex > v.x and mousex < v.x  + f:getWidth(v.text) and mousey > v.y and mousey < v.y + f:getHeight(v.text) then 
            v.mouseover = true 
        else
            v.mouseover = false
        end
    end
end