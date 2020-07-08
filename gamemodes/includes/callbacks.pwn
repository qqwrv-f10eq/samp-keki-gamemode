//--------------------------------[CALLBACKS.PWN]--------------------------------

public OnPlayerConnect(playerid) {

    // 0 - ปิดธง (เป็นเท็จ)
	player_bf[playerid] = PlayerFlags:0;
    //CMDPermissions[playerid]=0;
    
	playerData[playerid][pFactionID]=
    playerData[playerid][pSQLID]=-1;

    playerData[playerid][pArmour]=
    playerData[playerid][pHealth]=
    playerData[playerid][pSHealth]=0.0;

	playerData[playerid][pFaction]=
	playerData[playerid][pFactionRank]=
    playerData[playerid][pCMDPermission]=
	playerData[playerid][pTalkStyle]=
    playerData[playerid][pDonateRank]=
    playerData[playerid][pInterior]=
    playerData[playerid][pVWorld]=
    playerData[playerid][pPnumber]=
    playerData[playerid][pLevel]=
    playerData[playerid][pCash]=
    playerData[playerid][pSpawnType]=0;
	
    playerData[playerid][pModel]=264;

	GetPlayerIp(playerid,playerData[playerid][pIP], 16);

	playerData[playerid][pSpectating]=INVALID_PLAYER_ID;

	// Damage System
	resetPlayerDamage(playerid);

	InjuredTime[playerid]=
	delayLeg[playerid]=0;

	playingAnimation{playerid}=
	isDeathmode{playerid}=
	isInjuredmode{playerid}=false;


	//SendClientMessage(playerid, COLOR_YELLOW, "คุณได้ถูกรีเซ็ตอาชีพเป็น "EMBED_WHITE"Novice"EMBED_YELLOW" แล้ว");
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	OnAccountUpdate(playerid);
	return 1;
}

