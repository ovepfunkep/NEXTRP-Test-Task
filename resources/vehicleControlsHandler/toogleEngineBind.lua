function toogleEngine()
	iprint("1")
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if isElement(vehicle) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		local state = getVehicleEngineState(vehicle)
		if not state then
			setVehicleEngineState(vehicle, true)
		else
			setVehicleEngineState(vehicle, false)
		end
	end
end

toggleControl("vehicle_look_right", false)
bindKey("e", "down", toogleEngine)