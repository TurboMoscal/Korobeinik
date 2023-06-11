function CreateGorinichAttack(world, x, y,direction)
    local Gorinichattack = {}
    Gorinichattack.body = love.physics.newBody(world, x, y, "dynamic")
    Gorinichattack.shape = love.physics.newRectangleShape(15,15)
    Gorinichattack.fixture = love.physics.newFixture(Gorinichattack.body, Gorinichattack.shape, 1)
    Gorinichattack.tag = "Gorinichattack"
    Gorinichattack.fixture:setUserData(Gorinichattack)
    Gorinichattack.fixture:setCategory(5)
    Gorinichattack.lifetimer = 0
    Gorinichattack.pic = love.graphics.newImage("assets/flame.png")
    local Gforce = vector2.mult(direction, -555)
    Gorinichattack.body:setLinearVelocity(Gforce.x, Gforce.y)
    return Gorinichattack
end
    
    function FindGorinichAttackIndex(Gorinichattacks, Gorinichattack)
        for i = 1, #Gorinichattacks, 1 do
            if Gorinichattacks[i].fixture == Gorinichattack.fixture then
                return i
            end
        end
        return -1
    end
    
    function UpdateGorinichAttack(Gorinichattacks, dt)
        local indextoremove = -1
        for i = 1, #Gorinichattacks, 1 do
            if Gorinichattacks[i] then
                Gorinichattacks[i].lifetimer = Gorinichattacks[i].lifetimer + dt
                if Gorinichattacks[i].lifetimer > 0.8 then
                    Gorinichattacks[i].body:destroy()
                    Gorinichattacks[i].shape:release()
                    table.remove(Gorinichattacks, i)
                    break
                end
            end
        end 
    end
    
    function BeginContactGorinichAttack(fixtureA, fixtureB, contact, Gorinichattacks)
        local Gorinichattack
        local categoryA = fixtureA:getCategory()
        local categoryB = fixtureB:getCategory()
        if (categoryA == 5 and categoryB == 2) then 
            Gorinichattack = fixtureA:getUserData()  
        elseif (categoryA == 2 and categoryB == 5) then
            Gorinichattack = fixtureB:getUserData()  
        end
    
        if (fixtureA:getUserData().tag == "Gorinichattack" and 
           fixtureB:getUserData().tag == "platform") then 
            Gorinichattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "platform" and 
           fixtureB:getUserData().tag == "Gorinichattack") then
            Gorinichattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "Gorinichattack" and 
           fixtureB:getUserData().tag == "ammo") then 
            Gorinichattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "ammo" and 
           fixtureB:getUserData().tag == "Gorinichattack") then
            Gorinichattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "Gorinichattack" and 
        fixtureB:getUserData().tag == "amonite") then 
            Gorinichattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "amonite" and 
        fixtureB:getUserData().tag == "Gorinichattack") then
            Gorinichattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "Gorinichattack" and 
        fixtureB:getUserData().tag == "box") then 
            Gorinichattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "box" and 
        fixtureB:getUserData().tag == "Gorinichattack") then
            Gorinichattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "Gorinichattack" and 
        fixtureB:getUserData().tag == "player") then 
            Gorinichattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "player" and 
        fixtureB:getUserData().tag == "Gorinichattack") then
            Gorinichattack = fixtureB:getUserData()           
        end 
        if Gorinichattack then
            Gorinichattack.body:destroy()
            Gorinichattack.shape:release()
            Gorinichattack.fixture:destroy() 
            local indextoremove = FindAttackIndex(Gorinichattacks, Gorinichattack)
            if indextoremove ~= -1 then
                table.remove(Gorinichattacks, indextoremove)
            end
        end
    end
    
    function DrawGorinichAttack(Gorinichattacks)
        for i = 1, #Gorinichattacks, 1 do
            if Gorinichattacks[i] then
                love.graphics.draw(Gorinichattacks[i].pic,  Gorinichattacks[i].body:getX()-11 ,  Gorinichattacks[i].body:getY() , 0, 0.02,0.02)

            end
        end
    end