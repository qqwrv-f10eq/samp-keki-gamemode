stock SetPlayerHealthEx(playerid, Float:hp)
{
	if(hp <= 30) SetPlayerWeaponSkill(playerid, NORMAL_SKILL);
 	else if(hp <= 40) SetPlayerWeaponSkill(playerid, MEDIUM_SKILL);
	else SetPlayerWeaponSkill(playerid, FULL_SKILL);

	playerData[playerid][pHealth] = hp;
	return SetPlayerHealth(playerid, hp);
}

#if defined _ALS_SetPlayerHealth
  #undef SetPlayerHealth
#else
#define _ALS_SetPlayerHealth
#endif

#define SetPlayerHealth SetPlayerHealthEx

stock SetPlayerArmourEx(playerid, Float:hp)
{
	playerData[playerid][pArmour] = hp;
	return SetPlayerArmour(playerid, hp);
}

#if defined _ALS_SetPlayerArmour
  #undef SetPlayerArmour
#else
#define _ALS_SetPlayerArmour
#endif

#define SetPlayerArmour SetPlayerArmourEx

stock GetPlayerMoneyEx(playerid)
{
	return playerData[playerid][pCash];
}

#if defined _ALS_GetPlayerMoney
  #undef GetPlayerMoney
#else
#define _ALS_GetPlayerMoney
#endif

#define GetPlayerMoney GetPlayerMoneyEx