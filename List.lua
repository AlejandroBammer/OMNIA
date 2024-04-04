local mt = {}
mt.__index = mt


function mt:add(object)
    table.insert(self.items, object)
    self.onAdd(object)
end


function mt:remove(index)
    table.remove(self.items, index)
end

function mt:sort(func)
	table.sort(self.items, func)
end


function mt:find(e)
    local list = {}

    for _, item in ipairs(self.items) do
        if (item[e]) then
            table.insert(list, item)
        end
    end

    return list
end


return
{
    new = function()
        local nt = {
			items = {},
			onAdd = function() return nil end,
        }
        setmetatable(nt, mt)

        return nt
    end
}
