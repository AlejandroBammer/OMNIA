local mt = {}
mt.__index = mt


function mt:get(itemIndex)
	return self.items[itemIndex]
end


function mt:add(item)
	table.insert(self.items, item)
	self.indexCount = self.indexCount + 1
end


function mt:remove(index)
    table.remove(self.items, index)
end


function mt:find(parameter, value, breakOnOne)
    local list = {}
	
	if (value == nil) then
		for _, item in pairs(self.items) do
			if (item[parameter]) then
				table.insert(list, item)
				
				if (breakOnOne) then break end
			end
		end
	else
		for _, item in pairs(self.items) do
			if (item[parameter] == value) then
				table.insert(list, item)
				
				if (breakOnOne) then break end
			end
		end
	end

    return list
end


return
{
    new = function()
        local nt = {
			indexCount = 0,
			items = {}
        }
        setmetatable(nt, mt)

        return nt
    end
}
