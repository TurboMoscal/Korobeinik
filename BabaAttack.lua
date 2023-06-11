function CreateBabaAttack(world, x, y,direction)
    local babaattack = {}
    babaattack.body = love.physics.newBody(world, x, y, "static")
    --status = Body:isBullet()
    babaattack.shape = love.physics.newRectangleShape(10,36)
    babaattack.fixture = love.physics.newFixture(babaattack.body, babaattack.shape, 1)
    babaattack.tag = "babaattack"
    babaattack.fixture:setUserData(babaattack)
    babaattack.lifetimer = 0
    local Bforce = vector2.mult(direction, -555)
    babaattack.body:setLinearVelocity(Bforce.x, Bforce.y)
    return babaattack
end
    
    function FindBabaAttackIndex(babaattacks, babaattack)
        for i = 1, #babaattacks, 1 do
            if babaattacks[i].fixture == babaattack.fixture then
                return i
            end
        end
        return -1
    end
    
    function UpdateBabaAttack(babaattacks, dt)
        local indextoremove = -1
        for i = 1, #babaattacks, 1 do
            if babaattacks[i] then
                babaattacks[i].lifetimer = babaattacks[i].lifetimer + dt
                if babaattacks[i].lifetimer > 0.299 then
                    babaattacks[i].body:destroy()
                    babaattacks[i].shape:release()
                    table.remove(babaattacks, i)
                    break
                end
            end
        end 
    end
    
    function BeginContactBabaAttack(fixtureA, fixtureB, contact, babaattacks)
        local babaattack
        if (fixtureA:getUserData().tag == "babaattack" and 
           fixtureB:getUserData().tag == "platform") then 
           babaattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "platform" and 
           fixtureB:getUserData().tag == "babaattack") then
           babaattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "babaattack" and 
           fixtureB:getUserData().tag == "ammo") then 
            babaattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "ammo" and 
           fixtureB:getUserData().tag == "babaattack") then
            babaattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "babaattack" and 
        fixtureB:getUserData().tag == "amonite") then 
            babaattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "amonite" and 
        fixtureB:getUserData().tag == "babaattack") then
            babaattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "babaattack" and 
        fixtureB:getUserData().tag == "box") then 
            babaattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "box" and 
        fixtureB:getUserData().tag == "babaattack") then
            babaattack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "babaattack" and 
        fixtureB:getUserData().tag == "player") then 
            babaattack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "player" and 
        fixtureB:getUserData().tag == "babaattack") then
            babaattack = fixtureB:getUserData()           
        end 
        if babaattack then
            babaattack.body:destroy()
            babaattack.shape:release()
            babaattack.fixture:destroy() 
            local indextoremove = FindBabaAttackIndex(babaattacks, babaattack)
            if indextoremove ~= -1 then
                table.remove(babaattacks, indextoremove)
            end
        end
    end
    
   --[[function DrawBabaAttack(babaattacks)
        for i = 1, #babaattacks, 1 do
            if babaattacks[i] then
                love.graphics.setColor(1,1,0,1)
                love.graphics.polygon("fill", babaattacks[i].body:getWorldPoints(babaattacks[i].shape:getPoints()))
            end
        end
    end]]