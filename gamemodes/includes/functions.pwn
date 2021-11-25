//--------------------------------[FUNCTIONS.PWN]--------------------------------
/*
	- Weapon Function
	- Player Function
	- Vehicle Function
	- MATH
	- DATE/TIME
	- Message
	- Regex
	- MySQL
*/

stock ClearChatBox(playerid) for (new i = 0; i < 100; i ++) SendClientMessage(playerid, -1, "");

stock RemoveFromVehicle(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		new
		    Float:fX,
	    	Float:fY,
	    	Float:fZ;

		GetPlayerPos(playerid, fX, fY, fZ);
		SetPlayerPos(playerid, fX, fY, fZ + 1.5);
	}
	return 1;
}

//=========================== [ Weapon Function ] ========================

stock ReturnWeaponNameEx(weaponid)
{
	new
		name[24];
		
	switch(weaponid) {
		case 0: name = "Punch";
		case 30: name = "AK-47";
		default: {
			GetWeaponName(weaponid, name, sizeof(name));	
		}
	}
	return name;
}

stock ReturnFactionWeaponName(weaponid)
{
	static
		name[24];

	if (weaponid == 100) {
	    name = "Health";
	}
	else if (weaponid == 200) {
	    name = "Armour";
	}
	else {
		if (weaponid == 0) name = "ÇèÒ§";
		else GetWeaponName(weaponid, name, sizeof(name));
	}
	return name;
}

stock IsBulletWeapon(weaponid)
{
	return (WEAPON_COLT45 <= weaponid <= WEAPON_SNIPER) || weaponid == WEAPON_MINIGUN;
}

stock IsMeleeWeapon(weaponid)
{
	return (WEAPON_UNARMED <= weaponid <= WEAPON_KATANA) || (WEAPON_DILDO <= weaponid <= WEAPON_CANE) || weaponid == WEAPON_PISTOLWHIP;
}

stock SetPlayerWeaponSkill(playerid, skill) {
	switch(skill) {
	    case NORMAL_SKILL: {
            for(new i = 0; i != 11;++i) SetPlayerSkillLevel(playerid, i, 200);
            SetPlayerSkillLevel(playerid, 0, 40);
            SetPlayerSkillLevel(playerid, 6, 50);
	    }
	    case MEDIUM_SKILL: {
            for(new i = 0; i != 11;++i) SetPlayerSkillLevel(playerid, i, 500);
            SetPlayerSkillLevel(playerid, 0, 500);
            SetPlayerSkillLevel(playerid, 6, 500);
	    }
	    case FULL_SKILL: {
            for(new i = 0; i != 11;++i) SetPlayerSkillLevel(playerid, i, 999);
            SetPlayerSkillLevel(playerid, 0, 998);
            SetPlayerSkillLevel(playerid, 6, 998);
	    }
	}
}
//=========================== [ Weapon Function ] ========================

//=========================== [ Vehicle Function ] ========================

ReturnVehicleModelName(model)
{
	new
	    name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

GetVehicleModelByName(const name[])
{
	if (IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
	    return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
	    if (strfind(g_arrVehicleNames[i], name, true) != -1)
	    {
	        return i + 400;
		}
	}
	return 0;
}
//=========================== [ Vehicle Function ] ========================

//=========================== [ Player Function ] ========================
stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid) && playerData[targetid][pSpectating] == INVALID_PLAYER_ID) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock Float:AngleBetweenPoints(Float:x1, Float:y1, Float:x2, Float:y2)
{
	return -(90.0 - atan2(y1 - y2, x1 - x2));
}

stock MakePlayerFacePlayer(playerid, targetid, opposite = false)
{
	new Float:x1, Float:y1, Float:z1;
	new Float:x2, Float:y2, Float:z2;

	GetPlayerPos(playerid, x1, y1, z1);
	GetPlayerPos(targetid, x2, y2, z2);
	new Float:angle = AngleBetweenPoints(x2, y2, x1, y1);

	if (opposite) {
		angle += 180.0;
		if (angle > 360.0) angle -= 360.0;
	}

	if (angle < 0.0) angle += 360.0;
	if (angle > 360.0) angle -= 360.0;

	SetPlayerFacingAngle(playerid, angle);
}

stock IsPlayerBehindPlayer(playerid, targetid, Float:diff = 90.0)
{
	new Float:x1, Float:y1, Float:z1;
	new Float:x2, Float:y2, Float:z2;
	new Float:ang, Float:angdiff;

	GetPlayerPos(playerid, x1, y1, z1);
	GetPlayerPos(targetid, x2, y2, z2);
	GetPlayerFacingAngle(targetid, ang);

	angdiff = AngleBetweenPoints(x1, y1, x2, y2);

	if (angdiff < 0.0) angdiff += 360.0;
	if (angdiff > 360.0) angdiff -= 360.0;

	ang = ang - angdiff;

	if (ang > 180.0) ang -= 360.0;
	if (ang < -180.0) ang += 360.0;

	return floatabs(ang) > diff;
}

