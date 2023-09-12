EngineTable = {}

function enterVehicle (thePed, seat) 
    if (seat == 0) then
        setVehicleEngineState(source, EngineTable[source] or false)
        EngineTable[source] = nil
    end
end

addEventHandler ( "onVehicleEnter", root, enterVehicle)

function exitVehicle (thePed, seat) 
    if (seat == 0) then
        EngineTable[source] = getVehicleEngineState(source) 
    end
end

addEventHandler ( "onVehicleExit", root, exitVehicle)