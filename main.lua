function MPAInitData()
	if MPAAccountKeyScores == nil then
		MPAAccountKeyScores = {};
	end
	if UnitLevel("player") < 60 then
		return
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
	local mapString, keyLevel, affixId = string.match(text, '|Hkeystone:%d+:(%d+):(%d+):(%d+)')
	if mapString == nil or keyLevel == nil then
		return
	end
	local currentAffix = string.match(C_ChallengeMode.GetAffixInfo(affixId),'(%S+)')
	local keyDungeonName = C_ChallengeMode.GetMapUIInfo(mapString)
	print("Found keystone", keyLevel, keyDungeonName)
	for charIndex in pairs(MPAAccountKeyScores) do
		local charScore = MPAAccountKeyScores[charIndex][tonumber(mapString)]
		if charScore == nil then
			print(charIndex,"does not have this dungeon complete at all.")
		else
			for i, runInfo in pairs(charScore) do
				if runInfo.name == currentAffix then
					runLevel, runComplete = runInfo.level, runInfo.completed
				end
			end
			if runLevel == nil then
				print(charIndex,"only has a key completed for this dungeon on the other affix")
			else
				if runLevel < tonumber(keyLevel) then
					print(charIndex,"has a lower level",runLevel,"key for this dungeon on this week's affix")
				else 
					if runLevel == tonumber(keyLevel) and not runComplete then
						print(charIndex,"has an untimed run on the same level as this key")
					end
				end
			end
		end
	end
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