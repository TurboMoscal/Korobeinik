
require "config"
require "vector2"
require "player"
require "EventArea"
require "enemy"
require"gorinich"
require"BabaYaga"
require "bullet"
require "donut"
require "hood"
require "EventArea"
require "enemy"
require "amonite"
require "menu"
require "menu2"
require "AmmoBox"
require "stairs"



local world
local player


local babas
local enemies
local goriniches

local amonites
local ammo1 
local background 
local cursor
local ammodes
local amonides
local stairs1
local phone 
local menumusic
local levelmusic
local sti
local map

function love.load()
    paused = false 
    phone = love.graphics.newImage("assets/KorobeinikMenu1.png")
    mediumfont = love.graphics.newFont("assets/PS.ttf",40)
    smallfont = love.graphics.newFont("assets/PS.ttf", 35)
    bigfont = love.graphics.newFont("assets/PS.ttf",50)
    buttonsound = love.audio.newSource("MusicAndSounds/zvuk11.mp3","stream")
    menumusic = love.audio.newSource("MusicAndSounds/menumusic1.mp3","stream")
    levelmusic = love.audio.newSource("MusicAndSounds/levelmusic.mp3","stream")
    hoodload()
    background = love.graphics.newImage("assets/swamp.png")
    


    cursor = love.mouse.newCursor("assets/cross.png",10,10)
    world = love.physics.newWorld(0, 1600, true) 
    world:setCallbacks(BeginContact, EndContact, nil, nil)
    sti = require "sti"
    map = sti("assets/map.lua",{"box2d"})
    map:box2d_init(world)

    player = CreatePlayer(world, 200, 1500) 
    
 
 
    stairs1={}
    stairs1[1] = CreateStairs(world, 1936, 1510, 10, 250)
    stairs1[2] = CreateStairs(world, 7345, 1610, 10, 255)
    stairs1[3] = CreateStairs(world, 9359, 1259, 10, 202)
    stairs1[4] = CreateStairs(world,10288, 1478, 10, 252)
    stairs1[5] = CreateStairs(world,10096, 1571, 10, 131)
    stairs1[6] = CreateStairs(world,11888, 1222, 10, 440)
    stairs1[7] = CreateStairs(world,12368, 1478, 10, 180)
    stairs1[8] = CreateStairs(world,4046, 1426, 10,275)
    stairs1[9] = CreateStairs(world,4590, 1396, 10,157)
    stairs1[10] = CreateStairs(world, 8785, 999, 10, 251)
    stairs1[11] = CreateStairs(world,14514, 1525, 10,287)

    enemies = {}
    enemies[1] = CreateEnemy(world, 590,1350)     
    enemies[2] = CreateEnemy(world, 2270, 500)
    enemies[3] = CreateEnemy(world, 3970, 150)
    enemies[4] = CreateEnemy(world, 5960, 500)
    enemies[5] = CreateEnemy(world, 7590, 500)
    enemies[6] = CreateEnemy(world, 12316, 200)


    goriniches = {}
    goriniches[1] = CreateGorinich(world,10146, 1100)


    babas = {}
    babas[1] = CreateBaba(world, 15090, 500)  


    local DethArea1 = CreateEventArea(world, 0, love.graphics:getHeight()+1548, 40000, 1670, "deth1")
    local DethArea2 = CreateEventArea(world, 0,love.graphics:getHeight()+2448, 40000, 2100, "deth2")
    local DethArea3 = CreateEventArea(world, 0, love.graphics:getHeight()+4248, 40000, 1100, "deth3")
    local endlevelarea = CreateEventArea(world, 16400, 1000, 1300, 1300, "endlevel")


    amonites = {}
    amonites[1] = CreateAmonite(world,1760,1630) 
    amonites[2] = CreateAmonite(world,7278,1693) 
    amonites[3] = CreateAmonite(world, 8985, 861)
    amonites[4] = CreateAmonite(world, 9955, 1631)
    amonites[5] = CreateAmonite(world, 12120, 1348)
    amonites[6] = CreateAmonite(world, 14320, 1634)

    amonides = {}
    amonides[1] = CreateDesAmonite(world,1755,1662) 
    amonides[2] = CreateDesAmonite(world,7273,1726) 
    amonides[3] = CreateDesAmonite(world,8980, 894) 
    amonides[4] = CreateDesAmonite(world,9952, 1662) 
    amonides[5] = CreateDesAmonite(world, 12120, 1380)
    amonides[6] = CreateDesAmonite(world, 14320, 1666)

    ammo1 = {}
    ammo1[1]=CreateAmmo(world ,3710,1247)
    ammo1[2]=CreateAmmo(world ,9230, 1120)
    ammo1[3]=CreateAmmo(world , 12470, 1348)
    ammo1[4]=CreateAmmo(world , 13130, 1568)


    ammodes = {}
    ammodes[1] = CreateDesAmmo(world,3710,1286)
    ammodes[2] = CreateDesAmmo(world,9230,1159)
    ammodes[3] = CreateDesAmmo(world , 12470, 1387)
    ammodes[4] = CreateDesAmmo(world , 13130, 1607)

    gamestate = "menu2"
    ButtonSpawn2(love.graphics.getWidth()/2.3-30,love.graphics.getHeight()*0.4,"Restart","restart")
    ButtonSpawn2(love.graphics.getWidth()/2.3-60,love.graphics.getHeight()*0.6,"Continue","continue")
    ButtonSpawn2(love.graphics.getWidth()/2.3,love.graphics.getHeight()*0.8,"Exit","quit")

    gamestate = "menu"
    ButtonSpawn(love.graphics.getWidth()/2.3,love.graphics.getHeight()*0.4,"Play","play")
    ButtonSpawn(love.graphics.getWidth()/2.3,love.graphics.getHeight()*0.6,"Exit","quit")


