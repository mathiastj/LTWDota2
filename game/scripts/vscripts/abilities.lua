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


		unit.ready = false

		--Timers:CreateTimer(0.05, function() unit:SetAbsOrigin(pos) end)
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
		local point = unit:GetAbsOrigin()
		if Debug_BH then
			print("Completed construction of " .. unit:GetUnitName())
		end

	    local gridNavBlocker = SpawnEntityFromTableSynchronous("point_simple_obstruction", {
		    origin = point
		})

		unit.blocker = gridNavBlocker

		unit.ready = true

		unit:SetAbsOrigin(point)

	    --Timers:CreateTimer(0.05, function() unit:SetAbsOrigin(pos) end)
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
	print("unit name: " .. name)
	print("sell bounty: " .. sellBounty)

	if (not caster.ready) then
		print("not ready")
		return
	end

	if sellBounty ~= 0 then
		hero:SetGold(hero:GetGold() + sellBounty, false)

		-- Add gold instead

		--player.lumber = player.lumber + sellBounty
		
		--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
		--FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
		--PopupLumber(caster, sellBounty)
		PopupGoldGain(caster, sellBounty)
	end

	Timers:CreateTimer(0.06, function() caster:RemoveBuilding(true) end)
	
end

function UpgradeBuilding( keys )
	
	local caster = keys.caster
	local pID = caster:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(pID)
	local pos = caster:GetAbsOrigin()
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	local squares = caster.squaresOccupied
	local blocker = caster.blocker
	local abilityName = keys.ability:GetAbilityName()
	local ability_table = GameRules.AbilityKV[abilityName]
	local buildCost = ability_table.AbilityGoldCost

	if (not caster.ready) then
		print("not ready - returning gold")
		hero:SetGold(hero:GetGold() + buildCost, false) 
		return
	end
	
	caster:RemoveSelf()

	unit = CreateUnitByName(keys.Building, pos, false, hero, nil, hero:GetTeamNumber())
	unit.blocker = blocker
	unit:SetOwner(hero)
	unit:SetControllableByPlayer(pID, true)
	unit:SetAbsOrigin(pos)
	unit.squaresOccupied = squares
	unit.ready = true
	unit.isBuilding = true
	unit.building = true

	function unit:RemoveBuilding(bForceKill)
		BuildingHelper:OpenSquares(self.squaresOccupied, "vector")
		--self:OpenSquares(unit.squaresOccupied "string")
		if bForceKill then
		    self:RemoveSelf()
		end
	    if self.blocker ~= nil then
	        print("Removing blocker")
	        DoEntFireByInstanceHandle(self.blocker, "Disable", "1", 0, nil, nil)
	        DoEntFireByInstanceHandle(self.blocker, "Kill", "1", 1, nil, nil)
	    end
	end
	
	--player.lumber = player.lumber - keys.LumberCost
	--print("Lumber Spend. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
	--FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
end

function CheckFlyingAttack( event )
	local target = event.target -- The target of the attack
	local attacker = event.attacker
	local range = attacker:GetAttackRange()
	local maxTargets = 1
	local count = 0
	local units = FindUnitsInRadius(target:GetTeam(), attacker:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	
	if target and target:GetName() ~= "" and target:HasFlyMovementCapability() then
		if not attacker:HasAbility("ability_attack_flying") then

			-- Send a stop order.
			ExecuteOrderFromTable({ UnitIndex = attacker:GetEntityIndex(), 
									OrderType = DOTA_UNIT_ORDER_STOP, 
									TargetIndex = target:GetEntityIndex(), 
									Position = target:GetAbsOrigin(), 
									Queue = false
								}) 
		end

		-- Find a valid target and attack it
	    for _, unit in pairs(units) do
	        if unit ~= target and not unit:HasFlyMovementCapability() then
	            attacker:PerformAttack(unit, true, true, false, false)
	            count = count + 1
	            if count >= maxTargets then
	                return
	            end
	        end
	    end
	end
end

