function playerOne(trigger)
	--DeepPrintTable(trigger)

	local unit = trigger.activator

	if(not string.find(unit:GetUnitName(), "hero")) then
		print("is not hero")
		GameRules.LTW.lives[DOTA_TEAM_GOODGUYS] = GameRules.LTW.lives[DOTA_TEAM_GOODGUYS] - 1
		GameRules.LTW.lives[unit.team] = GameRules.LTW.lives[unit.team] + 1


		local teleport = Entities:FindByName( nil, "player1Teleport"):GetAbsOrigin()
		FindClearSpaceForUnit(unit, teleport, false)

		local waypoint = Entities:FindByName( nil, "player1Waypoint"):GetAbsOrigin()
		unit:MoveToPosition(waypoint + Vector(RandomInt(-400, 400),0,0))
		print("player1 lives: " .. GameRules.LTW.lives[DOTA_TEAM_GOODGUYS])
	end
	
	if(GameRules.LTW.lives[DOTA_TEAM_GOODGUYS] == 0) then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
	
end

function playerTwo(trigger)
	--DeepPrintTable(trigger)


	local unit = trigger.activator

	if(not string.find(unit:GetUnitName(), "hero")) then
		print("is not hero")
		GameRules.LTW.lives[DOTA_TEAM_BADGUYS] = GameRules.LTW.lives[DOTA_TEAM_BADGUYS] - 1
		GameRules.LTW.lives[unit.team] = GameRules.LTW.lives[unit.team] + 1

		local teleport = Entities:FindByName( nil, "player2Teleport"):GetAbsOrigin()
		FindClearSpaceForUnit(unit, teleport, false)

		local waypoint = Entities:FindByName( nil, "player2Waypoint"):GetAbsOrigin()
		unit:MoveToPosition(waypoint + Vector(RandomInt(-400, 400),0,0))
		print("player2 lives: " .. GameRules.LTW.lives[DOTA_TEAM_BADGUYS])
	end

	if(GameRules.LTW.lives[DOTA_TEAM_BADGUYS] == 0) then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
end