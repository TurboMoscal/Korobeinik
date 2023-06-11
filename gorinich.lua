require "player"
require "GorinichAttack"
local IDLE = 1
function CreateGorinich(world, x, y)
    local gorinich = {}
    gorinich.body = love.physics.newBody(world, x, y, "dynamic")
    gorinich.shape = love.physics.newRectangleShape(68, 70)
    gorinich.fixture = love.physics.newFixture(gorinich.body, gorinich.shape, 1)
    gorinich.tag = "gorinich"
    gorinich.fixture:setUserData(gorinich)
    gorinich.body:setFixedRotation(true)
    gorinich.collisionnormal = vector2.new(0, 0)
    gorinich.direction = 1
    gorinich.lives = 19
    gorinich.shoottimer = 0
    gorinich.Gorinichattacks = {}
    gorinich.spritesheet = love.graphics.newImage("assets/dragon.png")
    gorinich.quads = CreateSpriteSheetQuads(gorinich.spritesheet,2,1)
    gorinich.frame = 1
    gorinich.animation = IDLE
    gorinich.frametimer = 0
    gorinich.framerate = 0.16
    gorinich.direction = 1
    gorinich.speed = 105
    gorinich.sound = love.audio.newSource("MusicAndSounds/dragon.mp3","static")
    return gorinich
end

function FindGorinichIndex(goriniches, gorinich)
    for i = 1, #goriniches, 1 do
        if goriniches[i].fixture == gorinich.fixture then
            return i
        end
    end
    return -1
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

function AnimateGorinich(goriniches, animation, dt)
    for i = 1 , #goriniches ,1 do 
    if goriniches[i].animation ~= animation then
        goriniches[i].animation = animation
        goriniches[i].frametimer = 1
    end
    goriniches[i].frametimer =  goriniches[i].frametimer + dt
    if goriniches[i].frametimer >  goriniches[i].framerate then
        goriniches[i].frametimer = 0     
        goriniches[i].frame =  goriniches[i].frame + 1   
        if  goriniches[i].animation == IDLE then            
            if  goriniches[i].frame < 1 or  goriniches[i].frame > 2 then
                goriniches[i].frame = 1
            end
        end
    end
end 
end

