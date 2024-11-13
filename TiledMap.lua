local Scene = require("Scene")
local Sprite = require("Sprite")
local GameObject = require("GameObject")
local Collision = require("Collision")

local mt = {}
mt.__index = mt

function mt:getGidTileset(gid)
	if (not self.tilesetCache[gid]) then
		for _, tileset in ipairs(self.map.tilesets) do
			if (gid-tileset.data.tilecount >= tileset.firstgid and gid-tileset.data.tilecount < tileset.firstgid + tileset.data.tilecount) then
				self.tilesetCache[gid] = tileset
				
				return tileset
			end
		end
	else
		print("Devuelto en cache.")
		
		return self.tilesetCache[gid]
	end
	
	return nil
end


function mt:getTilesetTile(tileset, gid)
	local tile = nil
	
	if (not tileset.data.tiles[gid-tileset.data.tilecount]) then
		print("Error al intentar obtener el tile del gid: " .. gid .. " en el tileset del nombre: " .. tileset.name)
	else
		tile = tileset.data.tiles[gid-tileset.data.tilecount]
	end
	
	return tile
end


function mt:toScene()
	local scene = Scene.new()
	
	for _, layer in ipairs(self.map.layers) do
		for _, obj in ipairs(layer.objects) do
			
			-- Sprites.
			if (layer.class == "Sprite") then
				local objTileset = self:getGidTileset(obj.gid)
				local objTile = self:getTilesetTile(objTileset, obj.gid)
			
				local spr = Sprite.new(self.path .. "/" .. self.name .. "/" .. objTile.image)
				
				if (spr ~= nil) then
					-- Posición.
					spr.x = obj.x
					spr.y = obj.y - obj.height
					spr.name = obj.name
					spr.visible = obj.visible
					
					-- Propiedades.
					for k, v in pairs(obj.properties) do
						go[k] = v
					end
					
					scene:add(spr)
				else
					print("Error al cargar el sprite en el directorio: " .. self.path .. "/" .. self.name .. "/" .. objTile.image)
				end
			
			-- GameObjects.
			elseif (layer.class == "GameObject") then
				-- local objTileset = self:getGidTileset(obj.gid); local objTile = self:getTilesetTile(objTileset, obj.gid)
				
				if (obj.type ~= "") then
					local go = require("game objects/" .. obj.type).new()
					
					-- Posición.
					go.x = obj.x
					go.y = obj.y
					go.name = obj.name
					go.visible = obj.visible
					
					-- Propiedades.
					for k, v in pairs(obj.properties) do
						go[k] = v
					end
					
					scene:add(go)
				end
			
			-- Collisions.
			elseif (layer.class == "Collision") then
				local col = Collision.new(obj.x, obj.y, obj.width, obj.height)
				
				col.name = obj.name
				col.visible = obj.visible
					
				-- Propiedades.
				for k, v in pairs(obj.properties) do
					col[k] = v
				end
				
				scene:add(col)
			end
			
		end
	end
	
	return scene
end


return
{
	new = function(mapPath, mapName)
		local nt =
		{
			path = mapPath,
			name = mapName,
			tilesetCache = {},
		}
		setmetatable(nt, mt)
		
		nt.map = require(nt.path .. "/" .. nt.name .. "/" .. nt.name)
		
		
		-- Carga de módulos de tileset.
		for i, tileset in ipairs(nt.map.tilesets) do
			tileset.data = require(mapPath .. "/" .. mapName .. "/" .. string.sub(tileset.filename, 0, #tileset.filename-4))
		end
		
		
		return nt
	end
}
