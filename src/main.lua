
love.filesystem.load("board.lua")()
love.filesystem.load("worm.lua")()
love.filesystem.load("food.lua")()

local scale = .5

local b
local w
local f

local gameOverFont, pointsFont

local function getNewFoodPosition(w)
  local fx, fy
  local ok = false
  local list = w:getAllPositions()
  while not ok do
    ok = true
    fx = love.math.random(1,b.width)
    fy = love.math.random(1,b.height)
    for _, v in pairs(list) do
      if fx == v.x and fy == v.y then
        ok = false
        break
      end 
    end
  end
  
  return fx, fy
end

function love.load()

  print("Hello worm!")
  
  b = board:new()
  b.width = 30
  b.height = 20
  
  pointsFont = love.graphics.newFont(20)
  
  gameOverFont = love.graphics.newFont(50)
  
  love.window.setMode(b:getPixelWidth()*scale,b:getPixelHeight()*scale + pointsFont:getHeight() * 2)
  
  w = worm:new(nil,b.width,b.height,1,1,10)
  
  f = food:new(nil, getNewFoodPosition(w))
end

local gameOver = false

function love.update(dt)
--  print("update. dt = " .. dt)

  if gameOver then
    return
  end
  
  w:update(dt, f)
  
  if f:isKilled() then
    local fx, fy = getNewFoodPosition(w)
    f:respawn(fx, fy)
  end
  
  if not w:isAlive() then
    print("Game over!")
    gameOver = true
  end
end

function love.draw()
--	print("draw")
  
  b:draw(scale)
  w:draw(scale)
  f:draw(scale)
  
  love.graphics.setFont(pointsFont)
  love.graphics.print("Points: " .. w:getPoints(), 0, love.window:getHeight() - pointsFont:getHeight() * 1.5)
  
  if gameOver then
    love.graphics.setFont(gameOverFont)
    love.graphics.printf("Game over!",0, (love.window.getHeight() - gameOverFont:getHeight()) / 2, love.window.getWidth(),"center")
  end
end
