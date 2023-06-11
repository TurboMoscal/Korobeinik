require "hood"
require "amonite"

local IDLE, JUMP, RUN = 1, 2, 3 

function CreatePlayer(world, x, y)
    local player = {}
    player.body = love.physics.newBody(world, x, y, "dynamic")
    player.shape = love.physics.newRectangleShape(30, 60)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setFriction(0.1)
    player.tag = "player"
    player.fixture:setCategory(1)
    player.fixture:setUserData(player)
    player.body:setFixedRotation(true)
    player.mode ="donut"
    player.jumped = false
    player.onground = false
    player.grounded = false
    player.onstairs = false
    player.collisionnormal = vector2.new(0, 0)
    player.completedlevel = false
    player.bullets = {}
    player.shoottimer = 0
    player.flytimer  = 0
    player.donuts = {}

    player.spritesheet = love.graphics.newImage("assets/new.png")
    player.quads = CreateSpriteSheetQuads(player.spritesheet,4, 6)
    player.frame = 1
    player.animation = IDLE
    player.frametimer = 0
    player.framerate = 0.16
    player.direction = 1

    player.BalalaikaCapacity = 15
    
    player.balalaika = love.audio.newSource("MusicAndSounds/balalayka.mp3","static")
	player.netsrun = love.audio.newSource("MusicAndSounds/netstrun1.ogg","static")
	player.scream = love.audio.newSource("MusicAndSounds/scream.mp3","static")
	player.fall = love.audio.newSource("MusicAndSounds/upal.mp3","static")
    player.flap = love.audio.newSource("MusicAndSounds/vzmach.ogg","static")
    player.steps = love.audio.newSource("MusicAndSounds/steps.mp3","stream")
    player.sound = love.audio.newSource("MusicAndSounds/oh.mp3","static")
    return player
end

function CreateSpriteSheetQuads(spritesheet, cols, rows)
    local w = spritesheet:getWidth() / cols
    local h = spritesheet:getHeight() / rows
    local quads = {}
    local count = 1
    for j = 0, rows - 1, 1 do
        for i = 0, cols - 1, 1 do
            quads[count] = love.graphics.newQuad(i * w, j * h, w, h, spritesheet:getWidth(), spritesheet:getHeight())
            count = count + 1
        end
    end
    return quads
end

function AnimatePlayer(player, animation, dt)
    if player.animation ~= animation then
        player.animation = animation
        player.frametimer = 1
    end
    player.frametimer = player.frametimer + dt
    if player.frametimer > player.framerate then
        player.frametimer = 0     
        player.frame = player.frame + 1   
        if player.animation == RUN then            
            if player.frame < 1 or player.frame > 3 then
                player.frame = 2
            end
        elseif player.animation == JUMP then
            if player.frame < 3 or player.frame > 4 then
                player.frame = 4
            end
        elseif player.animation == IDLE then
            if player.frame < 1 or player.frame > 0 then
                player.frame = 1
            end
        end
    end
end



