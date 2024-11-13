local Utils = {}

--- Fuentes ---
Utils.unknownFont = require("Spritefont").new("gfx/unknown.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,:/", 1, { 38/255, 38/255, 38/255, 255/255 })

function Utils.approach(arg1, arg2, arg3)
	if (arg1 < arg2) then
		arg1 = arg1 + arg3
		return math.min(arg1, arg2)
	elseif (arg1 > arg2) then
		arg1 = arg1 - arg3
		return math.max(arg1, arg2)
	end
	
	return arg1
end

return Utils
