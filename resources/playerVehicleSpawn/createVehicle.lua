function playerVehicleCreate(player, commandName, vehId)
	if (isElement((getElementData(player, "myCar")))) then 
		destroyElement(getElementData(player, "myCar"))
	end

	local x,y,z = getPositionFromElementOffset(player, 0, 5, 2)
	local rX,rY,rZ = getElementRotation(player)
	local veh = createVehicle(vehId, x, y, z, rX, rY, rZ + 90) 
	setElementData(player, "myCar", veh) 
	setElementData(veh, "owner", player) 
end

function getPositionFromElementOffset(element,offX,offY,offZ) 
    local m = getElementMatrix ( element )  -- Get the matrix 
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform 
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2] 
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3] 
    return x, y, z                               -- Return the transformed point 
end 

addCommandHandler("veh", playerVehicleCreate)