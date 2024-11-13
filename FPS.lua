local FPS = {}

function FPS.set(fps)
    fps = fps or 60
    FPS.min_dt = 1/fps
    FPS.next_time = love.timer.getTime()
end

function FPS.update()
    FPS.next_time = FPS.next_time + FPS.min_dt
end

function FPS.draw()
    local cur_time = love.timer.getTime()
	if (FPS.next_time <= cur_time) then
		FPS.next_time = cur_time
	end
	love.timer.sleep(FPS.next_time - cur_time)
end

return FPS