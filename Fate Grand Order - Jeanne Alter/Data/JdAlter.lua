function HolysiteCountJeanneDArc(playerId)
	local pPlayer = Players[playerId];
	local pPlayerConfig = PlayerConfigurations[playerId];
    local HolyNum = -1;
	
	if pPlayer:IsMajor() and pPlayer:IsAlive() then
		if pPlayerConfig:GetLeaderTypeName() == "LEADER_FATE_JEANNE_ALTER" then
			local HolyNum = 0;
			local pCities = pPlayer:GetCities();
			
			for i, pCity in pCities:Members() do
				local cityDistricts:table = pCity:GetDistricts();
				if cityDistricts:HasDistrict(GameInfo.Districts["DISTRICT_EXECUTION_GROUND"].Index) then
					HolyNum = HolyNum + 1;
				end 
			end
						
		end
	end
	if HolyNum == -1 then
	    print("Wrong Player Holy Site Calculated!\n");
	end
	return HolyNum;
end

function Ent_Test_JeanneDArc_Alter(JeanneDArc_Table)
    local AttackerEnt = 1431908133;
    local DefenderEnt = -1632097141;
    local IDEnt = 1472654640;
    local DamageEnt = -958805242;
    
    print("Instant Kill Detection Activated!\n");
    local AttackerPlayerID = JeanneDArc_Table[AttackerEnt][IDEnt]["player"];
    local DefenderPlayerID = JeanneDArc_Table[DefenderEnt][IDEnt]["player"];

	print(AttackerPlayerID);
	print(DefenderPlayerID);
	local xPlayerConfig = PlayerConfigurations[AttackerPlayerID];
	local pPlayerConfig = PlayerConfigurations[DefenderPlayerID];
	if xPlayerConfig:GetLeaderTypeName() == "LEADER_FATE_JEANNE_ALTER" then
		local AttackerUnitID = JeanneDArc_Table[AttackerEnt][IDEnt]["id"];
		local DefenderUnitID = JeanneDArc_Table[DefenderEnt][IDEnt]["id"];
		local DefenderUnitType = JeanneDArc_Table[DefenderEnt][IDEnt]["type"];
		if  DefenderUnitType == 1 then
		    print("Instant Kill Judgement Loaded!\n");
		    local PlayerDefender = Players[DefenderPlayerID];
			local pUnits = PlayerDefender:GetUnits();
			--local Threshold = HolysiteCountJeanneDArc(AttackerPlayerID)*2;
			local Threshold = getThreshold(AttackerPlayerID);

			if Threshold == 0 then
			return ;
			end

			local UnitsMember = pUnits:Members();
			local UnitsXMember = xUnits:Members();

			for ii, pUnit in pUnits:Members() do
			    if pUnit:GetID() == DefenderUnitID then
				    local remaining = (100 - pUnit:GetDamage());
				    if (remaining <= Threshold) then
					    UnitManager.Kill(pUnit, false);										
					end
                end					
		    end		
		end
	end
end

local number_arr = {5,8,10,11,12,13,14,15,16,17,18,19,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,30,30};
print("Judgement Number:"..#number_arr);
function getThreshold(AttackerPlayerID)
	local number = HolysiteCountJeanneDArc(AttackerPlayerID);
	
	if number == 0 then
	return 0;
	end

	if number > #number_arr then
	return number_arr[#number_arr];
	end

	local result = number_arr[number];
	return result;

end

Events.Combat.Add(Ent_Test_JeanneDArc_Alter);
--------------------------------------------------------------

