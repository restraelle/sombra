--[[

	S O M B R A
	a simple GUI library for simple people
	
	created by Raphael Restrepo
	
	This library is under GNU General Public License v2.0.
	(c) 2018 Cosmic Latte Studios. All rights reserved.

--]]

sombra = {};

local lg = love.graphics;
local lk = love.keyboard;
local lm = love.mouse;
local la = love.audio;

function lerp(a,b,t,dt)
	if(b == a) then
		return b
	else
		return a+(b-a)*t*dt
	end
end

function clamp(low, n, high) return math.min(math.max(n, low), high) end

function sombra.new()
	local self = {};
	self.container = {};
	
	self.add = function(element)
		table.insert(self.container, element);
	end
	
	self.update = function(dt)
		local mouseX, mouseY = lm.getPosition();
		for i, v in pairs(self.container) do
			if(mouseX > v.x and mouseX < (v.x + v.width)) then
				if(mouseY > v.y and mouseY < (v.y + v.height)) then
					if(lm.isDown(1) == true) then
						v.isPressed = 1;
					else
						v.isPressed = 0;
					end
					v.isHover = 1;
				else
					v.isHover = 0;
					v.isPressed = 0;
				end
			else
				v.isHover = 0;
			end
		end
		
		for i, v in pairs(self.container) do
			v.update(dt, mouseX, mouseY);
		end
	end
	
	self.getValue = function(index)
		return self.container[index].getValue();
	end
	
	self.setValue = function(index, value)
		self.container[index].setValue(value);
	end
	
	self.draw = function()
		lg.setColor(255, 255, 255, 255);
		for i, v in pairs(self.container) do
			v.draw();
		end
	end
  
	return self;
end

function sombra.newButton(x, y, width, height, data)
	local self = {};
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.isPressed = 0;
	self.isHover = 0;
	self.isTriggered = false;
	self.transition = 0;
	self.transitionCalc = 0;
	self.data = data;
	
	self.draw = function()
		lg.setColor(220, 220, 220, 255);
		lg.rectangle("line", self.x + (self.transitionCalc * 5), self.y + (self.transitionCalc * 5), self.width, self.height, 10, 10);
		lg.rectangle("line", self.x+5, self.y+5, self.width, self.height, 10, 10);
		
		lg.setColor(255, 255, 255, 255);
		lg.printf(self.data.label, self.x + (self.transitionCalc * 5), self.y + self.height/2-7 + (self.transitionCalc * 5), self.width, "center");
	end

	self.update = function(dt)
		if(self.isHover > 0) then
		
		else
		
		end
		if(self.isPressed > 0) then
			if(self.isTriggered == false) then
				self.data.onclick();
				self.isTriggered = true;
			end
			self.transition = 1;
		else
			self.isTriggered = false;
			self.transition = 0;
		end
		self.transitionCalc = lerp(self.transitionCalc, self.transition, 20, dt);
	end

	return self;
end

function sombra.newSlider(x, y, width, height, data)
	local self = {};
	self.data = data;
	self.x = x;
	self.y = y;
	self.handleSize = 15;
	self.value = 0;
	self.position = self.data.value;
	self.positionCalc = 0;
	self.tempPos = 0;
	self.barWidth = width;
	self.width = width;
	self.height = 15;
	self.isPressed = 0;
	self.isHover = 0;
	self.isTriggered = false;
	
	self.draw = function()
		lg.setColor(255, 255, 255, 255);
		lg.ellipse("fill", self.x + self.positionCalc, self.y + 5, self.handleSize, self.handleSize);
		lg.rectangle("line", self.x, self.y, self.barWidth, 10);
		lg.print(math.abs(self.value*100), self.x + self.width + 18, self.y-2);
	end

	self.update = function(dt, mouseX, mouseY)
		if(self.isHover > 0) then
		
		else
		
		end
		if(self.isPressed == 1) then
			if(self.isTriggered == false) then
				self.isTriggered = true;
			end
			self.position = clamp(mouseX-self.x, 0, self.width);
		else
			self.isTriggered = false;
		end
		self.positionCalc = lerp(self.positionCalc, self.position, 20, dt);
		self.value = self.position/self.width;
		self.data.value = self.value;
	end
	
	self.getValue = function()
		return self.value;
	end
	
	self.setValue = function(value)
		self.position = value*400;
	end
	
	return self;
end

function sombra.newElement(x, y, width, height, data)
	local self = {};
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.unparsedData = data;
	self.isPressed = false;
	self.isHover = false;
	
	self.getValue = function()
		return self.value;
	end
	
	self.setValue = function(value)
		self.position = value*400;
	end
	
	self.draw = function()
		
	end

	self.update = function()

	end

	return self;
end
