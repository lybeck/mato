-- directions
local U, D, R, L = 1, 2, 3, 4

local wormTile = love.graphics.newImage( "img/worm-tile.png" )
local wormTileWidth = wormTile:getWidth()
local wormTileHeight = wormTile:getHeight()

worm = {head=nil, tail=nil, direction=R, nextDirection=R, points=0, interval=.1, nextUpdate=0, maxX=nil, maxY=nil}

local startingLength = 5

local node = {next = nil, prev = nil, x = 0, y = 0}

function node:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function worm:new(o, maxX, maxY, x, y, length)
  o = o or {}
  length = length or startingLength
  x = x or 5
  y = y or 5
  setmetatable(o, self)
  self.__index = self
  
  o.maxX = maxX
  o.maxY = maxY
  
  o.head = node:new()
  o.head.x = x
  o.head.y = y
  local prev = o.head
  local thisNode
  for i = 1,length-1 do
    thisNode = node:new()
    thisNode.x = x - i
    thisNode.y = y
    prev.next = thisNode
    thisNode.prev = prev
    prev = thisNode
  end
  o.tail = prev
  return o
end

local function getNewHeadPosition(x, y, d, maxX, maxY)
  if d == U then
    y = y - 1
  elseif d == D then 
    y = y + 1
  elseif d == R then
    x = x + 1
  else
    x = x - 1
  end
  
  if y > maxY then
    y = 1
  end
  if y < 1 then
    y = maxY
  end
  if x > maxX then
    x = 1
  end
  if x < 1 then
    x = maxX
  end
  
  return x, y
end

function worm:getPoints()
	return self.points
end

local function updateWorm(w, f)
  
  w.direction = w.nextDirection
  local newHead = node:new()
  local oldHead = w.head
  newHead.prev = nil
  newHead.next = oldHead
  oldHead.prev = newHead
  w.head = newHead
  newHead.x, newHead.y = getNewHeadPosition(oldHead.x, oldHead.y, w.direction, w.maxX, w.maxY)
  
  if newHead.x == f:getX() and newHead.y == f:getY() then
    w.points = w.points + 1
    f:kill()
  else
    local newTail = w.tail.prev
    w.tail = newTail
    newTail.next = nil
  end
  
end

function worm:getAllPositions()
	local list = {}
	local n = self.head
	while n do
    table.insert(list, {x=n.x, y=n.y})
	  n = n.next
	end
	return list 
end

local function updateNewDirection(w)
	if love.keyboard.isDown("up") and w.direction ~= D then
	  w.nextDirection = U
	elseif love.keyboard.isDown("down") and w.direction ~= U then
    w.nextDirection = D
  elseif love.keyboard.isDown("right") and w.direction ~= L then
    w.nextDirection = R
  elseif love.keyboard.isDown("left") and w.direction ~= R then
    w.nextDirection = L
  end
end

function worm:update(dt, f)
  updateNewDirection(self)
  self.nextUpdate = self.nextUpdate + dt
  if self.nextUpdate > self.interval then
    self.nextUpdate = self.nextUpdate - self.interval
    updateWorm(self, f)
  end
end

function worm:draw(scale)
  local n = self.head
	while n do
	  love.graphics.draw(wormTile, (n.x-1)*wormTileWidth*scale, (n.y-1)*wormTileHeight*scale, 0, scale)
	  n = n.next
	end
end

function worm:isAlive()
  local n = self.head.next
  while n do
    if n.x == self.head.x and n.y == self.head.y then
      return false
    end
    n = n.next
  end
  return true
end
