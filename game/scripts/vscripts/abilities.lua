-- The following three functions are necessary for building helper.

function build( keys )
	local player = keys.caster:GetPlayerOwner()
	local pID = player:GetPlayerID()

	-- Check if player has enough resources here. If he doesn't they just return this function.
	
	local returnTable = BuildingHelper:AddBuilding(keys)

	keys:OnBuildingPosChosen(function(vPos)
		--print("OnBuildingPosChosen")
		-- in WC3 some build sound was played here.
	end)

	keys:OnConstructionStarted(function(unit)
		if Debug_BH then
			print("Started construction of " .. unit:GetUnitName())
		end

		unit:SetHullRadius(53)

		print("Trying obstruction")		
		print("Collision: " .. unit:GetCollisionPadding())
		print("Hull: " .. unit:GetHullRadius())
		print("Padding: " .. unit:GetPaddedCollisionRadius())
		print("Ground move: ", unit:HasGroundMovementCapability())
		print("Phased: ", unit:IsPhased())
		print("Unit Collision?: ", unit:NoUnitCollision())


		local origin = unit:GetAbsOrigin()
		local points = { Vector(origin.x-64, origin.y-64, origin.z),
		                 Vector(origin.x-64, origin.y+64, origin.z),
		                 Vector(origin.x+64, origin.y-64, origin.z),
		                 Vector(origin.x+64, origin.y+64, origin.z)
		               }


		for i=1,#points do
		    local obstruction = Entities:CreateByClassname("point_simple_obstruction")
    		Timers:CreateTimer(1, function()
				-- DeepPrintTable(obstruction)
			    obstruction:SetEnabled(true,true) --I think the 2nd bool is the vision sight-blocking
			    obstruction:SetAbsOrigin(points[i])
			end)


		end
		Timers:CreateTimer(0.1, function()
				FindClearSpaceForUnit(keys.caster, keys.caster:GetAbsOrigin(), true)
			end)


		-- Unit is the building be built.
		-- Play construction sound
		-- FindClearSpace for the builder
		
		-- start the building with 0 mana.
		unit:SetMana(0)
	end)
	keys:OnConstructionCompleted(function(unit)
		if Debug_BH then
			print("Completed construction of " .. unit:GetUnitName())
		end
		FindClearSpaceForUnit(keys.caster, keys.caster:GetAbsOrigin(), true)
		-- Play construction complete sound.
		-- Give building its abilities
		-- add the mana
		unit:SetMana(unit:GetMaxMana())
	end)

	-- These callbacks will only fire when the state between below half health/above half health changes.
	-- i.e. it won't unnecessarily fire multiple times.
	keys:OnBelowHalfHealth(function(unit)
		if Debug_BH then
			print(unit:GetUnitName() .. " is below half health.")
		end
	end)

	keys:OnAboveHalfHealth(function(unit)
		if Debug_BH then
			print(unit:GetUnitName() .. " is above half health.")
		end
	end)

	--[[keys:OnCanceled(function()
		print(keys.ability:GetAbilityName() .. " was canceled.")
	end)]]

	-- Have a fire effect when the building goes below 50% health.
	-- It will turn off it building goes above 50% health again.
	keys:EnableFireEffect("modifier_jakiro_liquid_fire_burn")
end

function building_canceled( keys )
	BuildingHelper:CancelBuilding(keys)
end

function create_building_entity( keys )
	BuildingHelper:InitializeBuildingEntity(keys)
end

function SellBuilding( keys )
	local caster = keys.caster
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local pID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(pID)
	
	local name = caster:GetUnitName()
	local unit_table = GameRules.UnitKV[name]
	local sellBounty = unit_table.SellBounty
	DeepPrintTable(caster)
	
	-- for i, v in ipairs(player.buildingEntities) do 
	-- 	if v == caster then
	-- 		print("Deleted building from table")
	-- 		--table.remove(player.buildingEntities, i)
	-- 	end
	-- 	--PrintTable( player.buildingEntities )
	-- end

	caster:RemoveBuilding(true)

	if sellBounty ~= 0 then
		hero:SetGold(hero:GetGold() + sellBounty, false)

		-- Add gold instead

		--player.lumber = player.lumber + sellBounty
		
		--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
		--FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
		--PopupLumber(caster, sellBounty)
		PopupGoldGain(caster, sellBounty)
	end
end

function UpgradeBuilding( keys )
	local caster = keys.caster
	local pID = caster:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(pID)
	local pos = caster:GetAbsOrigin()
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	local squares = caster.squaresOccupied
	
	--caster:RemoveBuilding(true)
	caster:RemoveSelf()
	
	unit = CreateUnitByName(keys.Building, pos, false, hero, nil, hero:GetTeamNumber())
	unit:SetHullRadius(53)
	unit:SetOwner(hero)
	unit:SetControllableByPlayer(pID, true)
	unit:SetAbsOrigin(pos)
	unit.squaresOccupied = squares
	
	--player.lumber = player.lumber - keys.LumberCost
	--print("Lumber Spend. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
	--FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
end

