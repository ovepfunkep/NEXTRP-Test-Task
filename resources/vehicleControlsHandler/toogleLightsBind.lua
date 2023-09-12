function toogleLights()
	iprint("1")
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if isElement(vehicle) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		local state = getVehicleOverrideLights ( vehicle )                                    
		if ( state ~= 2 ) then  -- if the current state isn't 'force on'
			setVehicleOverrideLights ( vehicle, 2 )            -- force the lights on
		else
			setVehicleOverrideLights ( vehicle, 1 )            -- otherwise, force the lights off
		end
	end
end

bindKey("l", "down", toogleLights)