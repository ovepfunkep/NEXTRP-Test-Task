factions = {}

function findPlayerById(playerId)
	local players = getElementsByType("player")
	for k, player in ipairs(players) do 
		if getElementData(player, "id") == playerId then return player end
	end
end

function findFactionById(stringId)
	for k, faction in ipairs(factions) do 
		if faction.Id == stringId then return faction end
	end
end

function getFactionPlayers(factionId)
	local players = {}
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "factionId") == factionId then table.insert(players, v) end
	end
	return players
end

function createFaction(playerSource, commandName, name, stringId)
	if stringId and name and not findFactionById(stringId) then
    	local newFaction = {}
		newFaction.Id = stringId
		newFaction.Name = name
		newFaction.PlayersIds = {} -- не захотел хранить кучу данных о пользователях
		newFaction.Leader = 0
		table.insert(factions, newFaction)
		outputChatBox("Successfully created faction.")
	else outputChatBox("You can't create a faction.") end
end
addCommandHandler("faction_create", createFaction)

function firePlayer(player)
	local playerFactionId = getElementData(player, "factionId")
	if not playerFactionId then return end -- if player doesn't have faction
	
	local faction = findFactionById(playerFactionId)

	local position = 0
	for k, val in ipairs(faction.PlayersIds) do
		if val == playerId then position = k break end
	end

	if faction.Leader == player then faction.Leader = nil end 

	table.remove(faction.PlayersIds, position)
	setElementData(player, "factionId", false)
	triggerClientEvent(player, "playerFired", root) -- remove interface from player
	triggerClientEvent(getFactionPlayers(playerFactionId), "removePlayerFromList", root) -- clear player from faction players list
end

addEvent("CFirePlayerById", true)
function firePlayerById(id)
	player = findPlayerById(id)
	firePlayer(player)
end
addEventHandler("CFirePlayerById", root, firePlayerById)

function setPlayerFaction(playerSource, commandName, playerId, factionId)
	local playerFactionId = getElementData(playerSource, "factionId")

	if playerFactionId == factionId then return end

	firePlayer(playerSource) -- remove from another faction if invited to new or if factionId == nil
	
	if factionId then 
		table.insert(findFactionById(factionId).PlayersIds, playerId)
		setElementData(playerSource, "factionId", factionId)
		triggerClientEvent(playerSource, "addedToFaction", playerSource) -- add faction interface
		triggerClientEvent(getFactionPlayers(factionId), "addedNewPlayer", playerSource) -- update members list 
		outputChatBox("Successfully added player to faction.")
	end
end
addCommandHandler("set_player_faction", setPlayerFaction)

function setPlayerFactionLeader(playerSource, commandName, playerId, factionId)
	player = findPlayerById(tonumber(playerId))
	findFactionById(factionId).Leader = player
	setPlayerFaction(playerSource, commandName, playerId, factionId)
	triggerClientEvent(player, "becameLeader", playerSource)
	outputChatBox("Successfully set new faction leader.")
end
addCommandHandler("set_player_faction_leader", setPlayerFactionLeader)

function sendMessageToFaction(playerSource, commandName, text)
	local outputText = getElementData(playerSource, "fullName") .. ": " .. text
	outputChatBox(outputText, getFactionPlayers(getElementData(playerSource, "factionId")), 0, 0, 255)
end
addCommandHandler("f", sendMessageToFaction)

addEvent("CGetPlayerFactionData", true)
function sendPlayerFactionToClient()
	factionId = getElementData(source, "factionId")
	triggerClientEvent(source, "sentPlayerFactionData", source, findFactionById(factionId), getFactionPlayers(factionId))
end
addEventHandler("CGetPlayerFactionData", getRootElement(), sendPlayerFactionToClient)

addEvent("CInvitePlayer", true)
function invitePlayerToFaction(playerId, faction)
	triggerClientEvent(findPlayerById(playerId), "playerInvited", source, faction)
end
addEventHandler("CInvitePlayer", root, invitePlayerToFaction)

addEvent("COfferAccepted", true)
function addInvitedPlayer(faction)
	setPlayerFaction(source, nil, getElementData(source, "id"), faction.Id)
end
addEventHandler("COfferAccepted", root, addInvitedPlayer)