--[[
Multiteam Example
]]


---------------------------------------------------------------------------
---------------------------------------------------------------------------
if CMultiteamExampleGameMode == nil then
	CMultiteamExampleGameMode = class({})
end

---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function CMultiteamExampleGameMode:InitMulti()
	print( "Multiteam Example addon is loaded." )

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple


	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS] = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self:GatherAndRegisterValidTeams()


	---------------------------------------------------------------------------
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
end


---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function CMultiteamExampleGameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function CMultiteamExampleGameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function CMultiteamExampleGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GameRules.LTW.lives[team] } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )





	UTIL_ResetMessageTextAll()
	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardTitle", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )
		if(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1) ~= -1) then
			name = PlayerResource:GetPlayerName(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1))
			UTIL_MessageTextAll(t.teamScore.."\t"..name, clr[1], clr[2], clr[3], 255)
		end
	end


	local sortedIncome = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedIncome, { teamID = team, teamScore = GameRules.LTW.income[team] } )
	end

	-- reverse-sort by score
	table.sort( sortedIncome, function(a,b) return ( a.teamScore > b.teamScore ) end )

	UTIL_MessageTextAll( "#ScoreboardBreaker", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardIncomeHeader", 255, 255, 255, 255 )
	UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 255 )
	for _, t in pairs( sortedIncome ) do
		local clr = self:ColorForTeam( t.teamID )
		if(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1) ~= -1) then
			name = PlayerResource:GetPlayerName(PlayerResource:GetNthPlayerIDOnTeam(t.teamID, 1))
			UTIL_MessageTextAll(t.teamScore.."\t"..name, clr[1], clr[2], clr[3], 255)
		end
	end
end


---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function CMultiteamExampleGameMode:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
		
	return 1
end


---------------------------------------------------------------------------
-- Helper functions
---------------------------------------------------------------------------
function ShuffledList( list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

function TableCount( t )
	local n = 0
	for _ in pairs( t ) do
		n = n + 1
	end
	return n
end


---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function CMultiteamExampleGameMode:GatherAndRegisterValidTeams()

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = DOTA_TEAM_GOODGUYS, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if team == DOTA_TEAM_GOODGUYS then
			maxPlayers = 1
		elseif team == DOTA_TEAM_BADGUYS  then
			maxPlayers = 1
		else 
			maxPlayers = 0
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

function TableFindKey( table, val )
	if table == nil then
		print( "nil" )
		return nil
	end

	for k, v in pairs( table ) do
		if v == val then
			return k
		end
	end
	return nil
end