function UpdatePlayer(player, dt, world,level)
    function love.wheelmoved(x,y)
        if y > 0 then
            player.mode = "balalaika"
        end
        if y < 0 then
            player.mode ="donut"
        end
    end 

 
    local playervelocity = vector2.new(player.body:getLinearVelocity())

    if love.keyboard.isDown("d") and player.collisionnormal.x ~= 1 then
        player.body:setLinearVelocity(300, playervelocity.y)
       if not love.mouse.isDown(1) then 
            player.direction = 1
        end
        if player.onground and not player.jumped then 
            AnimatePlayer(player, RUN, dt)
            love.audio.play(player.steps)
        else
            AnimatePlayer(player, JUMP, dt)
            love.audio.stop(player.steps)
        end
    elseif love.keyboard.isDown("a") and player.collisionnormal.x ~= -1 then
        if not love.mouse.isDown(1) then 
           player.direction = -1
        end
        player.body:setLinearVelocity(-300, playervelocity.y)
        if player.onground and not player.jumped then 
            
            AnimatePlayer(player, RUN, dt)
            love.audio.play(player.steps)
        else
            AnimatePlayer(player, JUMP, dt)
            love.audio.stop(player.steps)
        end
    else
        player.body:setLinearVelocity(0, playervelocity.y)
        AnimatePlayer(player, IDLE, dt)
        love.audio.stop(player.steps)
    end

    if love.keyboard.isDown("w") and player.onstairs then 
        player.body:setLinearVelocity(playervelocity.x, -200)
    end

    if love.keyboard.isDown("r") then 
        player.body:setLinearVelocity(playervelocity.x, -300)
    end
    if love.keyboard.isDown("e") then 
        player.body:setLinearVelocity(700, playervelocity.y)
    end

    if love.keyboard.isDown("space") and player.jumped == false and player.onground == true and not player.onstairs then
        local jumpForce = vector2.new(0, -1200)
        player.body:applyLinearImpulse(jumpForce.x, jumpForce.y)
        AnimatePlayer(player, JUMP, dt)
        player.jumped = true
        player.onground = false
    end
   


    player.shoottimer = player.shoottimer + dt
    if  player.mode == "balalaika" and love.mouse.isDown(1) and player.shoottimer > 0.2 and player.BalalaikaCapacity > 0 and not player.onstairs  then
        player.shoottimer = 0
        if love.mouse.getX() >= 380 then 
            player.direction = 1
        else 
             player.direction = -1
        end 

        local playerposition = vector2.new(player.body:getPosition())
        local mouseposition = vector2.new(love.mouse.getX()+(playerposition.x - 380), love.mouse.getY()+648)        
        player.BalalaikaCapacity = player.BalalaikaCapacity - 1
        local direction = vector2.normalize(vector2.sub(mouseposition, playerposition))
        local bulletposition = vector2.add(playerposition, vector2.mult(direction, 1))
        table.insert(player.bullets, CreateBullet(world, bulletposition.x, bulletposition.y-2, direction))
        love.audio.play(player.balalaika)
        con = false
    end
    UpdateBullets(player.bullets, dt)

    if  player.mode == "balalaika" and  love.mouse.isDown(1) and player.BalalaikaCapacity <= 0  then
        love.audio.play(player.netsrun)
        con = false
    end
 
    if  player.mode == "donut" and love.mouse.isDown(1) and player.shoottimer > 0.8 and not player.onstairs then
        player.shoottimer = 0
        if love.mouse.getX() >= 380 then 
            player.direction = 1
        else 
             player.direction = -1
        end 
        love.audio.play(player.flap)
        local playerposition = vector2.new(player.body:getPosition())
        local mouseposition = vector2.new(love.mouse.getX()+(playerposition.x - 380), love.mouse.getY()+648)         
        local direction = vector2.normalize(vector2.sub(mouseposition, playerposition))
        local donutposition = vector2.add(playerposition, vector2.mult(direction, 1))
        table.insert(player.donuts, CreateDonut(world, donutposition.x, donutposition.y-2, direction))
        con = false
    end
    UpdateDonuts(player.donuts, dt)

   

    local contacts = player.body:getContacts()
    if #contacts == 0 then
        player.onground = false
    
        player.collisionnormal = vector2.new(0, 0) 
    else
        for i = 1, #contacts, 1 do            
            local fixtureA, fixtureB = contacts[i]:getFixtures()
            local categoryA = fixtureA:getCategory()
            local categoryB = fixtureB:getCategory()
            if (categoryA == 1 and categoryB == 2) then 
                local normal = vector2.new(contacts[i]:getNormal())
                if vector2.magnitude(normal) == 1 then
                    if normal.y == 1 then
                        player.onground = true
                   
                    end                 
                    player.collisionnormal = vector2.new(normal.x, normal.y)
                end
            elseif (categoryA == 2 and categoryB == 1) then
                local normal = vector2.new(contacts[i]:getNormal())
                if vector2.magnitude(normal) == 1 then
                    if normal.y == -1 then
                        player.onground = true
                     
                    end
                    player.collisionnormal = vector2.new(-normal.x, -normal.y) 
                end
            end     
        end
    end
    
end


