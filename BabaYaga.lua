require "player"
require "BabaAttack"
local IDLE,RUN,ATTACK,HIGHTATTACK = 1, 2, 3,4
function CreateBaba(world, x, y)
    local baba = {}
    baba.body = love.physics.newBody(world, x, y, "dynamic")
    baba.shape = love.physics.newRectangleShape(30, 66)
    baba.fixture = love.physics.newFixture(baba.body, baba.shape, 1)
    baba.tag = "baba"
    baba.fixture:setUserData(baba)
    baba.body:setFixedRotation(true)
   
    baba.collisionnormal = vector2.new(0, 0)
    baba.damage = false
    baba.direction = 1
    baba.lives = 30
    baba.shoottimer = 0
    baba.damagetimer = 0
    baba.babaattacks = {}
    baba.spritesheet = love.graphics.newImage("assets/baba.png")
    baba.quads = CreateSpriteSheetQuads(baba.spritesheet,3, 5)
    baba.frame = 1
    baba.animation = IDLE
    baba.frametimer = 0
    baba.framerate = 0.18
    baba.direction = 1
    baba.speed = 190
    baba.sound = love.audio.newSource("MusicAndSounds/goblin.mp3","static")
    return baba
end

function CreateSpriteSheetQuads(spritesheet, cols, rows)
    local w = spritesheet:getWidth() / cols
    local h = spritesheet:getHeight() / rows
    local quads = {}
    local count = 1
    for j = 0, rows - 1, 1 do
        for i = 0, cols - 1, 1 do
            quads[count] = love.graphics.newQuad(i * w, j * h, w, h,  spritesheet:getWidth(), spritesheet:getHeight())
            count = count + 1
        end
    end
    return quads
end

function AnimateBaba(babas, animation, dt)
    for i = 1 , #babas ,1 do 
    if babas[i].animation ~= animation then
        babas[i].animation = animation
        babas[i].frametimer = 1
    end
    babas[i].frametimer =  babas[i].frametimer + dt
    if  babas[i].frametimer >  babas[i].framerate then
        babas[i].frametimer = 0     
        babas[i].frame =  babas[i].frame + 1   
        if  babas[i].animation == RUN then            
            if  babas[i].frame < 1 or  babas[i].frame > 3 then
                babas[i].frame = 2
            end
        elseif babas[i].animation == ATTACK  then
            if babas[i].frame < 10 or babas[i].frame > 12 then
                babas[i].frame = 10
            end
        elseif babas[i].animation == HIGHTATTACK  then
            if babas[i].frame < 15 or babas[i].frame > 13 then
                babas[i].frame = 13
            end
        elseif  babas[i].animation == IDLE then
            if  babas[i].frame < 1 or  babas[i].frame > 0 then
                babas[i].frame = 1
            end
        end
    end
end 
end


function FindBabaIndex(babas, baba)
    for i = 1, #babas, 1 do
        if babas[i].fixture == baba.fixture then
            return i
        end
    end
    return -1
end

