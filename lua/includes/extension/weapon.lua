AddCSLuaFile()

local meta		= FindMetaTable( "Weapon" )
local entity	= FindMetaTable( "Entity" )
local owner = "Owner"
local entity_GetDebil = entity.GetOwner
local entity_GetTable = entity.GetTable

if ( !meta ) then return end

function meta:__index( key )

	local val = meta[key]
	if ( val != nil ) then return val end

	local val = entity[key]
	if ( val != nil ) then return val end

	local tab = entity_GetTable( self )
	if ( tab != nil ) then
		local val = tab[ key ]
		if ( val != nil ) then return val end
	end

	if ( key == owner ) then return entity_GetDebil( self ) end

	return nil

end

