require "player"
require "attack"
local IDLE,RUN,ATTACK = 1, 2, 3
function CreateEnemy(world, x, y)
    local enemy = {}
    enemy.body = love.physics.newBody(world, x, y, "dynamic")
    enemy.shape = love.physics.newRectangleShape(23, 41)
    enemy.body:setFixedRotation(true)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 1)
    enemy.tag = "enemy"
    enemy.fixture:setUserData(enemy)

    enemy.collisionnormal = vector2.new(0, 0)
    enemy.direction = 1
    enemy.lives = 10
    enemy.shoottimer = 0
    enemy.attacks = {}
    enemy.spritesheet = love.graphics.newImage("assets/goblin.png")
    enemy.quads = CreateSpriteSheetQuads(enemy.spritesheet,3, 4)
    enemy.frame = 1
    enemy.animation = IDLE
    enemy.frametimer = 0
    enemy.framerate = 0.16
    enemy.direction = 1
    enemy.speed = 292
    enemy.sound = love.audio.newSource("MusicAndSounds/goblin.mp3","static")
    return enemy
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

function AnimateEnemy(enemies, animation, dt)
    for i = 1 , #enemies ,1 do 
    if enemies[i].animation ~= animation then
        enemies[i].animation = animation
        enemies[i].frametimer = 1
    end
    enemies[i].frametimer =  enemies[i].frametimer + dt
    if  enemies[i].frametimer >  enemies[i].framerate then
        enemies[i].frametimer = 0     
        enemies[i].frame =  enemies[i].frame + 1   
        if  enemies[i].animation == RUN then            
            if  enemies[i].frame < 4 or  enemies[i].frame > 1  then
                enemies[i].frame = 2
            end
        elseif enemies[i].animation == ATTACK  then
            if enemies[i].frame < 7 or enemies[i].frame > 10  then
                enemies[i].frame = 8
            end
        elseif  enemies[i].animation == IDLE then
            if  enemies[i].frame < 1 or  enemies[i].frame > 0 then
                enemies[i].frame = 1
            end
        end
    end
end 
end

function FindEnemyIndex(enemies, enemy)
    for i = 1, #enemies, 1 do
        if enemies[i].fixture == enemy.fixture then
            return i
        end
    end
    return -1
end

