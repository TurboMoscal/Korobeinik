local pic
function CreateBullet(world, x, y, direction)
    local bullet = {}
    bullet.body = love.physics.newBody(world, x, y, "dynamic")
    bullet.body:setAngle(math.atan2(direction.y,direction.x))
    --status = Body:isBullet()
    bullet.shape = love.physics.newRectangleShape(8,6)
    bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape, 1)
    bullet.fixture:setCategory(3)
    bullet.tag = "bullet"
    bullet.fixture:setUserData(bullet)
    bullet.lifetimer = 0
    local force = vector2.mult(direction, 1600)
    bullet.body:setLinearVelocity(force.x, force.y)
    pic = love.graphics.newImage("assets/bullet.png")
    return bullet
end

function FindBulletIndex(bullets, bullet)
    for i = 1, #bullets, 1 do
        if bullets[i].fixture == bullet.fixture then
            return i
        end
    end
    return -1
end

function UpdateBullets(bullets, dt)
    local indextoremove = -1
    for i = 1, #bullets, 1 do
        if bullets[i] then
            bullets[i].lifetimer = bullets[i].lifetimer + dt
            if bullets[i].lifetimer > 0.7 then
                bullets[i].body:destroy()
                bullets[i].shape:release()
                table.remove(bullets, i)
                break
            end
        end
        if con then
            if  not  playerxmore then 
                bullets[i].body:applyLinearImpulse(-10,-2)
            else
                bullets[i].body:applyLinearImpulse(10,-2)
            end 
        end
    end 
end



function BeginContactBullet(fixtureA, fixtureB, contact, bullets)

    local bullet

    if (fixtureA:getUserData().tag == "bullet" and 
       fixtureB:getUserData().tag == "player") then 
        if con then 
            bullet = fixtureA:getUserData()
        end        
    elseif (fixtureA:getUserData().tag == "player" and 
       fixtureB:getUserData().tag == "bullet") then
        if con then 
            bullet = fixtureB:getUserData()      
        end     
    end
  
        local categoryA = fixtureA:getCategory()
        local categoryB = fixtureB:getCategory()
        if (categoryA == 3 and categoryB == 2) then 
            bullet = fixtureA:getUserData()  
        elseif (categoryA == 2 and categoryB == 3) then
            bullet = fixtureB:getUserData()  
        end
       
    if (fixtureA:getUserData().tag == "bullet" and 
       fixtureB:getUserData().tag == "ammo") then 
        bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "ammo" and 
       fixtureB:getUserData().tag == "bullet") then
        bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "amonite") then 
    bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "amonite" and 
    fixtureB:getUserData().tag == "bullet") then
     bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "box") then 
    bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "box" and 
    fixtureB:getUserData().tag == "bullet") then
     bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "enemy") then 
    bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "enemy" and 
    fixtureB:getUserData().tag == "bullet") then
     bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "baba") then 
    bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "baba" and 
    fixtureB:getUserData().tag == "bullet") then
     bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "gorinich") then 
    bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "gorinich" and 
    fixtureB:getUserData().tag == "bullet") then
     bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "babaattack") then 
        con = true                                                          -- bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "babaattack" and 
    fixtureB:getUserData().tag == "bullet") then
        con = true --bullet = fixtureB:getUserData()           
    end
    if (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "stairs") then 
    bullet = fixtureA:getUserData()        
    elseif (fixtureA:getUserData().tag == "stairs" and  
    fixtureB:getUserData().tag == "bullet") then 
    bullet = fixtureB:getUserData()           
    end
    if bullet  then
        bullet.body:destroy()
        bullet.shape:release()
        bullet.fixture:destroy() 
        local indextoremove = FindBulletIndex(bullets, bullet)
        if indextoremove ~= -1 then
            table.remove(bullets, indextoremove)
        end
    end
end

function DrawBullets(bullets)
    for i = 1, #bullets, 1 do
        if bullets[i] then
            --love.graphics.setColor(1,1,1,1)
            love.graphics.draw(pic,bullets[i].body:getX(),bullets[i].body:getY(),bullets[i].body:getAngle(),0.8,0.8)
        end
    end
end 