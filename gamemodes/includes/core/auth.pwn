/*
//--------------------------------[AUTH.PWN]--------------------------------
*/
#include <YSI\y_hooks>

hook OP_RequestClass(playerid, classid)
{
	TogglePlayerSpectating(playerid, true);
	SetPlayerColor(playerid, COLOR_GRAD1);
	
	if (!bf_get(player_bf[playerid], IS_LOGGED))
	{
		SetTimerEx("LoginScreen", 400, 0, "i", playerid);
	}
	else {
	    SpawnPlayer(playerid);
	}
	
	return 1;
}

forward LoginScreen(playerid);
public LoginScreen(playerid)
{
	if(IsPlayerConnected(playerid)) {

	    switch(random(5))
	    {
			case 0:
			{
				InterpolateCameraPos(playerid, 1515.2737,-1665.1134,30.8490, 1457.7661,-1648.8522,84.2313, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1554.5918,-1675.5037,16.1953, 1518.7808,-1740.4697,13.5469, 20000, CAMERA_MOVE);
			}
			case 1:
			{
				InterpolateCameraPos(playerid, 211.1743,-1964.6896,25.8913, 197.4750,-1931.2467,15.9717, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 154.8850,-1980.1570,-1.3705, 139.8383,-1941.7241,-1.9266, 20000, CAMERA_MOVE);
			}
			case 2:
			{
				InterpolateCameraPos(playerid, 1919.1664,-1727.6240,47.0318, 1972.3707,-1748.2458,47.0318, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1939.9507,-1780.5978,13.3906, 1939.9507,-1780.5978,13.3906, 20000, CAMERA_MOVE);
			}
			case 3:
			{
				InterpolateCameraPos(playerid, 2080.5361,-1824.4825,13.3828, 2082.2178,-1781.4225,13.3828, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 2103.5410,-1806.7010,13.3828, 2103.5410,-1806.7010,13.3828, 20000, CAMERA_MOVE);
			}
			case 4:
			{
				InterpolateCameraPos(playerid, 944.4015,-2283.3127,62.0990, 979.8951,-2167.8540,62.0990, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1086.8553,-2293.2737,43.6042, 1082.9528,-2232.9998,52.3210, 20000, CAMERA_MOVE);
			}
		}

		new query[128];
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		mysql_format(dbCon, query, sizeof(query), "SELECT id FROM players WHERE LOWER(name) = LOWER('%e') LIMIT 1", name);
		mysql_query(dbCon, query);

		if(!cache_num_rows())
		{
            SendClientMessage(playerid, -1, "{FFFF00}เซิร์ฟเวอร์:{FFFFFF} คุณจำเป็นต้องลงทะเบียนก่อนเข้าเล่นเซิร์ฟเวอร์ของเรา !!");
            SendClientMessage(playerid, -1, "{FFFF00}เซิร์ฟเวอร์:{FFFFFF} โปรดกรอกรหัสผ่านในกล่องดำด้านล่างนี้");
            PlayerPlaySound(playerid, 1185, 0.0, 0.0, 0.0);
            Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "การลงทะเบียน","{FF0000}Keki Project{FFFFFF}\n\n{FFFF00}ชื่อตัวละคร:{FFFFFF} %s \n{FFFF00}ไอพี:{FFFFFF} %s\n \nตั้งรหัสผ่านอย่างน้อยไม่ต่ำกว่า {FFFF00}6{FFFFFF} ตัวอักษร และไม่เกิน {FFFF00}12{FFFFFF} ตัวอักษร\n \nโปรดกรอก {FFFF00}รหัสผ่าน{FFFFFF} ของคุณในกล่องด้านล่างนี้:","ลงทะเบียน","ออกจากเกมส์", ReturnPlayerName(playerid),playerData[playerid][pIP]);
		}
		else
		{
			cache_get_value_index_int(0, 0, playerData[playerid][pSQLID]);

            SendClientMessage(playerid, -1, "{FFFF00}เซิร์ฟเวอร์:{FFFFFF} ตัวละครนี้ได้รับการลงทะเบียนเรียบร้อยแล้ว !!");
            SendClientMessage(playerid, -1, "{FFFF00}เซิร์ฟเวอร์:{FFFFFF} โปรดกรอกรหัสผ่านในกล่องดำด้านล่างนี้");
            PlayerPlaySound(playerid, 1185, 0.0, 0.0, 0.0);
            Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "การเข้าสู่ระบบ","{FF0000}Keki Project{FFFFFF}\n\n{FFFF00}ชื่อตัวละคร:{FFFFFF} %s \n{FFFF00}ไอพี:{FFFFFF} %s\n\nโปรดกรอก {FFFF00}รหัสผ่าน{FFFFFF} ของคุณในกล่องด้านล่างนี้:","เข้าสู่ระบบ","ออกจากเกมส์", ReturnPlayerName(playerid),playerData[playerid][pIP]);
		}	
	}
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[]) {
	if(!response)
	{
		Kick(playerid);
		return 1;
	}
	if(!strlen(inputtext)) {
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "การลงทะเบียน","{FF0000}Keki Project{FFFFFF}\n\n{FFFF00}ชื่อตัวละคร:{FFFFFF} %s \n{FFFF00}ไอพี:{FFFFFF} %s\n \nตั้งรหัสผ่านอย่างน้อยไม่ต่ำกว่า {FFFF00}6{FFFFFF} ตัวอักษร และไม่เกิน {FFFF00}12{FFFFFF} ตัวอักษร\n \nโปรดกรอก {FFFF00}รหัสผ่าน{FFFFFF} ของคุณในกล่องด้านล่างนี้:","ลงทะเบียน","ออกจากเกมส์", ReturnPlayerName(playerid),playerData[playerid][pIP]);
		return 1;
	}

	new query[256], buffer[129];
	WP_Hash(buffer, sizeof(buffer), inputtext);
	mysql_format(dbCon, query, sizeof(query), "INSERT INTO `players` (`name`, `pass`) VALUES ('%e', '%s')", ReturnPlayerName(playerid), buffer);
	mysql_query(dbCon, query);
	playerData[playerid][pSQLID] = cache_insert_id();

	OnAccountUpdate(playerid, true);
	Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "การเข้าสู่ระบบ","{FF0000}Keki Project{FFFFFF}\n\n{FFFF00}ชื่อตัวละคร:{FFFFFF} %s \n{FFFF00}ไอพี:{FFFFFF} %s\n\nโปรดกรอก {FFFF00}รหัสผ่าน{FFFFFF} ของคุณในกล่องด้านล่างนี้:","เข้าสู่ระบบ","ออกจากเกมส์", ReturnPlayerName(playerid),playerData[playerid][pIP]);
	return 1;
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[]) {
	if(!response)
	{
		Kick(playerid);
		return 1;
	}

	if(!strlen(inputtext)) {
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "การเข้าสู่ระบบ","{FF0000}Keki Project{FFFFFF}\n\n{FFFF00}ชื่อตัวละคร:{FFFFFF} %s \n{FFFF00}ไอพี:{FFFFFF} %s\n\nโปรดกรอก {FFFF00}รหัสผ่าน{FFFFFF} ของคุณในกล่องด้านล่างนี้:","เข้าสู่ระบบ","ออกจากเกมส์", ReturnPlayerName(playerid),playerData[playerid][pIP]);
		return 1;
	}
	
	new 
		aQuery[256],
		buffer[129]
    ;
    WP_Hash(buffer, sizeof(buffer), inputtext);

	format(aQuery,sizeof(aQuery), "SELECT * FROM `players` WHERE `id` = '%d' AND `pass` = '%s'", playerData[playerid][pSQLID], buffer);
	mysql_query(dbCon,aQuery);

	if(cache_num_rows())
	{
		new temp_int, isCreated;
		cache_get_value_name_int(0, "phonenumber",playerData[playerid][pPnumber]);
		cache_get_value_name_int(0, "level",playerData[playerid][pLevel]);
       	cache_get_value_name_int(0, "model",playerData[playerid][pModel]);
       	cache_get_value_name_int(0, "cash",playerData[playerid][pCash]);
       	cache_get_value_name_int(0, "donaterank",playerData[playerid][pDonateRank]);
       	cache_get_value_name_float(0, "armour",playerData[playerid][pArmour]);
       	cache_get_value_name_float(0, "health",playerData[playerid][pHealth]);
       	cache_get_value_name_float(0, "shealth",playerData[playerid][pSHealth]);
       	cache_get_value_name_int(0, "interior",playerData[playerid][pInterior]);
       	cache_get_value_name_int(0, "vworld",playerData[playerid][pVWorld]);
       	cache_get_value_name_int(0, "spawntype",playerData[playerid][pSpawnType]);
       	cache_get_value_name_int(0, "medicbill", temp_int);
		SetPVarInt(playerid, "MedicBill", temp_int);
       	cache_get_value_name_float(0, "posx",playerData[playerid][pPosX]);
       	cache_get_value_name_float(0, "posy",playerData[playerid][pPosY]);
       	cache_get_value_name_float(0, "posz",playerData[playerid][pPosZ]);
       	cache_get_value_name_float(0, "posa",playerData[playerid][pPosA]);
       	cache_get_value_name_int(0, "admin",playerData[playerid][pAdmin]);
		cache_get_value_name_int(0, "created", isCreated);
		cache_get_value_name_int(0, "faction",playerData[playerid][pFaction]);
		cache_get_value_name_int(0, "faction_rank",playerData[playerid][pFactionRank]);

		ResetPlayerMoney(playerid);

		if(isCreated) {
			playerData[playerid][pLevel] = 1;
			playerData[playerid][pCash] = 5000;
			playerData[playerid][pArmour] = 0.0;
			playerData[playerid][pHealth] = 50.0;
			playerData[playerid][pSHealth] = 0.0;

			format(aQuery,sizeof(aQuery), "UPDATE `players` SET `created` = 1 WHERE `id` = %d", playerData[playerid][pSQLID]);
			mysql_tquery(dbCon,aQuery);
		}
		new str[144];
		bf_on(player_bf[playerid], IS_LOGGED);
		format(str, sizeof(str), "ยินดีต้อนรับคุณ %s", ReturnPlayerName(playerid));
		SendClientMessage(playerid, -1, str);
		format(str, sizeof(str), "~w~Welcome ~n~~r~   %s", ReturnPlayerName(playerid));
		GameTextForPlayer(playerid, str, 5000, 1);

		GivePlayerMoney(playerid, playerData[playerid][pCash]);

		bf_on(player_bf[playerid], IS_LOGGED);

		switch(playerData[playerid][pAdmin]) {
			case 1: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM1;
			}
			case 2: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM1 | CMD_ADM2;
			}
			case 3: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM1 | CMD_ADM2 | CMD_ADM3;
			}
			case 4: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM1 | CMD_ADM2 | CMD_ADM3 | CMD_LEAD;
			}
			case 5: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM1 | CMD_ADM2 | CMD_ADM3 | CMD_LEAD | CMD_MM;
			}
			case 6: {
				playerData[playerid][pCMDPermission] = CMD_TESTER | CMD_ADM1 | CMD_ADM2 | CMD_ADM3 | CMD_LEAD | CMD_MM | CMD_DEV;
			}
		}

		if(playerData[playerid][pFaction] != 0) {
			foreach(new i : Iter_Faction) {
				if(factionData[i][fID] == playerData[playerid][pFaction]) {
					playerData[playerid][pFactionID] = i;
				}
			}
		}

		SetPlayerScore(playerid, playerData[playerid][pLevel]);

		SetPlayerTeam(playerid, 1);
		SetSpawnInfo(playerid, 1, playerData[playerid][pModel], 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
		//SetPlayerSkin(playerid, playerData[playerid][pModel]);
		SpawnPlayer(playerid);
		return 1;
	}
	else {
		SetPVarInt(playerid, "logginFailed", GetPVarInt(playerid, "logginFailed")+1);
		if(GetPVarInt(playerid, "logginFailed") >= 5) {
			SendClientMessage(playerid, -1, "{FFFF00}เซิร์ฟเวอร์:{FFFFFF} คุณถูกเตะเนื่องจากกรอกรหัสผ่านผิดมากเกินไป");
			KickEx(playerid);
			return 1;
		}

    	Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "การเข้าสู่ระบบ","{FF0000}Keki Project{FFFFFF}\n\n{FFFF00}ชื่อตัวละคร:{FFFFFF} %s \n{FFFF00}ไอพี:{FFFFFF} %s\n\n{FF0000}รหัสผ่านไม่ถูกต้อง คุณสามารถกรอกรหัสผ่านได้อีก {FFFFFF}%d{FF0000} ครั้ง","เข้าสู่ระบบ","ออกจากเกมส์", ReturnPlayerName(playerid),playerData[playerid][pIP], 5 - GetPVarInt(playerid, "logginFailed"));
	}
	return 1;
}

