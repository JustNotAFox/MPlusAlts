function MPAInitData()
	if MPAAccountKeyScores == nil then
		MPAAccountKeyScores = {};
	end
	currChar = UnitName("player");
	if MPAAccountKeyScores[currChar] == nil then
		MPAAccountKeyScores[currChar] = {};
	end
	mapIDList = C_ChallengeMode.GetMapTable();
	for i, mapID in pairs(mapIDList) do
		KeyScores, KeyBest = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
		MPAAccountKeyScores[currChar][mapID] = KeyScores
	end
end
function MPAChatParse(text)
	local mapString, keyLevel = string.match(text, '|Hkeystone:%d+:(%d+):(%d+)')
	if mapString == nil or keyLevel == nil then
		return
	end
	local keyDungeonName = C_ChallengeMode.GetMapUIInfo(mapString)
	print("Found keystone", keyLevel, keyDungeonName)
end
local MPAEventFrame, MPAEventHandlers = CreateFrame("frame", "EventFrame"), {}
function MPAEventHandlers:PLAYER_ENTERING_WORLD()
	MPAInitData()
end
function MPAEventHandlers:CHAT_MSG_PARTY(text, ...)
	MPAChatParse(text)
end
function MPAEventHandlers:CHAT_MSG_PARTY_LEADER(text, ...)
	MPAChatParse(text)
end
for event, handler in pairs(MPAEventHandlers) do
	MPAEventFrame:RegisterEvent(event)
end
MPAEventFrame:SetScript("OnEvent", function(self, event, ...)
	MPAEventHandlers[event](self, ...)
end)