function BeginContactPlayer(fixtureA, fixtureB, contact, player,baba)

    

    if (fixtureA:getUserData().tag == "player" and 
       fixtureB:getUserData().tag == "ammo") or 
       (fixtureA:getUserData().tag == "ammo" and 
       fixtureB:getUserData().tag == "player") then
        local normal = vector2.new(contact:getNormal())
        if normal.y == 1 then
            player.onground = true
        end
        player.collisionnormal = normal
    end

    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "stairs") or 
    (fixtureA:getUserData().tag == "stairs" and 
    fixtureB:getUserData().tag == "player") then
   
       player.onstairs = true
   
 end

 if gorinichdied and babadied then 
    
    if (fixtureA:getUserData().tag == "player" and 
       fixtureB:getUserData().tag == "endlevel") or 
       (fixtureA:getUserData().tag == "endlevel" and 
       fixtureB:getUserData().tag == "player") then
        player.completedlevel = true
        player.body:setLinearVelocity(0, 0)
    end
    
end

    if (fixtureA:getUserData().tag == "player" 
    and fixtureB:getUserData().tag == "deth1") 
    or (fixtureA:getUserData().tag == "deth1" 
    and fixtureB:getUserData().tag == "player") then
        love.audio.setVolume(0.6)
        love.audio.play(player.scream)
    end

    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "deth2") 
    or (fixtureA:getUserData().tag == "deth2" 
    and fixtureB:getUserData().tag == "player") then
        love.audio.stop(player.scream)
        love.audio.play(player.fall)
        h = 0
    end

    if (fixtureA:getUserData().tag == "player" 
    and fixtureB:getUserData().tag == "deth3") 
    or (fixtureA:getUserData().tag == "deth3" 
    and fixtureB:getUserData().tag == "player") then
        love.audio.stop(player.fall)
    end

    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "attack") or 
    (fixtureA:getUserData().tag == "attack" and 
    fixtureB:getUserData().tag == "player") then
        h = h-1
        love.audio.play(player.sound)
    end

    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "bullet") or 
    (fixtureA:getUserData().tag == "bullet" and 
    fixtureB:getUserData().tag == "player") then
        if con  then 
            h = h-1
            love.audio.play(player.sound)
        end 
    end

    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "donut") or 
    (fixtureA:getUserData().tag == "donut" and 
    fixtureB:getUserData().tag == "player") then
        if con  then 
            h = h-1
            love.audio.play(player.sound)
        end 
    end

    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "Gorinichattack") or 
    (fixtureA:getUserData().tag == "Gorinichattack" and 
    fixtureB:getUserData().tag == "player") then
        h = h-1
        love.audio.play(player.sound)
    end

    
    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "gorinich") or 
    (fixtureA:getUserData().tag == "gorinich" and 
    fixtureB:getUserData().tag == "player") then
        h = h - 2
        love.audio.play(player.sound)
    end
    
    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "babaattack") or 
    (fixtureA:getUserData().tag == "babaattack" and 
    fixtureB:getUserData().tag == "player") then
        h = h-1
        love.audio.play(player.sound)
    end

end

function KeyReleasedPlayer(key, player)
    if key == "space" then
        player.jumped = false
        player.onground = false
    end
end

function DrawPlayer(player)
    local playerposition = vector2.new(player.body:getPosition())
    local offset = 0    
    if player.direction == -1 then
        offset = 68
    end
    love.graphics.draw(player.spritesheet, player.quads[player.frame],  playerposition.x-34 + offset, playerposition.y-48 , 0, player.direction*3,3)

    DrawBullets(player.bullets)
    DrawDonuts(player.donuts)
end

function DrawScreenDeath()
    if h < 1 and not paused then 
        love.graphics.setColor(0, 0, 0,0.6)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
        xh=-200
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("GAME OVER", bigfont, love.graphics.getWidth()/3, love.graphics.getHeight()/2,0,1.4)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("press 'Space' to restart", smallfont, love.graphics.getWidth()/2.6, love.graphics.getHeight()/1.7,0,0.5)
        love.graphics.print("press 'Esc' to exit", smallfont, love.graphics.getWidth()/2.4, love.graphics.getHeight()/1.6,0,0.5)
    end
end

function PauseScreen()
    if paused then  
        love.graphics.setColor(0, 0, 0,0.6)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("PAUSED", bigfont, love.graphics.getWidth()/2.6, love.graphics.getHeight()/2,0,1.4)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("press 'Esc' to continue", smallfont, love.graphics.getWidth()/2.6, love.graphics.getHeight()/1.7,0,0.5)
        love.graphics.print("press 'Space' to exit", smallfont, love.graphics.getWidth()/2.5, love.graphics.getHeight()/1.6,0,0.5)
    end
end