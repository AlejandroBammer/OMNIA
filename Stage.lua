local mt = {}
mt.__index = mt

return
{
	new = function()
		local nt = {}
		setmetatable(nt, mt)
		
		return nt
	end
}
