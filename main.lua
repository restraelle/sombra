-- an example file for sombra

require "sombra"

function love.load()
	r = 0;
	g = 0;
	b = 0;
	corners = 0;
	
	saveR = 0;
	saveG = 0;
	saveB = 0;
	
	gui = sombra.new();
	gui.add(sombra.newButton(30, 30, 200, 60, {label="on", onclick=test}));
	gui.add(sombra.newButton(30, 120, 200, 60, {label="off", onclick=test2}));
	
	gui.add(sombra.newSlider(30, 300, 400, 10, {value=0.5}));
	gui.add(sombra.newSlider(30, 350, 400, 10, {value=0.5}));
	gui.add(sombra.newSlider(30, 400, 400, 10, {value=0.5}));
	gui.add(sombra.newSlider(30, 450, 400, 10, {value=0.5}));
	
	gui.add(sombra.newButton(30, 220, 150, 30, {label="save", onclick=save}));
	gui.add(sombra.newButton(250, 220, 150, 30, {label="load", onclick=ld}));
	
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
end

function love.draw()
	love.graphics.setColor(255*r, 255*g, 255*b, 255);
	love.graphics.rectangle("fill", 250, 10, 200, 200, corners, corners);
	gui.draw();
end