function UpdateGoriniches(world,player,goriniches, dt)
    for i = 1, #goriniches, 1 do



        if player.body:getX() - goriniches[i].body:getX()>= 50 or  player.body:getX() - goriniches[i].body:getX()<= - 50  then 
            goriniches[i].speed = 105
        else
            goriniches[i].speed = 0 
        end 


    

        if player.body:getX()  - goriniches[i].body:getX() >= 0 and  player.body:getX()  - goriniches[i].body:getX() <= 800  or player.body:getX()  - goriniches[i].body:getX() <= -1 and player.body:getX()  - goriniches[i].body:getX() >= - 800  then

            if player.body:getX()  >=  goriniches[i].body:getX() then
                goriniches[i].direction =  1
            else
                goriniches[i].direction =  -1
            end
            local gorinichvelocity = vector2.new(goriniches[i].body:getLinearVelocity())
            goriniches[i].body:setLinearVelocity( goriniches[i].speed *goriniches[i].direction, gorinichvelocity.y)
            AnimateGorinich(goriniches, IDLE, dt)


            if goriniches[i].body:getY() > 1020 then
                goriniches[i].body:applyLinearImpulse(0,-220)
            end
        end

        goriniches[i].shoottimer = goriniches[i].shoottimer + dt

       if player.body:getX() - goriniches[i].body:getX() > 0 and  player.body:getX() - goriniches[i].body:getX() < 800 and  goriniches[i].shoottimer > 1.6 then
            goriniches[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local gorinichposition = vector2.new(goriniches[i].body:getX(),goriniches[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(gorinichposition, playerposition))
            local attackposition = vector2.add(gorinichposition, vector2.mult(direction, -1))
            table.insert(goriniches[i].Gorinichattacks, CreateGorinichAttack(world, attackposition.x, attackposition.y+10, direction))
            table.insert(goriniches[i].Gorinichattacks, CreateGorinichAttack(world, attackposition.x+65, attackposition.y+10, direction))
            
        end

       if  goriniches[i].body:getX() - player.body:getX() > 0 and goriniches[i].body:getX() - player.body:getX()  < 800 and goriniches[i].shoottimer >1.6 then
            goriniches[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local gorinichposition = vector2.new(goriniches[i].body:getX(),goriniches[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(gorinichposition, playerposition))
            local attackposition = vector2.add(gorinichposition, vector2.mult(direction, -1))
            table.insert(goriniches[i].Gorinichattacks, CreateGorinichAttack(world, attackposition.x-65, attackposition.y+10, direction))
            table.insert(goriniches[i].Gorinichattacks, CreateGorinichAttack(world, attackposition.x, attackposition.y+10, direction))
           
        end



        UpdateGorinichAttack(goriniches[i].Gorinichattacks, dt)
    
    end
end




function BeginContactGorinich(fixtureA, fixtureB, contact,goriniches)
 

    local gorinich
    if (fixtureA:getUserData().tag == "gorinich" and fixtureB:getUserData().tag == "bullet") then
        gorinich = fixtureA:getUserData()
        gorinich.lives = gorinich.lives - 3.5
        
    elseif (fixtureA:getUserData().tag == "bullet" and fixtureB:getUserData().tag == "gorinich") then
        gorinich = fixtureB:getUserData()
        gorinich.lives = gorinich.lives - 3.5
        
    end      
    if (fixtureA:getUserData().tag == "gorinich" and fixtureB:getUserData().tag == "donut") then
        gorinich = fixtureA:getUserData()
        gorinich.lives = gorinich.lives - 2
        
    elseif (fixtureA:getUserData().tag == "donut" and fixtureB:getUserData().tag == "gorinich") then
        gorinich = fixtureB:getUserData()
        gorinich.lives = gorinich.lives - 2
        
    end 
    if (fixtureA:getUserData().tag == "gorinich" and fixtureB:getUserData().tag == "deth1") then
        gorinich = fixtureA:getUserData()
     
    elseif (fixtureA:getUserData().tag == "deth1" and fixtureB:getUserData().tag == "gorinich") then
        gorinich = fixtureB:getUserData()
        
    end
      
    if gorinich and gorinich.lives <= 0  then
        love.audio.play(gorinich.sound)
        gorinichdied = true
        gorinich.body:destroy()
        gorinich.shape:release()
        gorinich.fixture:destroy() 
        local indextoremove = FindGorinichIndex(goriniches, gorinich)
        if indextoremove ~= -1 then
            table.remove(goriniches, indextoremove)
        end
    end  
    
end


function DrawGoriniches(goriniches)
    for i = 1, #goriniches, 1 do
        
        local gorinichposition = vector2.new(goriniches[i].body:getPosition())
        local offset = 0    
        if goriniches[i].direction == -1 then
            offset = 278
        end
        love.graphics.draw(goriniches[i].spritesheet,goriniches[i].quads[goriniches[i].frame],  gorinichposition.x - 140 + offset, gorinichposition.y-120 , 0, goriniches[i].direction*2,2)

        DrawGorinichAttack(goriniches[i].Gorinichattacks)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY() - 139,60,30)

        love.graphics.setColor(0, 1, 0)
        if goriniches[i].lives == 19 then 
            love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY()-139,60,30)
        end
        if goriniches[i].lives >= 16 and goriniches[i].lives < 19  then 
            love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY()-139,50,30)
        end
        if goriniches[i].lives >= 12 and goriniches[i].lives < 16  then 
            love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY()-139,40,30)
        end
        if goriniches[i].lives >=8 and goriniches[i].lives < 12  then 
            love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY()-139,30,30)
        end
        if goriniches[i].lives >= 4 and goriniches[i].lives < 8  then 
            love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY()-139,20,30)
        end

        if goriniches[i].lives > 1 and goriniches[i].lives < 4  then 
            love.graphics.rectangle("fill",goriniches[i].body:getX()-20,goriniches[i].body:getY()-139,10,30)
        end

        love.graphics.setColor(1, 1, 1)
    end
end