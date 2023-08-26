function joinHandler()
	spawnPlayer(source,2280,-1261,23)
	fadeCamera(source, true)
	setCameraTarget(source, source)
	outputChatBox ( "Hello world!")
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)