end


function BeginContact(fixtureA, fixtureB, contact)
    BeginContactPlayer(fixtureA, fixtureB, contact, player,player.bullets)
    BeginContactEnemy(fixtureA, fixtureB, contact,enemies)
    BeginContactGorinich(fixtureA, fixtureB, contact,goriniches)
    BeginContactBaba(fixtureA, fixtureB, contact,babas,player )
    BeginContactBullet(fixtureA, fixtureB, contact, player.bullets)
    BeginContactDonut(fixtureA, fixtureB, contact, player.donuts)
    BeginContactAmonite(fixtureA, fixtureB, contact, amonites)
    BeginContactAmmo(fixtureA, fixtureB, contact, ammo1,player)
    for i = 1 , #enemies,1 do 
        BeginContactAttack(fixtureA, fixtureB, contact, enemies[i].attacks)
    end
    for i = 1 , #goriniches,1 do
        BeginContactGorinichAttack(fixtureA, fixtureB, contact, goriniches[i].Gorinichattacks)
    end
    for i = 1 , #babas,1 do
        BeginContactBabaAttack(fixtureA, fixtureB, contact, babas[i].babaattacks)
    end
end

function EndContact(fixtureA, fixtureB, contact)
   
    if (fixtureA:getUserData().tag == "player" and 
    fixtureB:getUserData().tag == "stairs") or 
    (fixtureA:getUserData().tag == "stairs" and 
    fixtureB:getUserData().tag == "player") then
    player.onstairs = false
    player.collisionnormal = vector2.new(0, 0)
    end
end

function love.keyreleased(key)
    KeyReleasedPlayer(key, player)
    if key == "escape" and not paused and h > 0 and gamestate == "playing"  then 
        paused = true
   
    elseif key == "escape" and paused then 
        paused = false
    end 
end



function love.update(dt)

    math.randomseed(os.time())

   mousex = love.mouse:getX()
   mousey = love.mouse:getY()

    if gamestate == "menu" then 
        ButtonChek()
    end
    if gamestate == "menu2" then 
        ButtonChek2()
    end
    if paused and love.keyboard.isDown("space") then 
        gamestate = "menu2"
        paused = false
    end

    if gamestate == "playing" and not paused  then 
        love.audio.pause(menumusic)
        if love.keyboard.isDown("space") and h < 1 then 
            love.event.quit("restart")
        end
    
        if player.completedlevel == false and h > 0  then
            UpdatePlayer(player, dt, world)
            UpdateEnemies(world,player,enemies, dt)
            UpdateGoriniches(world,player,goriniches, dt)
            UpdateBabas(world,player,babas, dt)
            world:update(dt)
            map:update(dt)
        end
    end

    if h < 1 and love.keyboard.isDown("escape") then 
        gamestate = "menu2"
    end
    love.mouse.setCursor(cursor)
   
end


function love.draw()
    
    if gamestate == "playing" or gamestate == "restart" then 
        
        love.audio.play(levelmusic)
        local playerposition = vector2.new(player.body:getPosition())

        love.graphics.push()
        love.graphics.draw(background,0,0,0,love.graphics.getWidth()/1200)
        map:draw(-playerposition.x + 380, -648)
        love.graphics.translate(-playerposition.x + 380,-648)
        DrawDesAmonite(amonides) 
        DrawDesAmmo(ammodes)
        DrawPlayer(player)
        DrawAmonite(amonites)
        DrawGoriniches(goriniches)
        DrawEnemies(enemies)
        DrawBaba(babas)
        DrawAmmo(ammo1)
        love.graphics.pop() 
        love.graphics.setColor(1,1,1)

        if player.completedlevel == true then
            love.graphics.print("LEVEL COMPLETED!", bigfont,620, 450)
        end

        DrawScreenDeath()
        hooddraw(player) 
  
        if paused then 
            PauseScreen()
        end
    end

    if gamestate == "menu" then 
        love.audio.pause(levelmusic)
        love.audio.play(menumusic)
        love.graphics.draw(phone,0,0,0,love.graphics.getWidth()/1200)
        ButtonDraw()
    end 

    if gamestate == "menu2" then 
        love.audio.pause(player.fall)
        love.audio.pause(player.scream)
        love.audio.pause(levelmusic)
        love.audio.play(menumusic)
        love.graphics.draw(phone,0,0,0,love.graphics.getWidth()/1200)
        ButtonDraw2()
    end 
end

function love.mousepressed(x,y)
    if gamestate == "menu" then 
        ButtonClick(x,y)
    end
    if gamestate == "menu2" then 
        ButtonClick2(x,y)
    end
end 