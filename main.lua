function initData()
	if AccountKeyScores == nil then
		AccountKeyScores = {};
	end
	currChar = UnitName("player");
	if AccountKeyScores[currChar] == nil then
		AccountKeyScores[currChar] = {};
	end
	mapIDList = C_ChallengeMode.GetMapTable();
	for i, mapID in pairs(mapIDList) do
		KeyScores, KeyBest = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(mapID)
		AccountKeyScores[currChar][mapID] = KeyScores
	end
end
local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
--EventFrame:RegisterEvent("CHAT_MSG_PARTY")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		initData()
	end
end)