public OnPlayerSpawn(playerid) {

    TogglePlayerSpectating(playerid, false);

	SetPlayerSkin(playerid, playerData[playerid][pModel]);

	if(GetPVarType(playerid, "MedicBill"))
	{
		new cut = 500 + playerData[playerid][pLevel] * 50;
		GivePlayerMoney(playerid, -cut);
	
		SendFormatMessage(playerid, COLOR_PINK, "EMT: ค่ารักษาพยาบาลของคุณมาถึงแล้ว $%d ขอให้โชคดี", cut);
		DeletePVar(playerid, "MedicBill");
		
		// ตั้งค่าเลือดและเกราะเป็นพื้นฐานเมื่อตัวละครเกิดใหม่
		playerData[playerid][pArmour]=0.0;
		if(playerData[playerid][pDonateRank] > 0) playerData[playerid][pHealth] = 100.0 + playerData[playerid][pSHealth];
		else playerData[playerid][pHealth] = 50.0 + playerData[playerid][pSHealth];
	}

	if(isDeathmode{playerid} || isInjuredmode{playerid})
	{	
		SetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
		SetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		SetPlayerInterior(playerid, playerData[playerid][pInterior]);
		SetPlayerVirtualWorld(playerid, playerData[playerid][pVWorld]);
		
		SetPlayerHealth(playerid, 25.0);
		
		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);

		if(!isDeathmode{playerid}) {
			InjuredTime[playerid] = 300;
		
			SendClientMessage(playerid, COLOR_LIGHTRED, "คุณได้รับบาดเจ็บอย่างรุนแรงตอนนี้ถ้าหากแพทย์ หรือใครก็ตามไม่สามารถช่วยคุณได้ คุณก็จะตาย");
			SendClientMessage(playerid, COLOR_LIGHTRED, "เพื่อยอมรับการตายพิมพ์ /acceptdeath");
			
			new str[64], countdamage;
			if((countdamage = countPlayerDamage(playerid)) != 0)
			{
				format(str, sizeof(str), "(( ได้รับความบาดเจ็บ %d ครั้ง /damages %d เพื่อดูรายละเอียด ))", countdamage, playerid);
    	        SetPlayerChatBubble(playerid, str, 0xFF6347FF, 20.0, 120000);
				SendClientMessage(playerid, COLOR_LIGHTRED, str);
			}
			
			GameTextForPlayer(playerid, "~b~brutally wounded", 5000, 4);
		}
		else {
			InjuredTime[playerid] = 60;
			SendClientMessage(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ 60 วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme");
		}
		bf_on(player_bf[playerid], IS_SPAWNED);
		return 1;
	}

	switch(playerData[playerid][pSpawnType])
	{
		case SPAWN_POINT_DEFAULT:
		{
			SetPlayerPos(playerid, -2027.7377,-42.1438,38.8047);
			SetPlayerFacingAngle(playerid, 181.2236);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
	
			playerData[playerid][pInterior] = 0;
			playerData[playerid][pVWorld] = 0;
		}
		case SPAWN_POINT_PROPERTY:
		{
			SetPlayerPos(playerid, -2027.7377,-42.1438,38.8047);
			SetPlayerFacingAngle(playerid, 181.2236);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
	
			playerData[playerid][pInterior] = 0;
			playerData[playerid][pVWorld] = 0;
		}
		case SPAWN_POINT_FACTION:
		{
			new id = playerData[playerid][pFactionID];
			if(id != -1) {
				SetPlayerPos(playerid, factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ]);
				SetPlayerFacingAngle(playerid, factionData[id][fSpawnA]);
				SetPlayerInterior(playerid, factionData[id][fSpawnInt]);
				SetPlayerVirtualWorld(playerid, factionData[id][fSpawnWorld]);
			}
			else {
				SetPlayerPos(playerid, -2027.7377,-42.1438,38.8047);
				SetPlayerFacingAngle(playerid, 181.2236);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				playerData[playerid][pInterior] = 0;
				playerData[playerid][pVWorld] = 0;
				playerData[playerid][pSpawnType]=SPAWN_POINT_DEFAULT;
			}
		}
		default: {
			SetPlayerPos(playerid, -2027.7377,-42.1438,38.8047);
			SetPlayerFacingAngle(playerid, 181.2236);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			playerData[playerid][pInterior] = 0;
			playerData[playerid][pVWorld] = 0;
			playerData[playerid][pSpawnType]=SPAWN_POINT_DEFAULT;
		}
	}

	// ตัวละครยังไม่เกิดใหม่ ให้ตั้งค่าเลือดและเกราะเดิม
	if(playerData[playerid][pHealth]) SetPlayerHealth(playerid, playerData[playerid][pHealth]);
	else {
        // ป้องกันบัคตาย
		if(playerData[playerid][pDonateRank] > 0) playerData[playerid][pHealth] = 100.0 + playerData[playerid][pSHealth];
		else playerData[playerid][pHealth] = 50.0 + playerData[playerid][pSHealth];
    }
    if(playerData[playerid][pArmour]) SetPlayerArmour(playerid, playerData[playerid][pArmour]);
	bf_on(player_bf[playerid], IS_SPAWNED);
	SetCameraBehindPlayer(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {

	bf_off(player_bf[playerid], IS_SPAWNED);

	playerData[playerid][pInterior] = GetPlayerInterior(playerid);
	playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
		
	if(!isInjuredmode{playerid}) isInjuredmode{playerid}=true;
	else isDeathmode{playerid} = true;
	
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (isInjuredmode{playerid} && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER))
		RemoveFromVehicle(playerid);

	if (newstate == PLAYER_STATE_WASTED)
	{
		bf_off(player_bf[playerid], IS_SPAWNED);
	}
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	new Float:health, Float:armour;
	GetPlayerHealth(playerid, health);

	if(issuerid != INVALID_PLAYER_ID)
	{
	  	GetPlayerArmour(playerid, armour);

		if(!delayLeg[playerid] && !isDeathmode{playerid} && !isInjuredmode{playerid})
		{
			switch(bodypart)
			{
				case 7,8:
				{
			  	 	SendClientMessage(playerid, COLOR_LIGHTRED, "-> คุณได้ถูกยิงที่ขา คุณจะลำบากในการวิ่งและกระโดด");
			  	  	delayLeg[playerid] = 5;
			  	}
			}
		}

		if(!isDeathmode{playerid}) {
			if(isInjuredmode{playerid})
			{
				if(InjuredTime[playerid] <= 297)
				{
					InjuredTime[playerid] = 60;

					if (IsPlayerInAnyVehicle(playerid)) 
						RemovePlayerFromVehicle(playerid);

					isDeathmode{playerid} = true;
				
					SendClientMessage(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ 60 วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme");
					SetPlayerChatBubble(playerid, "(( ผู้เล่นนี้ตายแล้ว ))", COLOR_LIGHTRED, 20.0, 1000);
					ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
				}
			}
			else
			{
				switch(weaponid)
				{
					case 4: amount = 30.0;
					case 8: amount = 35.0;
					case 5, 7: amount = 10.0;
					case 2, 3, 6, 1: amount = 15.0;
					case 22: amount = 20.0;
					case 23: amount = 25.0;
					case 28: amount = 15.0;
					case 30: amount = 40.0;
					case 31: amount = 35.0;
					case 24: amount = 45.0;
					// The spas shotguns shoot 8 bullets, each inflicting 4.95 damage
					case 27: 
					{
						new Float:bullets = amount / 4.950000286102294921875;
						if (8.0 - bullets < -0.05) {
							return 0;
						}
						amount = bullets * 8.95;
					}
					// Shotguns and sawed-off shotguns shoot 15 bullets, each inflicting 3.3 damage
					case 25, 26: 
					{
						new Float: bullets = amount / 3.30000019073486328125;
						if (15.0 - bullets < -0.05) {
							return 0;
						}
						amount = bullets * 7.3;
					}
					case 33: amount = 70.0;
					case 29: amount = 28.0;
					case 32: amount = 15.0;
					case 34: amount = 100.0;
				}
					
				switch(bodypart)
				{
					case 5,6,7,8: amount *= 0.8;
					case 9: amount *= 1.5;
				}

				new bool:nohp;
				if(armour > 0.0 && (bodypart == 3 || (GetPlayerSkin(playerid) == 285 && bodypart == 9)))
				{
					new Float:totalarmour;
					totalarmour = armour - amount;

					if(totalarmour > 0.0) SetPlayerArmour(playerid, totalarmour);
					else {
						SetPlayerArmour(playerid, 0.0);
						if((health+=totalarmour) > 0.0) {
							SetPlayerHealth(playerid,health);
						}
						else nohp = true;
					}
				}
				else {
					if((health-=amount) > 0.0) SetPlayerHealth(playerid,health);
					else nohp = true;
				}

				addPlayerDamage(playerid, issuerid, weaponid, amount, (armour > 0 && (bodypart == 3 || (GetPlayerSkin(playerid) == 285 && bodypart == 9))) ? true : false, bodypart); // S.W.A.T suit armour hit

				if(nohp) {
				
					ResetPlayerWeapons(playerid);

					InjuredTime[playerid] = 300;
					isInjuredmode{playerid} = true;
					SetPlayerHealth(playerid, 25.0);

					new countdamage;
					SendClientMessage(playerid, COLOR_LIGHTRED, "คุณได้รับบาดเจ็บอย่างรุนแรงตอนนี้ถ้าหากแพทย์ หรือใครก็ตามไม่สามารถช่วยคุณได้ คุณก็จะตาย");
					SendClientMessage(playerid, COLOR_LIGHTRED, "เพื่อยอมรับการตายพิมพ์ /acceptdeath");
					if((countdamage = countPlayerDamage(playerid)) != 0)
					{
						new damageString[64];
						format(damageString, sizeof(damageString), "(( ได้รับความบาดเจ็บ %d ครั้ง /damages %d เพื่อดูรายละเอียด ))", countdamage, playerid);
						SetPlayerChatBubble(playerid, damageString, 0xFF6347FF, 20.0, 60000);
						SendClientMessage(playerid, COLOR_LIGHTRED, damageString);
					}
					GameTextForPlayer(playerid, "~b~brutally wounded", 5000, 4);
					
					playerData[playerid][pInterior] = GetPlayerInterior(playerid);
					playerData[playerid][pVWorld] = GetPlayerVirtualWorld(playerid);
					GetPlayerPos(playerid, playerData[playerid][pPosX], playerData[playerid][pPosY], playerData[playerid][pPosZ]);
					GetPlayerFacingAngle(playerid, playerData[playerid][pPosA]);
					
					new vehicleid = GetPlayerVehicleID(playerid);

					if (vehicleid) {
						new modelid = GetVehicleModel(vehicleid);
						new seat = GetPlayerVehicleSeat(playerid);

						TogglePlayerControllable(playerid, false);

						switch (modelid) {
							case 509, 481, 510, 462, 448, 581, 522,
								461, 521, 523, 463, 586, 468, 471: {
								new Float:vx, Float:vy, Float:vz;
								GetVehicleVelocity(vehicleid, vx, vy, vz);

								if (vx*vx + vy*vy + vz*vz >= 0.4) {
									ApplyAnimation(playerid, "PED", "BIKE_fallR", 4.1, 1, 1, 0, 1, 0, 1);
								} else {
									ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 1, 1, 0, 1, 0, 1);
								}
							}

							default: {
								if (seat & 1) {
									ApplyAnimation(playerid, "PED", "CAR_dead_LHS", 4.1, 0, 0, 0, 1, 0, 1);
								} else {
									ApplyAnimation(playerid, "PED", "CAR_dead_RHS", 4.1, 0, 0, 0, 1, 0, 1);
								}
							}
						}
					} else {
			
						new anim = GetPlayerAnimationIndex(playerid);

						if (anim == 1250 || (1538 <= anim <= 1544) || weaponid == WEAPON_DROWN) {
							// In water
							ApplyAnimation(playerid, "PED", "Drown", 4.1, 0, 0, 0, 1, 0, 1);
							
						} else if (1195 <= anim <= 1198) {
							// Jumping animation
							ApplyAnimation(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0, 1);
						} else if (WEAPON_SHOTGUN <= weaponid <= WEAPON_SHOTGSPA) {
							if (IsPlayerBehindPlayer(issuerid, playerid)) {
								MakePlayerFacePlayer(playerid, issuerid, true);
								ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
							} else {
								MakePlayerFacePlayer(playerid, issuerid);
								ApplyAnimation(playerid, "PED", "BIKE_fall_off", 4.1, 0, 0, 0, 1, 0, 1);
							}
						} else if (WEAPON_RIFLE <= weaponid <= WEAPON_SNIPER) {
							if (bodypart == 9) {
								ApplyAnimation(playerid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0, 1);
							} else if (IsPlayerBehindPlayer(issuerid, playerid)) {
								ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
							} else {
								ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.1, 0, 0, 0, 1, 0, 1);
							}
						} else if (IsBulletWeapon(weaponid)) {
							if (bodypart == 9) {
								ApplyAnimation(playerid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0, 1);
							} else {
								ApplyAnimation(playerid, "PED", "KO_shot_front", 4.1, 0, 0, 0, 1, 0, 1);
							}
						} else if (weaponid == WEAPON_PISTOLWHIP) {
							ApplyAnimation(playerid, "PED", "KO_spin_R", 4.1, 0, 0, 0, 1, 0, 1);
						} else if (IsMeleeWeapon(weaponid) || weaponid == WEAPON_CARPARK) {
							ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 0, 0, 1, 0, 1);
						} else if (weaponid == WEAPON_SPRAYCAN || weaponid == WEAPON_FIREEXTINGUISHER) {
							ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 1, 0, 1);
						} else {
							ApplyAnimation(playerid, "PED", "KO_skid_back", 4.1, 0, 0, 0, 1, 0, 1);
						}
					}
				}
				else {
					if(IsBulletWeapon(weaponid)) {
						if(health <= 30.0)
						{
							SetPlayerWeaponSkill(playerid, NORMAL_SKILL);
							SendClientMessage(playerid, COLOR_LIGHTRED, "-> วิกฤตเลือดเหลือน้อย ทักษะการยิงอยู่ในระดับต่ำ");
						}
						else if(health <= 40.0)
						{
							SetPlayerWeaponSkill(playerid, MEDIUM_SKILL);
							SendClientMessage(playerid, COLOR_LIGHTRED, "-> วิกฤตเลือดเหลือน้อย ทักษะการยิงอยู่ในระดับปานกลาง");
						}
					}
				}
			}
			return 0;
		}
		else {
			return 0;
		}
	}

	if(health > 0.0 && amount > 0.0 && health-amount <= 0.0) {
		if(isInjuredmode{playerid}) isDeathmode{playerid}=true;
		else isInjuredmode{playerid}=true;
	}

	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if(!bf_get(player_bf[playerid], IS_LOGGED)) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ACCESS DENIED: {FFFFFF}คุณต้องเข้าสู่ระบบก่อนที่จะใช้คำสั่ง");
		return 0;
	}
    else if (!(flags & playerData[playerid][pCMDPermission]) && flags)
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "ACCESS DENIED: {FFFFFF}คุณไม่ได้รับอนุญาตให้ใช้คำสั่งนี้");
        return 0;
    }

    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendClientMessage(playerid, COLOR_LIGHTRED, "ERROR: {FFFFFF}เกิดข้อผิดพลาดในการใช้คำสั่ง");
        return 0;
    }

	if(flags) { // Permission CMD
		if (flags & playerData[playerid][pCMDPermission])
		{
			if(
				!strequal(cmd, "viewfactions", true) && 
				!strequal(cmd, "editveh", true)
			) {
				Log(a_action_log, INFO, "%s: /%s %s", ReturnPlayerName(playerid), cmd, params);
			}
		}
	}
    return 1;
}

public OnPlayerText(playerid, text[]) {

	if(!bf_get(player_bf[playerid], IS_LOGGED))
		return 0;

	if(isDeathmode{playerid} || isInjuredmode{playerid})
	{
	    SendClientMessage(playerid, COLOR_GRAD1, " คุณสลบและไม่สามารถพูดได้");
		return 0;
	}

	new str[144];
	new p_faction_id = playerData[playerid][pFactionID];

	if(p_faction_id != -1) {
		format(str, sizeof(str), ""EMBED_GRAD"[{%06x}%s"EMBED_GRAD"] {%06x}%s"EMBED_GRAD" พูดว่า: %s", factionData[p_faction_id][fColor], Faction_GetName(playerid), GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), text);
	}
	else format(str, sizeof(str), "{%06x}%s"EMBED_GRAD" พูดว่า: %s", GetPlayerColor(playerid) >>> 8, ReturnPlayerName(playerid), text);

	ProxDetector(playerid, 20.0, str);
	ChatAnimation(playerid, strlen(text));

	return 0;
}