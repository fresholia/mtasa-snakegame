local screenX, screenY = guiGetScreenSize()

Snake = Service:new("snake-game")

Snake.constructor = function()
    Snake.size = Vector2(500, 500)
    Snake.position = Vector2(screenX/2-500/2, screenY/2-500/2)

    if isElement(Snake.renderTarget) then
        Snake.renderTarget:destroy()
    end
    Snake.renderTarget = dxCreateRenderTarget(Snake.size.x, Snake.size.y, true)
    if isTimer(Snake.render) then
        killTimer(Snake.render)
    end
    Snake.tick = getTickCount()
    Snake.refreshTick = 200

    Snake.element = {
        {Position = Vector2(0, 5)},
        {Position = Vector2(10, 5)},
        {Position = Vector2(20, 5)},
        {Position = Vector2(30, 5), head=true},
        
    }

    Snake.lines = {
        x = {},
        y = {}
    }
    Snake.activity = {}
    for index, element in ipairs(Snake.element) do
        Snake.activity[index] = element.Position
    end

    Snake.gridLimit = 50
    Snake.gridPadding = 10
    Snake.lastClick = getTickCount()
    Snake.calculateGrids()
    showCursor(true)
    Snake.render = Timer(
        function()
            if Snake.tick+Snake.refreshTick <= getTickCount() then
                Snake.tick = getTickCount()

                dxSetRenderTarget(Snake.renderTarget, true)

                dxDrawRectangle(0, 0, Snake.size.x, Snake.size.y, tocolor(25, 25, 25, 230))
    
                
                for _, dataX in pairs(Snake.lines.x) do
                    for _, dataY in pairs(Snake.lines.y) do
                        local startX = dataX[1]
                        local startY = dataY[1]
                        local endX = dataX[2]
                        local endY = dataY[1]

                        dxDrawLine(startX, startY, endX, endY, tocolor(255,255,255,100), 1)

                        local startX = dataX[1]
                        local startY = dataY[1]
                        local endX = dataX[1]
                        local endY = dataY[2]

                        dxDrawLine(startX, startY, endX, endY, tocolor(255,255,255,100), 1)
                    end
                end

               
                for index, element in ipairs(Snake.element) do
                    local snakeX, snakeY = Snake.findNearGrid(element.Position.x, element.Position.y)
                    dxDrawRectangle(snakeX[1], snakeY[1], Snake.gridPadding, Snake.gridPadding, tocolor(0, 255, 0))
                    if element.head then
                        dxDrawRectangle(snakeX[1]+2, snakeY[1]+2, Snake.gridPadding/2, Snake.gridPadding/2, tocolor(0, 0, 0))
                    end
                end
                

                dxSetBlendMode("blend")
                dxSetRenderTarget()
            end
            if getKeyState("arrow_r") and Snake.lastClick+150 <= getTickCount() then
                Snake.lastClick = getTickCount()
                Snake.move("right")
            end
            if getKeyState("arrow_l") and Snake.lastClick+100 <= getTickCount() then
                Snake.lastClick = getTickCount()
                Snake.move("left")
            end
            if getKeyState("arrow_d") and Snake.lastClick+100 <= getTickCount() then
                Snake.lastClick = getTickCount()
                Snake.move("down")
            end
            dxDrawImage(Snake.position.x, Snake.position.y, Snake.size.x, Snake.size.y, Snake.renderTarget)

            --#Debug:
            local debugText = ""
            for index, row in ipairs(Snake.activity) do
                debugText = debugText..index..": X-"..row.x..", Y-"..row.y.."\n"
            end
            dxDrawText(debugText, 25, screenY/2-25/2, 25, 25, tocolor(255, 255, 255, 255/2), 1, "default", "left", "top")
        end,
    0, 0)
end

Snake.head = function()
    for index, element in ipairs(Snake.element) do
        if element.head then
            return Snake.element[index]
        end
    end
    return false
end

Snake.move = function(key)
    if key == "left" then
        
    elseif key == "right" then
        Snake.activity[#Snake.element + 1] = Vector2(Snake.head().Position.x + Snake.gridPadding, Snake.head().Position.y)
        for index, element in ipairs(Snake.element) do
            Snake.activity[index] = Snake.activity[index + 1]
            element.Position = Snake.activity[index]
        end
    elseif key == "down" then

    elseif key == "up" then
        
    end
end

Snake.calculateGrids = function()
    local GridCounter = 0
    local Positions = {X=0, Y=0}
    while (Snake.gridLimit > GridCounter) do
        
		local startX = Positions.X + (GridCounter * Snake.gridPadding)
		local startY = Positions.Y
		local endX = Positions.X + ((GridCounter + 1) * Snake.gridPadding)
		local endY = Positions.Y + (Snake.gridLimit * Snake.gridPadding)
        Snake.lines.x[startX] = {startX,endX}
        
		local startX = Positions.X
		local startY = Positions.Y + (GridCounter * Snake.gridPadding)
		local endX = Positions.X + (Snake.gridLimit * Snake.gridPadding)
        local endY = Positions.Y + ((GridCounter + 1) * Snake.gridPadding)
        
		Snake.lines.y[startY] = {startY,endY}
		GridCounter = GridCounter + 1
	end
	
end

Snake.findNearGrid = function(x, y)
    local Positions = {X=0, Y=0}
	local x = Snake.lines.x[Snake.roundToPadding(x,Positions.X)] or false
	local y = Snake.lines.y[Snake.roundToPadding(y,Positions.Y)] or false
	if not x or not y then
		return false
	else
		return x,y
	end
end

Snake.roundToPadding = function(val,startval)
	local k = startval
	local retval = false
	while true do
		if (k + Snake.gridPadding/2) > val then
			retval = k
			break
		elseif (k >= val) then
			retval = k
			break
		elseif (k < val) then
			k = k + Snake.gridPadding
		end
	end
	return retval
end

Snake.constructor()