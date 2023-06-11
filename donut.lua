local pic1
function CreateDonut(world, x, y, direction)
    local donut = {}
    donut.body = love.physics.newBody(world, x, y, "dynamic")
 
    donut.shape = love.physics.newCircleShape(8)
    donut.fixture = love.physics.newFixture(donut.body, donut.shape, 1)
    donut.tag = "donut"
    donut.fixture:setUserData(donut)
    donut.fixture:setCategory(4)
    donut.lifetimer = 0
    local force = vector2.mult(direction, 900)
    donut.body:setLinearVelocity(force.x, force.y)
    pic1 = love.graphics.newImage("assets/donut.png")
    return donut
end

function FindDonutIndex(donuts, donut)
    for i = 1, #donuts, 1 do
        if donuts[i].fixture == donut.fixture then
            return i
        end
    end
    return -1
end

function UpdateDonuts(donuts, dt)
    local indextoremove = -1
    for i = 1, #donuts, 1 do
        if donuts[i] then
            donuts[i].lifetimer = donuts[i].lifetimer + dt
            if donuts[i].lifetimer > 0.6 then
                donuts[i].body:destroy()
                donuts[i].shape:release()
                table.remove(donuts, i)
                break
            end
        end
    end 
end

function BeginContactDonut(fixtureA, fixtureB, contact, donuts)
    local donut
    local categoryA = fixtureA:getCategory()
    local categoryB = fixtureB:getCategory()
    if (categoryA == 4 and categoryB == 2) then 
        donut = fixtureA:getUserData()  
    elseif (categoryA == 2 and categoryB == 4) then
        donut = fixtureB:getUserData()  
    end
   
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "player") then 
        if con then 
            donut = fixtureA:getUserData()   
        end     
    elseif (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "donut") then
        if con then 
            donut = fixtureA:getUserData()   
        end       
    end
 
    if (fixtureA:getUserData().tag == "donut" and 
       fixtureB:getUserData().tag == "ammo") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "ammo" and 
       fixtureB:getUserData().tag == "donut") then
        donut = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "amonite") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "amonite" and 
    fixtureB:getUserData().tag == "donut") then
        donut = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "box") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "box" and 
    fixtureB:getUserData().tag == "donut") then
     donut = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "enemy") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "enemy" and 
    fixtureB:getUserData().tag == "donut") then
        donut = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "gorinich") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "gorinich" and 
    fixtureB:getUserData().tag == "donut") then
        donut = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "baba") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "baba" and 
    fixtureB:getUserData().tag == "donut") then
        donut = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "babaattack") then 
        con = true                                                                 
    elseif (fixtureA:getUserData().tag == "babaattack" and 
    fixtureB:getUserData().tag == "bullet") then
        con = true --bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "stairs") then 
        donut = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "stairs" and 
    fixtureB:getUserData().tag == "donut") then
        donut = fixtureB:getUserData()           
    end
    if donut then
        donut.body:destroy()
        donut.shape:release()
        donut.fixture:destroy() 
        local indextoremove = FindDonutIndex(donuts, donut)
        if indextoremove ~= -1 then
            table.remove(donuts, indextoremove)
        end
    end
end

function DrawDonuts(donuts)
    for i = 1, #donuts, 1 do
        if donuts[i] then
        
            love.graphics.draw(pic1,donuts[i].body:getX(),donuts[i].body:getY(),0,0.7,0.7)
        end
    end
end