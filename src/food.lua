
food = {x=0, y=0}

local foodTile = love.graphics.newImage( "img/food.png" )
local foodTileWidth = foodTile:getWidth()
local foodTileHeight = foodTile:getHeight()

function food:new(o, x, y)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.x = x
  o.y = y
  o.respawn_ = false
  return o
end

function food:setPosition(x, y)
  self.x = x
  self.y = y
end

function food:getX()
  return self.x
end

function food:getY()
  return self.y
end

function food:getPosition()
  return x, y
end

function food:kill()
  self.respawn_ = true
end

function food:isKilled()
  return self.respawn_
end

function food:respawn(x, y)
  self.respawn_ = false
  self.x = x
  self.y = y
end

function food:draw(scale)
  love.graphics.draw(foodTile, (self.x-1)*foodTileWidth*scale, (self.y-1)*foodTileHeight*scale, 0, scale)
end