stock ProxDetector(playerid, Float:radius, const str[])
{
	new Float:posx, Float:posy, Float:posz;
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;

	GetPlayerPos(playerid, oldposx, oldposy, oldposz);

	foreach (new i : Player)
	{
		if(GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
		{
			GetPlayerPos(i, posx, posy, posz);
			tempposx = (oldposx -posx);
			tempposy = (oldposy -posy);
			tempposz = (oldposz -posz);

			if (((tempposx < radius/16) && (tempposx > -radius/16)) && ((tempposy < radius/16) && (tempposy > -radius/16)) && ((tempposz < radius/16) && (tempposz > -radius/16)))
			{
				SendClientMessage(i, COLOR_GRAD1, str);
			}
			else if (((tempposx < radius/8) && (tempposx > -radius/8)) && ((tempposy < radius/8) && (tempposy > -radius/8)) && ((tempposz < radius/8) && (tempposz > -radius/8)))
			{
				SendClientMessage(i, COLOR_GRAD2, str);
			}
			else if (((tempposx < radius/4) && (tempposx > -radius/4)) && ((tempposy < radius/4) && (tempposy > -radius/4)) && ((tempposz < radius/4) && (tempposz > -radius/4)))
			{
				SendClientMessage(i, COLOR_GRAD3, str);
			}
			else if (((tempposx < radius/2) && (tempposx > -radius/2)) && ((tempposy < radius/2) && (tempposy > -radius/2)) && ((tempposz < radius/2) && (tempposz > -radius/2)))
			{
				SendClientMessage(i, COLOR_GRAD4, str);
			}
			else if (((tempposx < radius) && (tempposx > -radius)) && ((tempposy < radius) && (tempposy > -radius)) && ((tempposz < radius) && (tempposz > -radius)))
			{
				SendClientMessage(i, COLOR_GRAD5, str);
			}
		}
	}
	return 1;
}

stock ChatAnimation(playerid, length)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !playingAnimation{playerid})
	{
		if(isDeathmode{playerid} || isInjuredmode{playerid} || IsPlayerInAnyVehicle(playerid) || GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE) return 1;

		new chatstyle = playerData[playerid][pTalkStyle];
		playingAnimation{playerid}=true;
		if(chatstyle == 0) { ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,1,0,0,1,1); }
		else if(chatstyle == 1) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkA",4.1,1,0,0,1,1); }
		else if(chatstyle == 2) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkB",4.1,1,0,0,1,1); }
		else if(chatstyle == 3) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkC",4.1,1,0,0,1,1);}
		else if(chatstyle == 4) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkD",4.1,1,0,0,1,1);}
		else if(chatstyle == 5) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkE",4.1,1,0,0,1,1);}
		else if(chatstyle == 6) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkF",4.1,1,0,0,1,1);}
		else if(chatstyle == 7) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkG",4.1,1,0,0,1,1);}
		else if(chatstyle == 8) { ApplyAnimation(playerid,"GANGS","prtial_gngtlkH",4.1,1,0,0,1,1);}
		SetTimerEx("StopChatting", floatround(length)*100, 0, "i", playerid);
	}
	return 1;
}

forward StopChatting(playerid);
public StopChatting(playerid) ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0), playingAnimation{playerid}=false;

//=========================== [ Player Function ] ========================

stock GetBodyPartName(bodypart)
{
	new part[11];
	switch(bodypart)
	{
		case BODY_PART_TORSO: part = "ÅÓµÑÇ";
		case BODY_PART_GROIN: part = "¢ÒË¹Õº";
		case BODY_PART_LEFT_ARM: part = "á¢¹«éÒÂ";
		case BODY_PART_RIGHT_ARM: part = "á¢¹¢ÇÒ";
		case BODY_PART_LEFT_LEG: part = "¢Ò«éÒÂ";
		case BODY_PART_RIGHT_LEG: part = "¢Ò¢ÇÒ";
		case BODY_PART_HEAD: part = "ËÑÇ";
		default: part = "äÁè·ÃÒº";
	}
	return part;
}

stock GetDynamicPlayerPos(playerid, &Float:x, &Float:y, &Float:z)
{
	new world = GetPlayerVirtualWorld(playerid);
	if(world == 0)
	{
	    GetPlayerPos(playerid, x, y, z);
	}
	else
	{
		/* House & Business, HQ Faction... */
		GetPlayerPos(playerid, x, y, z);
	}
	return 1;
}

//==================== [ MATH ] ==========================
stock IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

stock Float:GetPointDistanceToPoint(Float:x1,Float:y1,Float:x2,Float:y2)
{
  new Float:x, Float:y;
  x = x1-x2;
  y = y1-y2;
  return floatsqroot(x*x+y*y);
}

//==================== [ DATE/TIME ] ==========================

stock ReturnDateTime(type = 0)
{
 	new
	    szDay[80],
		date[6];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	switch(type) {
		case 0: format(szDay, sizeof(szDay), "%02d %s ¾.È %d àÇÅÒ %02d:%02d:%02d", date[0], MonthDay[date[1] - 1], date[2]+543, date[3], date[4], date[5]);
		case 1: format(szDay, sizeof(szDay), "%02d-%02d-%d %02d:%02d", date[0], date[1], date[2]+543, date[3], date[4]);
		case 2: format(szDay, sizeof(szDay), "%02d %s %d àÇÅÒ %02d:%02d", date[0], szMonthDay[date[1] - 1], date[2]+543, date[3], date[4]);
	}

	return szDay;
}

