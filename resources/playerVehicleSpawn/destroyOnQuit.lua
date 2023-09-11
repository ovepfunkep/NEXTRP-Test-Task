function playerQuitServer()
	if (isElement(getElementData(source, "myCar"))) then 
		destroyElement(getElementData(source, "myCar"))
	end
end

addEventHandler("onPlayerQuit", root, playerQuitServer)