stock OnAccountUpdate(playerid, bool:force = false, thread = MYSQL_UPDATE_TYPE_THREAD)
{
	if(bf_get(player_bf[playerid], IS_LOGGED) || force)
	{
		new query[MAX_STRING];
		MySQLUpdateInit("players", "id", playerData[playerid][pSQLID], thread); 
		MySQLUpdateInt(query, "phonenumber",playerData[playerid][pPnumber]);
		MySQLUpdateInt(query, "level",playerData[playerid][pLevel]);
 	    MySQLUpdateInt(query, "model",playerData[playerid][pModel]);
 	    MySQLUpdateInt(query, "cash",playerData[playerid][pCash]);
 	    MySQLUpdateInt(query, "donaterank",playerData[playerid][pDonateRank]);
 	    MySQLUpdateFlo(query, "armour",playerData[playerid][pArmour]);
 	    MySQLUpdateFlo(query, "health",playerData[playerid][pHealth]);
 	    MySQLUpdateFlo(query, "shealth",playerData[playerid][pSHealth]);
 	    MySQLUpdateInt(query, "interior",playerData[playerid][pInterior]);
 	    MySQLUpdateInt(query, "vworld",playerData[playerid][pVWorld]);
 	    MySQLUpdateInt(query, "spawntype",playerData[playerid][pSpawnType]);
 	    MySQLUpdateInt(query, "medicbill", GetPVarInt(playerid, "MedicBill"));
 	    MySQLUpdateFlo(query, "posx",playerData[playerid][pPosX]);
 	    MySQLUpdateFlo(query, "posy",playerData[playerid][pPosY]);
 	    MySQLUpdateFlo(query, "posz",playerData[playerid][pPosZ]);
 	    MySQLUpdateFlo(query, "posa",playerData[playerid][pPosA]);
 	    MySQLUpdateInt(query, "admin",playerData[playerid][pAdmin]);
		MySQLUpdateInt(query, "faction",playerData[playerid][pFaction]);
		MySQLUpdateInt(query, "faction_rank",playerData[playerid][pFactionRank]);
		MySQLUpdateFinish(query);
	}
	return 1;
}

/*
stock MySQLUpdatePlayerIntSingle(sqlplayerid, sqlvalname[], sqlupdateint) // by Aktah
{
	new query[128];
	format(query, sizeof(query), "UPDATE players SET `%s`=%d WHERE `id`=%d", sqlvalname, sqlupdateint, sqlplayerid);
	mysql_query(dbCon, query);
	return 1;
}

stock MySQLCheckAccount(sqlplayersname[]) // by Aktah
{
	new int_dest, query[128];
	mysql_format(dbCon, query, sizeof(query), "SELECT `id` FROM `players` WHERE LOWER(`name`) = LOWER('%e') LIMIT 1", sqlplayersname);
	mysql_query(dbCon, query);

	if(cache_num_rows())
	{
	    cache_get_value_index_int(0, 0, int_dest);
	}
	return int_dest;
}*/