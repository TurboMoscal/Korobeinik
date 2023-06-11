function CreateAttack(world, x, y,direction)
    local attack = {}
    attack.body = love.physics.newBody(world, x, y, "dynamic")
    --status = Body:isBullet()
    attack.shape = love.physics.newRectangleShape(8,8)
    attack.fixture = love.physics.newFixture(attack.body, attack.shape, 1)
    attack.tag = "attack"
    attack.fixture:setUserData(attack)
    attack.lifetimer = 0
    local force = vector2.mult(direction, 10)
    attack.body:setLinearVelocity(force.x, force.y)
    return attack
end
    
    function FindAttackIndex(attacks, attack)
        for i = 1, #attacks, 1 do
            if attacks[i].fixture == attack.fixture then
                return i
            end
        end
        return -1
    end
    
    function UpdateAttacks(attacks, dt)
        local indextoremove = -1
        for i = 1, #attacks, 1 do
            if attacks[i] then
                attacks[i].lifetimer = attacks[i].lifetimer + dt
                if attacks[i].lifetimer > 0.2 then
                    attacks[i].body:destroy()
                    attacks[i].shape:release()
                    table.remove(attacks, i)
                    break
                end
            end
        end 
    end
    
    function BeginContactAttack(fixtureA, fixtureB, contact, attacks)
        local attack
        if (fixtureA:getUserData().tag == "attack" and 
           fixtureB:getUserData().tag == "platform") then 
            attack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "platform" and 
           fixtureB:getUserData().tag == "attack") then
            attack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "attack" and 
           fixtureB:getUserData().tag == "ammo") then 
            attack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "ammo" and 
           fixtureB:getUserData().tag == "attack") then
            attack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "attack" and 
        fixtureB:getUserData().tag == "amonite") then 
            attack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "amonite" and 
        fixtureB:getUserData().tag == "attack") then
            attack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "attack" and 
        fixtureB:getUserData().tag == "box") then 
            attack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "box" and 
        fixtureB:getUserData().tag == "attack") then
            attack = fixtureB:getUserData()           
        end
        if (fixtureA:getUserData().tag == "attack" and 
        fixtureB:getUserData().tag == "player") then 
            attack = fixtureA:getUserData()        
        elseif (fixtureA:getUserData().tag == "player" and 
        fixtureB:getUserData().tag == "attack") then
            attack = fixtureB:getUserData()           
        end
        if attack then
            attack.body:destroy()
            attack.shape:release()
            attack.fixture:destroy() 
            local indextoremove = FindAttackIndex(attacks, attack)
            if indextoremove ~= -1 then
                table.remove(attacks, indextoremove)
            end
        end
    end
 