//==================== [ Message ] ==========================
stock SendNearbyMessage(playerid, Float:radius, color, const fmat[],  va_args<>)
{
	new
		str[145];
	va_format(str, sizeof (str), fmat, va_start<4>);

	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}

	return 1;
}

stock SendAdminMessage(color, const fmat[],  va_args<>)
{
	new
		str[145];
	va_format(str, sizeof (str), fmat, va_start<2>);

	foreach (new i : Player)
	{
		if (playerData[i][pAdmin]) {
			SendClientMessage(i, color, str);
		}
	}

	return 1;
}

stock SendFormatMessage(playerid, color, const fmat[],  va_args<>)
{
	new
		str[145];
	va_format(str, sizeof (str), fmat, va_start<3>);

	return SendClientMessage(playerid, color, str);
}

stock SendFormatMessageToAll(color, const fmat[],  va_args<>)
{
	new
		str[145];
	va_format(str, sizeof (str), fmat, va_start<2>);

	return SendClientMessageToAll(color, str);
}
//==================== [ Regex ] ==========================
/*
stock IsEnglishAndNumber(nickname[])
{
    new Regex:r = Regex_New("[a-zA-Z0-9 _]+");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}*/

//==================== [ MySQL Function ] ==========================

#define MYSQL_MAX_STRING			255
#define MYSQL_UPDATE_TYPE_SINGLE	0
#define MYSQL_UPDATE_TYPE_THREAD	1

#define MYSQL_UPDATE_QUERY(%0,%1)              			\
    if(gUpdateThreadType) { mysql_query(%0, %1); }		\
	else mysql_tquery(%0, %1)

static 
	gUpdateTableName[MYSQL_MAX_STRING],
	gUpdateColumnName[MYSQL_MAX_STRING],
	gUpdateRowID,
	gUpdateThreadType;

stock MySQLUpdateInit(const table_name[], const column_name[], row_id, type = MYSQL_UPDATE_TYPE_SINGLE) {
	format(gUpdateTableName, MYSQL_MAX_STRING, table_name);
	format(gUpdateColumnName, MYSQL_MAX_STRING, column_name);
	gUpdateRowID = row_id;
	gUpdateThreadType = type;
}

static stock MySQLUpdateBuild(query[]) 
{
	new queryLen = strlen(query), whereclause[MYSQL_MAX_STRING], queryMax = MAX_STRING;
	if (queryLen < 1) format(query, queryMax, "UPDATE `%s` SET ", gUpdateTableName);
	else if (queryMax-queryLen < 80) // make sure we're being safe here
	{
		// query is too large, send this one and reset
		format(whereclause, MYSQL_MAX_STRING, " WHERE `%s`=%d", gUpdateColumnName, gUpdateRowID); // 60
		strcat(query, whereclause, queryMax);

		MYSQL_UPDATE_QUERY(dbCon, query);

		format(query, queryMax, "UPDATE `%s` SET ", gUpdateTableName);
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", MAX_STRING);
	return 1;
}

stock MySQLUpdateFinish(query[]) 
{
	new whereclause[MYSQL_MAX_STRING];
	format(whereclause, MYSQL_MAX_STRING, "WHERE `%s`=", gUpdateColumnName);
	if (strcmp(query, whereclause, false) == 0) {
		MYSQL_UPDATE_QUERY(dbCon, query);
	}
	else
	{
		format(whereclause, MYSQL_MAX_STRING, " WHERE `%s`=%d", gUpdateColumnName, gUpdateRowID);
		strcat(query, whereclause, MAX_STRING);

		MYSQL_UPDATE_QUERY(dbCon, query);

		gUpdateTableName[0] = '\0';
		gUpdateColumnName[0] = '\0';
		gUpdateRowID = 0;
		gUpdateThreadType = MYSQL_UPDATE_TYPE_SINGLE;
	}
	return 1;
}

stock MySQLUpdateInt(query[], const sqlvalname[], sqlupdateint) 
{
	MySQLUpdateBuild(query);
	strcat(query, sprintf("`%s`=%d", sqlvalname, sqlupdateint), MAX_STRING);
	return 1;
}

stock MySQLUpdateBool(query[], const sqlvalname[], bool:sqlupdatebool) 
{
	MySQLUpdateBuild(query);
	strcat(query, sprintf("`%s`=%d", sqlvalname, sqlupdatebool), MAX_STRING);
	return 1;
}

stock MySQLUpdateFlo(query[], const sqlvalname[], Float:sqlupdateflo) 
{
	MySQLUpdateBuild(query);
	strcat(query, sprintf("`%s`=%f", sqlvalname, sqlupdateflo), MAX_STRING);
	return 1;
}

stock MySQLUpdateStr(query[], const sqlvalname[], const sqlupdatestr[]) 
{
	MySQLUpdateBuild(query);
	new updval[128];
	mysql_format(dbCon, updval
