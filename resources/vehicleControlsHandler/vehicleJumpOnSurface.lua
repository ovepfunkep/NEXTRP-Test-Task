function vehicleJump()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (isElement(vehicle) and getPedOccupiedVehicleSeat(localPlayer) == 0 and 
	(isVehicleWheelOnGround (vehicle, 0) or isVehicleWheelOnGround ( vehicle, 0 ) or 
	isVehicleWheelOnGround ( vehicle, 0 ) or isVehicleWheelOnGround ( vehicle, 0 ))) then
		local x,y,z = getElementPosition(vehicle)
		setElementPosition(vehicle, x,y,z + 2)
	end
end

bindKey("lshift", "down", vehicleJump)