function UpdateEnemies(world,player,enemies, dt)



    for i = 1, #enemies, 1 do

        if player.body:getX() - enemies[i].body:getX()>=40 or  player.body:getX() - enemies[i].body:getX()<= - 40  then 
            enemies[i].speed = 292
        else
            enemies[i].speed = 0 
        end 

        if player.body:getX()  - enemies[i].body:getX() >= 0 and  player.body:getX()  - enemies[i].body:getX() <= 500  or player.body:getX()  - enemies[i].body:getX() <= -1 and player.body:getX()  - enemies[i].body:getX() >= - 500  then
            if player.body:getX()  >=  enemies[i].body:getX() then
                enemies[i].direction =  1
            else
                enemies[i].direction =  -1
            end
            local enemyvelocity = vector2.new(enemies[i].body:getLinearVelocity())
            enemies[i].body:setLinearVelocity(enemies[i].speed *enemies[i].direction, enemyvelocity.y)
            AnimateEnemy(enemies, RUN, dt)
        else
            AnimateEnemy(enemies, IDLE, dt)
        end


        enemies[i].shoottimer = enemies[i].shoottimer + dt

       if player.body:getX() - enemies[i].body:getX() > 0 and  player.body:getX() - enemies[i].body:getX() < 100 and  player.body:getY() - enemies[i].body:getY() > -20 and  enemies[i].shoottimer > 0.6 then
            enemies[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local enemyposition = vector2.new(enemies[i].body:getX(),enemies[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(enemyposition, playerposition))
            local attackposition = vector2.add(enemyposition, vector2.mult(direction, -5))
            AnimateEnemy(enemies, ATTACK, dt)
            table.insert(enemies[i].attacks, CreateAttack(world, attackposition.x+20, attackposition.y-7, direction))
            
        end

       if  enemies[i].body:getX() - player.body:getX() > 0 and enemies[i].body:getX() - player.body:getX()  < 100 and player.body:getY() - enemies[i].body:getY() > -20 and   enemies[i].shoottimer > 0.6 then
            enemies[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local enemyposition = vector2.new(enemies[i].body:getX(),enemies[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(enemyposition, playerposition))
            local attackposition = vector2.add(enemyposition, vector2.mult(direction, -5))
            AnimateEnemy(enemies, ATTACK, dt)
            table.insert(enemies[i].attacks, CreateAttack(world, attackposition.x - 20, attackposition.y-7, direction))
            
        end


        if player.body:getY() - enemies[i].body:getY() < 0 and player.body:getY() - enemies[i].body:getY() > - 200 and player.body:getX() - enemies[i].body:getX() >= -30 and  player.body:getX() - enemies[i].body:getX()  < 30 and enemies[i].shoottimer > 0.6 then
            enemies[i].shoottimer = 0
            local playerposition = vector2.new(player.body:getPosition())
            local enemyposition = vector2.new(enemies[i].body:getX(),enemies[i].body:getY())        
            local direction = vector2.normalize(vector2.sub(enemyposition, playerposition))
            local attackposition = vector2.add(enemyposition, vector2.mult(direction, -5))
            AnimateEnemy(enemies, ATTACK, dt)
            table.insert(enemies[i].attacks, CreateAttack(world, attackposition.x, attackposition.y-25, direction))
        end
        UpdateAttacks(enemies[i].attacks, dt)
    
    end
end




function BeginContactEnemy(fixtureA, fixtureB, contact,enemies)
      


    local enemy
    if (fixtureA:getUserData().tag == "enemy" and fixtureB:getUserData().tag == "bullet") then
        enemy = fixtureA:getUserData()
        enemy.lives = enemy.lives - 3.5
    
    elseif (fixtureA:getUserData().tag == "bullet" and fixtureB:getUserData().tag == "enemy") then
        enemy = fixtureB:getUserData()
    
    end      

    if (fixtureA:getUserData().tag == "enemy" and fixtureB:getUserData().tag == "donut") then
        enemy = fixtureA:getUserData()
        enemy.lives = enemy.lives - 2
  
    elseif (fixtureA:getUserData().tag == "donut" and fixtureB:getUserData().tag == "enemy") then
        enemy = fixtureB:getUserData()
        enemy.lives = enemy.lives - 2
    
    end     
 
    
    if (fixtureA:getUserData().tag == "enemy" and fixtureB:getUserData().tag == "deth1") then
        enemy = fixtureA:getUserData()
   
       
    elseif (fixtureA:getUserData().tag == "deth1" and fixtureB:getUserData().tag == "enemy") then
        enemy = fixtureB:getUserData()
    end
    if enemy and enemy.lives <= 0  then
        love.audio.play(enemy.sound)
        enemy.body:destroy()
        enemy.shape:release()
        enemy.fixture:destroy() 
        local indextoremove = FindEnemyIndex(enemies, enemy)
        if indextoremove ~= -1 then
            table.remove(enemies, indextoremove)
        end
    end
end


function DrawEnemies(enemies)
    for i = 1, #enemies, 1 do
        local enemyposition = vector2.new(enemies[i].body:getPosition())
        local offset = 0    
        if enemies[i].direction == -1 then
            offset = 82
        end
        love.graphics.draw(enemies[i].spritesheet,enemies[i].quads[enemies[i].frame],  enemyposition.x-42 + offset, enemyposition.y-53 , 0, enemies[i].direction*2.5,2.5)


        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,40,10)

        love.graphics.setColor(0, 1, 0)
        if enemies[i].lives == 10 then 
            love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,40,10)
        end
        if enemies[i].lives >= 7 and enemies[i].lives < 10  then 
            love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,32,10)
        end
        if enemies[i].lives >= 5 and enemies[i].lives < 7  then 
            love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,24,10)
        end
        if enemies[i].lives >= 3 and enemies[i].lives < 5  then 
            love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,16,10)
        end
        if enemies[i].lives >= 1 and enemies[i].lives < 3  then 
            love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,8,10)
        end

        if enemies[i].lives > 0 and enemies[i].lives < 1  then 
            love.graphics.rectangle("fill",enemies[i].body:getX()-18,enemies[i].body:getY()-47,3,10)
        end

        love.graphics.setColor(1, 1, 1)
    end
end