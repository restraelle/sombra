-- an example file for sombra

require "sombra"

function love.load()
	r = 0;
	g = 0;
	b = 0;
	corners = 0;
	
	isMouseReset = true;
	
	saveR = 0;
	saveG = 0;
	saveB = 0;
	
	gui = sombra.new(0, 0);
	
	mouseX = 0;
	mouseY = 0;
	mouseXCalc = 0;
	mouseYCalc = 0;
	mouseTimer = 0;
	mouseLoopAlternator = false;
	
	gui.add(1, sombra.newButton(30, 30, 200, 60, {label="On", onclick=test}));
	gui.add(2, sombra.newButton(30, 120, 200, 60, {label="Off", onclick=test2}));
	gui.add(3, sombra.newSlider(30, 300, 200, 20, {value=0.5, label="Red Value", maxDisplayValue=255, labelWidth=120}));
	gui.add(4, sombra.newSlider(30, 350, 400, 10, {value=0.5, label="Green Value", labelWidth=120}));
	gui.add(5, sombra.newSlider(30, 400, 400, 10, {value=0.5, label="Blue Value", labelWidth=120}));
	gui.add(6, sombra.newSlider(30, 450, 400, 10, {value=0.5, label="Box Roundness", displayValueSuffix="px", labelWidth=120}));
	gui.add(7, sombra.newButton(30, 220, 150, 30, {label="Save", onclick=save}));
	gui.add(8, sombra.newButton(250, 220, 150, 30, {label="Load", onclick=ld}));
	gui.add(9, sombra.newCheckbox(30, 480, 15, 15, {label="Show square"}));
	gui.add(10, sombra.newCheckbox(30, 500, 15, 15, {label="Shift square"}));
	gui.add(18, sombra.newButton(500, 500, 200, 20, {label="Reset Mouse", onclick=resetmouse}));
	
end

function resetmouse()
	mouseXCalc = love.mouse.getX();
	mouseYCalc = love.mouse.getY();
	isMouseReset = false;
	
end

function test2()
	gui.setValue(3, 0);
	gui.setValue(4, 0);
	gui.setValue(5, 0);
end

function test()
	num = 1.0;
	gui.setValue(3, num);
	gui.setValue(4, num);
	gui.setValue(5, num);
end

function save()
	saveR = r;
	saveG = g;
	saveB = b;
end

function ld()
	gui.setValue(3, saveR);
	gui.setValue(4, saveG);
	gui.setValue(5, saveB);
end

function love.update(dt)
	gui.update(dt);
	r = gui.getValue(3);
	g = gui.getValue(4);
	b = gui.getValue(5);
	corners = gui.getValue(6) * 50;
	if(isMouseReset == false) then
		mouseTimer = mouseTimer + dt;
		mouseXCalc = lerp(mouseXCalc, 0, 10, dt);
		mouseYCalc = lerp(mouseYCalc, 0, 10, dt);
		
		if(mouseLoopAlternator == false) then
			love.mouse.setX(mouseXCalc);
			mouseLoopAlternator = true;
		else
			love.mouse.setY(mouseYCalc);
			mouseLoopAlternator = false;
		end
		if(mouseTimer >= 2) then
			isMouseReset = true;
			mouseTimer = 0;
		end
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0.5, 0.5, 0.5);
	love.graphics.setColor(1*r, 1*g, 1*b, 255);
	if(gui.getValue(9) == true) then
		love.graphics.rectangle("fill", 250, 10, 200, 200, corners, corners);
	end
	gui.draw();
end
