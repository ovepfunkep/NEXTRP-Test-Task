function checkCarRestriction(player)
    if (getElementData(source, "owner") ~= false and getElementData(source, "owner") ~= player) then
        cancelEvent()
    end
end

addEventHandler("onVehicleStartEnter", root, checkCarRestriction);