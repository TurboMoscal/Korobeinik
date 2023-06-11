local ammoPic 
local ammoPic1
function CreateAmmo(world,x,y)
    local ammo = {}
    ammo.body = love.physics.newBody(world, x, y, "kinematic")
    ammo.shape = love.physics.newRectangleShape(58, 64)
    ammo.fixture = love.physics.newFixture(ammo.body,ammo.shape,1)
    ammo.fixture:setFriction(0.1)
    ammo.fixture:setUserData(ammo)
    ammo.tag = "ammo"
    ammoPic = love.graphics.newImage("assets/ammobox.png")
    ammo.sound = love.audio.newSource("MusicAndSounds/ammo1.mp3","static")
    ammo.lives = 10
    return  ammo
end

function CreateDesAmmo(world,x,y)
    local amod
    amod = {}
    amod.body = love.physics.newBody(world, x, y, "kinematic")
    amod.shape = love.physics.newRectangleShape(1, 1)
    amod.fixture = love.physics.newFixture(amod.body,amod.shape,1)
    ammoPic1 = love.graphics.newImage("assets/ammobox1.png")
    amod.fixture:setUserData(amod)
    amod.tag = "ammod"
    return amod
end

function FindAmmoIndex(ammo1, ammo)
    for i = 1, #ammo1, 1 do
        if ammo1[i].fixture == ammo.fixture then
            return i
        end
    end
    return -1
end

function BeginContactAmmo(fixtureA, fixtureB, contact, ammo1,player)
    local ammo
    if (fixtureA:getUserData().tag == "ammo" and 
        fixtureB:getUserData().tag == "player") then      
        local normal = vector2.new(contact:getNormal())
        if normal.y == 1 then
            if player.BalalaikaCapacity <15 then 
                player.BalalaikaCapacity =  15
                ammo = fixtureA:getUserData() 
            end
            if player.flytimer > 1.06  then --------------------------------------------------------------------------------------------------------------------
                h = h - 1 
            end 
        endw
    elseif (fixtureA:getUserData().tag == "player" and 
        fixtureB:getUserData().tag == "ammo") then
        local normal = vector2.new(contact:getNormal())
        if normal.y == 1 then
            if player.BalalaikaCapacity <15 then 
                player.BalalaikaCapacity = 15 
                ammo = fixtureB:getUserData()
            end
            if player.flytimer > 1.06  then --------------------------------------------------------------------------------------------------------------------
                h = h - 1 
            end 
        end  
        if ammo then
            love.audio.play(ammo.sound)
            ammo.body:destroy()
            ammo.shape:release()
            ammo.fixture:destroy() 
            local indextoremove = FindAmmoIndex(ammo1,ammo)
            if indextoremove ~= -1 then
                table.remove(ammo1, indextoremove)
            end
        end      
    end
    
    if (fixtureA:getUserData().tag == "ammo" and fixtureB:getUserData().tag == "bullet") then
        ammo = fixtureA:getUserData()
        ammo.lives = ammo.lives - 3.5
    
    elseif (fixtureA:getUserData().tag == "bullet" and fixtureB:getUserData().tag == "ammo") then
        ammo = fixtureB:getUserData()
        ammo.lives = ammo.lives - 3.5
     
    end      
    if (fixtureA:getUserData().tag == "ammo" and fixtureB:getUserData().tag == "donut") then
        ammo = fixtureA:getUserData()
        ammo.lives = ammo.lives - 2
     
    elseif (fixtureA:getUserData().tag == "donut" and fixtureB:getUserData().tag == "ammo") then
        ammo = fixtureB:getUserData()
        ammo.lives = ammo.lives - 2
     
    end      
    if ammo and ammo.lives <= 0 then
        if player.BalalaikaCapacity < 15 then 
            player.BalalaikaCapacity = 15 
        end
        love.audio.play(ammo.sound)
        ammo.body:destroy()
        ammo.shape:release()
        ammo.fixture:destroy() 
        local indextoremove = FindAmmoIndex(ammo1,ammo)
        if indextoremove ~= -1 then
            table.remove(ammo1, indextoremove)
        end
    end
end



function DrawAmmo(ammo1)
    for i = 1,#ammo1,1 do 
        love.graphics.draw(ammoPic,ammo1[i].body:getX()-32, ammo1[i].body:getY()-95,0,4,4)
    end
end

function DrawDesAmmo(ammodes)    
    for i = 1,#ammodes,1 do 
        love.graphics.draw(ammoPic1,ammodes[i].body:getX()-32, ammodes[i].body:getY()-132,0,4,4)
    end
end
