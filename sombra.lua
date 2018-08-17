--[[
			_            _            _   _         _               _           _          
		   / /\         /\ \         /\_\/\_\ _    / /\            /\ \        / /\        
		  / /  \       /  \ \       / / / / //\_\ / /  \          /  \ \      / /  \       
		 / / /\ \__   / /\ \ \     /\ \/ \ \/ / // / /\ \        / /\ \ \    / / /\ \      
		/ / /\ \___\ / / /\ \ \   /  \____\__/ // / /\ \ \      / / /\ \_\  / / /\ \ \     
		\ \ \ \/___// / /  \ \_\ / /\/________// / /\ \_\ \    / / /_/ / / / / /  \ \ \    
		 \ \ \     / / /   / / // / /\/_// / // / /\ \ \___\  / / /__\/ / / / /___/ /\ \   
	 _    \ \ \   / / /   / / // / /    / / // / /  \ \ \__/ / / /_____/ / / /_____/ /\ \  
	/_/\__/ / /  / / /___/ / // / /    / / // / /____\_\ \  / / /\ \ \  / /_________/\ \ \ 
	\ \/___/ /  / / /____\/ / \/_/    / / // / /__________\/ / /  \ \ \/ / /_       __\ \_\
	 \_____\/   \/_________/          \/_/ \/_____________/\/_/    \_\/\_\___\     /____/_/

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

function sombra.new(x, y)
	local self = {};
	self.container = {};
	self.globalX = x;
	self.globalY = y;
	self.width = width;
	self.height = height;
	
	self.add = function(id, element)
		table.insert(self.container, id, element);
	end
	
	self.update = function(dt)
		local mouseX, mouseY = lm.getPosition();
		for i, v in pairs(self.container) do
			if(mouseX > (v.x + self.globalX) and mouseX < (v.x + v.width + self.globalX)) then
				if(mouseY > (v.y + self.globalY) and mouseY < (v.y + v.height + self.globalY)) then
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
		for i, v in pairs(self.container) do
			v.draw(self.globalX, self.globalY);
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
	
	self.draw = function(x, y)
		lg.setColor(0, 0, 0, 100 * self.transitionCalc);
		lg.rectangle("fill", x + self.x, y + self.y, self.width, self.height, 0, 0);
		
		lg.setColor(220, 220, 220, 255);
		lg.rectangle("line", x + self.x, y + self.y, self.width, self.height, 0, 0);
		
		lg.setColor(255, 255, 255, 255);
		lg.printf(self.data.label, x + self.x, y + self.y + self.height/2-7, self.width, "center");
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

function sombra.newInvisibleButton(x, y, width, height, data)
	local self = {};
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.isPressed = 0;
	self.isHover = 0;
	self.isTriggered = false;
	self.data = data;
	
	self.draw = function(x, y)
		
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
		else
			self.isTriggered = false;
		end
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
	self.label = "";
	self.labelWidth = 100;
	self.maxDisplayValue = 100;
	self.displayValueSuffix = "";
	
	if(self.data.label ~= nil) then
		self.label = self.data.label;
		self.x = self.x + self.labelWidth;
	end
	
	if(self.data.labelWidth ~= nil) then
		self.x = self.x - self.labelWidth;
		self.labelWidth = self.data.labelWidth;
		self.x = self.x + self.labelWidth;
	end
	
	if(self.data.maxDisplayValue ~= nil) then
		self.maxDisplayValue = self.data.maxDisplayValue;
	end
	
	if(self.data.displayValueSuffix ~= nil) then
		self.displayValueSuffix = self.data.displayValueSuffix;
	end
	
	self.draw = function(x, y)
		lg.setColor(255, 255, 255, 255);
		lg.printf(self.label, x + self.x - self.labelWidth, y + self.y, self.labelWidth);
		lg.ellipse("fill", x + self.x + self.positionCalc, y + self.y + 5, self.handleSize, self.handleSize);
		lg.rectangle("line", x + self.x, y + self.y, self.barWidth, 10);
		lg.print(math.ceil(self.value*self.maxDisplayValue) .. self.displayValueSuffix, x + self.x + self.width + 18, y + self.y-2);
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
			love.mouse.setY(self.y+5);
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

function sombra.newCheckbox(x, y, width, height, data)
	local self = {};
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.unparsedData = data;
	self.isPressed = false;
	self.isHover = false;
	self.isTriggered = false;
	self.value = false;
	self.data = data;
	self.transition = 0;
	self.transitionCalc = 0;
	
	self.getValue = function()
		return self.value;
	end
	
	self.setValue = function(value)
		self.value = value;
	end
	
	self.draw = function(x, y)
		lg.setColor(255, 255, 255, 255);
		lg.rectangle("line", x + self.x, y + self.y, self.width, self.height);
		lg.setColor(255, 255, 255, self.transitionCalc*255);
		lg.rectangle("fill", x + self.x, y + self.y, self.width, self.height);
		lg.setColor(255, 255, 255, 255);
		lg.printf(self.data.label, x + self.x + self.width + 8, y + self.y, 200, "left");
	end

	self.update = function(dt)
		if(self.isPressed == 1) then
			if(self.isTriggered == false) then
				self.isTriggered = true;
				self.value = not self.value;
				if(self.value == true) then
					self.transition = 1;
				else
					self.transition = 0;
				end
			end
		else
			self.isTriggered = false;
		end
		
		self.transitionCalc = lerp(self.transitionCalc, self.transition, 30, dt);
		
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
		
	end
	
	self.draw = function()
		
	end

	self.update = function()

	end

	return self;
end
