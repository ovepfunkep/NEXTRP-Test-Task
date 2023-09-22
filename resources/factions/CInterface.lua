playerFaction = nil
factionPlayers = {}
tabPanel = nil
managementTab = nil
listTab = nil
playerList = {}

addEvent("becameLeader", true)
function changeInterfaceToLeaders()
	if tabPanel ~= nil then
		destroyElement(tabPanel)
		createFactionLeaderInterface()
	end
end
addEventHandler("becameLeader", getRootElement(), changeInterfaceToLeaders)

function createFactionLeaderInterface()
	local X = 0.35
	local Y = 0.25
	local Width = 0.3
	local Height = 0.5
	tabPanel = guiCreateTabPanel(X, Y, Width, Height, true)
	
	listTab = guiCreateTab("Player list", tabPanel)
	X = 0.05
	Y = 0.05
	Width = 0.3
	Height = 0.75
	playerList = guiCreateGridList(X, Y, Width, Height, true, listTab)
	guiGridListAddColumn(playerList, "Player", 1)
	for k,v in ipairs(factionPlayers) do
		guiGridListAddRow(playerList, getElementData(v, "fullName"))
	end

	if playerFaction.Id == "city_mayor" then 
		managementTab = guiCreateTab("City management", tabPanel)
	end
	X = 0.05
	Y = 0.825
	Width = 0.3
	Height = 0.1
	buttonFire = guiCreateButton(X, Y, Width, Height, "Fire", true, listTab)

	function fireSelectedPlayer()
		r, c = guiGridListGetSelectedItem(playerList)
		fullName = guiGridListGetItemText(playerList, r, c)
		_, i = string.find(fullName, "]")
		id = tonumber(string.sub(fullName, 2, i - 1))
		triggerServerEvent("CFirePlayerById", localPlayer, id)
	end
	addEventHandler("onClientGUIClick", buttonFire, fireSelectedPlayer)

	X = 0.5
	Y = 0.35
	Width = 0.3
	Height = 0.05
	editBox = guiCreateEdit(X, Y, Width, Height, "Player Id", true, listTab)
	X = 0.6
	Y = 0.42
	Width = 0.1
	Height = 0.05
	inviteButton = guiCreateButton(X, Y, Width, Height, "Invite", true, listTab)
	function invitePlayer()
		playerId = tonumber(guiGetText(editBox))
		triggerServerEvent("CInvitePlayer", localPlayer, playerId, playerFaction) 
	end
	addEventHandler("onClientGUIClick", inviteButton, invitePlayer)
	
	guiSetVisible(tabPanel, false)
end

function createFactionMemberInterface()
	local X = 0.42
	local Y = 0.25
	local Width = 0.15
	local Height = 0.4
	tabPanel = guiCreateTabPanel(X, Y, Width, Height, true)
	
	listTab = guiCreateTab("Player list", tabPanel)
	X = 0.15
	Y = 0.05
	Width = 0.7
	Height = 0.8
	playerList = guiCreateGridList(X, Y, Width, Height, true, listTab)
	guiGridListAddColumn(playerList, "Player", 1)
	for k,v in ipairs(factionPlayers) do
		guiGridListAddRow(playerList, getElementData(v, "fullName"))
	end
	
	guiSetVisible(tabPanel, false)
end

addEvent("addedToFaction", true)
function addFactionInterface()
	triggerServerEvent("CGetPlayerFactionData", localPlayer)
end	
addEventHandler("addedToFaction", localPlayer, addFactionInterface)

setElementData(localPlayer, "factionId", false) -- need for debugging (on resource restart)
if getElementData(localPlayer, "factionId") ~= false then addFactionInterface() end

addEvent("sentPlayerFactionData", true)
function setPlayerFaction(faction, factionPlayersData)
	playerFaction = faction
	factionPlayers = factionPlayersData
	if playerFaction.Leader == localPlayer then createFactionLeaderInterface() 
	else createFactionMemberInterface() end
	bindKey("p", "down", toogleInterface)
end
addEventHandler("sentPlayerFactionData", root, setPlayerFaction)

function toogleInterface()
	guiSetVisible(tabPanel, not guiGetVisible(tabPanel))
	showCursor(not isCursorShowing(localPlayer))
end

addEvent("playerFired", true)
function removeFactionInterface()
	destroyElement(tabPanel)
	unbindKey("p", "down", toogleInterface)
	showCursor(false)
end
addEventHandler("playerFired", localPlayer, removeFactionInterface)

addEvent("removePlayerFromList", true)
function removePlayer()
	for pos, v in ipairs(factionPlayers) do
		if getElementData(v, "factionId") == false then 
			table.remove(factionPlayers, pos)
			local playerFullName = getElementData(v, "fullName")  
			for p, val in ipairs(playerList) do
				if val == playerFullName then guiGridListRemoveRow(playerList, p) break end 
			end 
			break 
		end
	end
end
addEventHandler("removePlayerFromList", localPlayer, removePlayer)

addEvent("playerInvited", true)
function createInvitationWindow(faction)
	X = 0.35
	Y = 0.4
	Width = 0.3
	Height = 0.1
	window = guiCreateWindow(X, Y, Width, Height, "Invitation", true)

	X = 0.1
	Y = 0.3
	Width = 0.9
	Height = 0.2
	headerText = guiCreateLabel( X, Y, Width, Height, getPlayerName(source) .. " offers you to become a member of " .. faction.Name, true, window)

	X = 0.1
	Y = 0.6
	Width = 0.35
	Height = 0.5
	buttonAccept = guiCreateButton( X, Y, Width, Height, "Accept", true, window )
		
	function acceptInviteOffer()
		triggerServerEvent("COfferAccepted", localPlayer, faction)
		destroyElement(window)
	end
	addEventHandler("onClientGUIClick", buttonAccept, acceptInviteOffer)

	X = 0.5
	Y = 0.6
	Width = 0.35
	Height = 0.5
	buttonDecline = guiCreateButton( X, Y, Width, Height, "Decline", true, window )
		
	function declineInviteOffer()
		destroyElement(window)
	end
	addEventHandler("onClientGUIClick", buttonDecline, declineInviteOffer)
end
addEventHandler("playerInvited", localPlayer, createInvitationWindow)

addEvent("addedNewPlayer")
function addPlayerToList()
	table.insert(factionPlayers, #list+1, source)
	guiGridListAddRow(playerList, getElementData(source, "fullName"))
end
addEventHandler("addedNewPlayer", localPlayer, addPlayerToList)