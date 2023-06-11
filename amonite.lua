local amonitPic
local amonitPic1
local ammoniteTable
local ammoniteTable1 

function CreateAmonite(world,x,y)
    local amonite = {}
    amonite.body = love.physics.newBody(world, x, y, "kinematic")
    amonite.shape = love.physics.newRectangleShape(15, 15)
    amonite.fixture = love.physics.newFixture(amonite.body,amonite.shape,1)
    amonite.fixture:setFriction(0.1)
    amonite.fixture:setUserData(amonite)
    amonite.tag = "amonite"
    amonite.sound = love.audio.newSource("MusicAndSounds/ammonite1.mp3","static")
    amonitPic = love.graphics.newImage("assets/amonite.png")
    return  amonite
end

function CreateDesAmonite(world,x,y)
    local amonitd
    amonitd = {}
    amonitd.body = love.physics.newBody(world, x, y, "kinematic")
    amonitd.shape = love.physics.newRectangleShape(1, 1)
    amonitd.fixture = love.physics.newFixture(amonitd.body,amonitd.shape,1)
    amonitPic1 = love.graphics.newImage("assets/amonite1.png")
    amonitd.fixture:setUserData(amonitd)
    amonitd.tag = "amonitd"
    return amonitd
end

function FindAmoniteIndex( amonites, amonite)
    for i = 1, #amonites, 1 do
        if  amonites[i].fixture == amonite.fixture then
            return i
        end
    end
    return -1
end

function BeginContactAmonite(fixtureA, fixtureB, contact, amonites)
    
    local amonite
    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "amonite") then 
        local normal = vector2.new(contact:getNormal())
        if normal.y == 1 then
            if h == 3 then 
                h = h - 1 
            elseif h < 3 then 
                local number = math.random(1,10)
                if number > 7 then 
                    h = h - 1 
                else
                    h = h + 1 
                end 
            end
            amonite = fixtureB:getUserData()
        end  
        
    elseif (fixtureA:getUserData().tag == "amonite" and 
    fixtureB:getUserData().tag == "player") then
         local normal = vector2.new(contact:getNormal())
         if normal.y == 1 then
            if h == 3 then 
              h   = h - 1 
            elseif h < 3 then 
                local number = math.random(1,10)
                if number > 7 then 
                    h = h - 1 
                else
                    h = h + 1 
                end 
            end
            amonite = fixtureB:getUserData()
        end     
    end
    if amonite then
        love.audio.play(amonite.sound)
        amonite.body:destroy()
        amonite.shape:release()
        amonite.fixture:destroy() 
        local indextoremove = FindAmoniteIndex(amonites,amonite)
        if indextoremove ~= -1 then
            table.remove(amonites, indextoremove)
        end
    end
end
   --[[ function RestartAmonite(amonite,amonites)
        amonite.body:destroy()
        amonite.shape:release()
        amonite.fixture:destroy() ]]
       
        --[[for i = 1,#amonites,1 do 
            table.remove(amonites, i)
        end]]
    --end

function DrawAmonite(amonites)
    for i = 1,#amonites,1 do 
        love.graphics.draw(amonitPic,amonites[i].body:getX()-15, amonites[i].body:getY()-22,0,0.9,0.9)
    end
end


function DrawDesAmonite(amonides)    
    for i = 1,#amonides,1 do 
        love.graphics.draw(amonitPic1,amonides[i].body:getX()-6, amonides[i].body:getY()-47,0,0.6,0.6)
    end
end