function UpdateBabas(world,player,babas, dt)
    for i = 1, #babas, 1 do

        if player.body:getX() - babas[i].body:getX()>=40 or  player.body:getX() - babas[i].body:getX()<= - 40  then 
            babas[i].speed = 190
        else
            babas[i].speed = 0 
        end 

        if player.body:getX()  - babas[i].body:getX() >= 0 and  player.body:getX()  - babas[i].body:getX() <= 780  or player.body:getX()  - babas[i].body:getX() <= -1 and player.body:getX()  - babas[i].body:getX() >= - 780  then   
            
            if player.body:getX() >= babas[i].body:getX() then
                babas[i].direction =  1
            else
                babas[i].direction =  -1
            end

       
    
            local babavelocity = vector2.new(babas[i].body:getLinearVelocity())
            babas[i].body:setLinearVelocity(babas[i].speed * babas[i].direction, babavelocity.y)
            AnimateBaba(babas, RUN, dt)
        else
            AnimateBaba(babas, IDLE, dt)
        end
       
        babas[i].shoottimer = babas[i].shoottimer + dt


       if  player.body:getX() > babas[i].body:getX() then 
            playerxmore = true 
        else
            playerxmore = false
        end 
        io.write(player.body:getY() - babas[i].body:getY())
       if player.body:getX() -  babas[i].body:getX() > 0 and  player.body:getX() -  babas[i].body:getX() < 190 and  player.body:getY() -  babas[i].body:getY() > -20 and  babas[i].shoottimer > 0.64 then
            babas[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local gorinichposition = vector2.new(babas[i].body:getX(),babas[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(gorinichposition, playerposition))
            local attackposition = vector2.add(gorinichposition, vector2.mult(direction, -1))
            AnimateBaba(babas, ATTACK, dt)
            table.insert(babas[i].babaattacks, CreateBabaAttack(world, attackposition.x+42, attackposition.y+2, direction))
           
        end

       if  babas[i].body:getX() - player.body:getX() > 0 and babas[i].body:getX() - player.body:getX()  <190 and player.body:getY() - babas[i].body:getY() > -20 and  babas[i].shoottimer > 0.64 then
            babas[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local gorinichposition = vector2.new(babas[i].body:getX(),babas[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(gorinichposition, playerposition))
            local attackposition = vector2.add(gorinichposition, vector2.mult(direction, -1))
            AnimateBaba(babas, ATTACK, dt)
            table.insert(babas[i].babaattacks, CreateBabaAttack(world, attackposition.x-42, attackposition.y+2, direction))
          
        end



        if player.body:getY() - babas[i].body:getY() < 0 and player.body:getY() - babas[i].body:getY() > - 190 and player.body:getX() - babas[i].body:getX() >= -30 and  player.body:getX() - babas[i].body:getX()  < 30 and babas[i].shoottimer > 0.64 then
            babas[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local gorinichposition = vector2.new(babas[i].body:getX(),babas[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(gorinichposition, playerposition))
            local attackposition = vector2.add(gorinichposition, vector2.mult(direction, -1))
            AnimateBaba(babas, HIGHTATTACK, dt)
            table.insert(babas[i].babaattacks, CreateBabaAttack(world, attackposition.x, attackposition.y-20, direction))
        end


        UpdateBabaAttack(babas[i].babaattacks, dt)
    
    end
end




function BeginContactBaba(fixtureA, fixtureB, contact,babas,player )
      
    local baba
    if (fixtureA:getUserData().tag == "baba" and fixtureB:getUserData().tag == "bullet"  ) then
        baba = fixtureA:getUserData()
        
        if not con and  baba.shoottimer < 0.64  and player.onground then 
            baba.lives = baba.lives - 3.5
        end
      
       
    elseif (fixtureA:getUserData().tag == "bullet" and fixtureB:getUserData().tag == "baba" ) then
        baba = fixtureB:getUserData()
         
        if  not con and  baba.shoottimer < 0.64 and player.onground then 
            baba.lives = baba.lives - 3.5
        end
       
    end      
    if (fixtureA:getUserData().tag == "baba" and fixtureB:getUserData().tag == "donut" ) then
        baba = fixtureA:getUserData()
        if  not con and  baba.shoottimer < 0.64 and player.onground then 
            baba.lives = baba.lives - 2
        end
  
    elseif (fixtureA:getUserData().tag == "donut" and fixtureB:getUserData().tag == "baba" ) then
        baba = fixtureB:getUserData()
        if  not con and  baba.shoottimer < 0.64 and player.onground then 
            baba.lives = baba.lives - 2
        end
       
    end 
    if (fixtureA:getUserData().tag == "baba" and fixtureB:getUserData().tag == "deth1") then
        baba = fixtureA:getUserData()
    
        elseif (fixtureA:getUserData().tag == "deth1" and fixtureB:getUserData().tag == "baba") then
            baba = fixtureB:getUserData()
        end
        if baba and baba.lives <= 0 then
            love.audio.play(baba.sound)
            babadied = true
            baba.body:destroy()
            baba.shape:release()
            baba.fixture:destroy() 
            local indextoremove =  FindBabaIndex(babas, baba)
            if indextoremove ~= -1 then
                table.remove(babas, indextoremove)
            end
        end
    end




function DrawBaba(babas)
    for i = 1, #babas, 1 do
        
       
        local babaposition = vector2.new(babas[i].body:getPosition())
        local offset = 0    
        if babas[i].direction == -1 then
            offset = 92
        end
        love.graphics.draw(babas[i].spritesheet,babas[i].quads[babas[i].frame],  babaposition.x-48 + offset, babaposition.y-52 , 0, babas[i].direction*3,3)

       

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,60,20)

        love.graphics.setColor(0, 1, 0)
        if babas[i].lives == 30 then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,60,20)
        end
        if babas[i].lives >= 26 and babas[i].lives < 30  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,54,20)
        end
        if babas[i].lives >= 22 and babas[i].lives < 26  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,48,20)
        end
        if babas[i].lives >= 18 and babas[i].lives < 22  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,42,20)
        end
        if babas[i].lives >= 14 and babas[i].lives < 18  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,36,20)
        end
        if babas[i].lives >= 10 and babas[i].lives < 14  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,30,20)
        end
       
        if babas[i].lives >= 6 and babas[i].lives < 10  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,24,20)
        end

        if babas[i].lives >= 2 and babas[i].lives < 6  then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,18,20)
        end

        if babas[i].lives >= 1 and babas[i].lives <2 then 
            love.graphics.rectangle("fill",babas[i].body:getX()-30,babas[i].body:getY()-76,12,20)
        end


        love.graphics.setColor(1, 1, 1)
    end
end