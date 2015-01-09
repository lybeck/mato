board = {
  width=10,
  height=10
}

local bgTile = love.graphics.newImage( "img/bg-tile.png" )
local bgWidth = bgTile:getWidth()
local bgHeight = bgTile:getHeight()

function board:getPixelWidth()
  return bgWidth * self.width;
end

function board:getPixelHeight()
  return bgHeight * self.height;
end

function board:new(o)
	o = o or {}
	setmetatable(o, self)
  self.__index = self
  return o
end

function board:draw(scale) 
	for y = 1,self.height do
	  for x = 1,self.width do
	    love.graphics.draw(bgTile, (x-1)*bgWidth*scale, (y-1)*bgHeight*scale, 0, scale)
	  end
	end
end

return board