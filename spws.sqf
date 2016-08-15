if (!hasInterface) exitWith {};
waitUntil {time > 0};
waitUntil {!isNull player};
waitUntil {(!(isNull (findDisplay 46)))};

aa_fnc_spw = 
{
weapHolder = "Weapon_Empty" createVehicle getPosATL player;
    weapHolder attachTo [player,[-0.1,-0.18,0.12],"pelvis"];
	weapHolder setVariable ["AA_Holster",true,true];
	weapHolder enableSimulation false;
	
	backWeaponAction = player addAction ["Take weapon back",{
	player action ["TakeWeapon", weapHolder, ((weaponCargo weapHolder) select 0)];
	if (primaryWeapon player != "") then {
	waitUntil {(count (magazinesAmmoCargo weapHolder) != 0)};
	{player addMagazine [_x select 0, _x select 1];} forEach (magazinesAmmoCargo weapHolder);
	clearMagazineCargoGlobal weapHolder;
	clearItemCargoGlobal weapHolder;
	clearBackpackCargoGlobal weapHolder;
	};
	},[],1,false,false,"",'(vehicle player == player) && (count (weaponCargo weapHolder) != 0) && (_this == player)'];
player addAction ["Put weapon on back",{
	player action ["PutWeapon", weapHolder, primaryWeapon player];
	waitUntil {(count (magazinesAmmoCargo weapHolder) != 0)};
	{player addMagazine [_x select 0, _x select 1];} forEach (magazinesAmmoCargo weapHolder);
	clearMagazineCargoGlobal weapHolder;
	clearItemCargoGlobal weapHolder;
	clearBackpackCargoGlobal weapHolder;
	},[],1,false,false,"",'(vehicle player == player) && (count (weaponCargo weapHolder) == 0) && (player hasWeapon (primaryWeapon player)) && (_this == player)'];	
};

[] call aa_fnc_spw;

addMissionEventHandler ["EachFrame",{weapHolder setVectorDirAndUp [(player selectionPosition "spine3") vectorFromTo (player selectionPosition "rfemur"),[-0.1,-0.5,1]];}];
player addEventHandler ["AnimDone", {if (count (weaponCargo weapHolder) > 0) then {player setUserActionText [backWeaponAction, (getText (configfile >> "CfgWeapons" >> ((weaponCargo weapHolder) select 0) >> "displayName"))];}];
player addEventHandler ["GetInMan", {if (!isNil "weapHolder") then {detach weapHolder; weapHolder setPos [0,0,0]}}];
player addEventHandler ["GetOutMan", {if (!isNil "weapHolder") then {weapHolder attachTo [player,[-0.1,-0.18,0.12],"pelvis"];}}];
player addEventHandler ["Respawn",{player call aa_fnc_spw;}];