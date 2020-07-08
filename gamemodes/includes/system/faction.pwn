#include <YSI\y_hooks>

#define FACTION_POLICE		1
#define FACTION_MEDIC		2
#define FACTION_NEWS		3
#define FACTION_ILLEGAL		4

new FillupDelay[MAX_PLAYERS];

forward Faction_Load();
public Faction_Load() {

    new
	    rows, str[8];

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_FACTIONS)
	{
        cache_get_value_name_int(i, "id", factionData[i][fID]);
        cache_get_value_name(i, "name", factionData[i][fName], 60);
        cache_get_value_name(i, "short_name", factionData[i][fShortName], 15);
        cache_get_value_name_int(i, "type", factionData[i][fType]);
        cache_get_value_name_int(i, "color", factionData[i][fColor]);
        cache_get_value_name_float(i, "spawnX", factionData[i][fSpawnX]);
        cache_get_value_name_float(i, "spawnY", factionData[i][fSpawnY]);
        cache_get_value_name_float(i, "spawnZ", factionData[i][fSpawnZ]);
        cache_get_value_name_int(i, "spawnInt", factionData[i][fSpawnInt]);
        cache_get_value_name_int(i, "spawnWorld", factionData[i][fSpawnWorld]);
        cache_get_value_name_int(i, "cash", factionData[i][fCash]);

        cache_get_value_name_int(i, "max_skin", factionData[i][fMaxSkins]);
        cache_get_value_name_int(i, "max_rank", factionData[i][fMaxRanks]);
        cache_get_value_name_int(i, "max_veh", factionData[i][fMaxVehicles]);

		if(factionData[i][fSpawnX] != 0.0 && factionData[i][fSpawnY] != 0.0) {
			Faction_SpawnUpdate(i);
		}

		for (new j = 0; j != MAX_FACTION_RANKS; j ++) {
		    format(str, sizeof(str), "rank%d", j);
		    cache_get_value_name(i, str, factionRanks[i][j], 30);
		}

		for (new j = 0; j != MAX_FACTION_SKINS; j ++) {
		    format(str, sizeof(str), "skin%d", j + 1);
		    cache_get_value_name_int(i, str, factionSkins[i][j]);
		}

		for (new j = 0; j != MAX_FACTION_WEAPONS; j ++) {
		    format(str, sizeof(str), "weapon%d", j + 1);
		    cache_get_value_name_int(i, str, factionWeapons[i][j][0]);

		    format(str, sizeof(str), "ammo%d", j + 1);
		    cache_get_value_name_int(i, str, factionWeapons[i][j][1]);
		}

        factionData[i][fOOC] = false;

        Iter_Add(Iter_Faction, i);
	}

    printf("Faction loaded (%d/%d)", Iter_Count(Iter_Faction), MAX_FACTIONS);
	return 1;
}

Faction_Save(id=-1) {
    if(Iter_Contains(Iter_Faction, id)) {
        /*new query[300];
        mysql_format(dbCon, query, sizeof(query), "UPDATE `faction` SET `name`='%e',`short_name`='%e',`type`=%d,`color`=%d,`spawnX`='%f',`spawnY`='%f',`spawnZ`='%f',`spawnA`='%f',`spawnInt`='%d',`spawnWorld`= %d,`cash`=%d,`max_skin`=%d,`max_rank`=%d,`max_veh`=%d WHERE `id`=%d",
            factionData[id][fName],
            factionData[id][fShortName],
            factionData[id][fType],
            factionData[id][fColor],
            factionData[id][fSpawnX],
            factionData[id][fSpawnY],
            factionData[id][fSpawnZ],
			factionData[id][fSpawnA],
            factionData[id][fSpawnInt],
            factionData[id][fSpawnWorld],
            factionData[id][fCash],
            factionData[id][fMaxSkins],
            factionData[id][fMaxRanks],
            factionData[id][fMaxVehicles],
            factionData[id][fID]
        );
        mysql_tquery(dbCon, query);*/

        new query[MAX_STRING];
        MySQLUpdateInit("faction", "id", factionData[id][fID]); 
        MySQLUpdateStr(query, "name", factionData[id][fName]);
        MySQLUpdateStr(query, "short_name", factionData[id][fShortName]);
        MySQLUpdateInt(query, "type", factionData[id][fType]);
        MySQLUpdateInt(query, "color", factionData[id][fColor]);
        MySQLUpdateFlo(query, "spawnX", factionData[id][fSpawnX]);
        MySQLUpdateFlo(query, "spawnY", factionData[id][fSpawnY]);
        MySQLUpdateFlo(query, "spawnZ", factionData[id][fSpawnZ]);
        MySQLUpdateFlo(query, "spawnA", factionData[id][fSpawnA]);
        MySQLUpdateInt(query, "spawnInt", factionData[id][fSpawnInt]);
        MySQLUpdateInt(query, "spawnWorld", factionData[id][fSpawnWorld]);
        MySQLUpdateInt(query, "cash", factionData[id][fCash]);
        MySQLUpdateInt(query, "max_skin", factionData[id][fMaxSkins]);
        MySQLUpdateInt(query, "max_rank", factionData[id][fMaxRanks]);
        MySQLUpdateInt(query, "max_veh", factionData[id][fMaxVehicles]);
		MySQLUpdateFinish(query);
    }
    return 1;
}

Faction_SaveRank(id, slot = -1) {
    if(Iter_Contains(Iter_Faction, id)) {
        new query[80];
		if(slot==-1) {
			for (new j = 0; j != MAX_FACTION_RANKS; j ++) {
				mysql_format(dbCon, query, sizeof(query), "UPDATE `faction` SET `rank%d`='%e' WHERE `id`=%d",j,factionRanks[id][j],factionData[id][fID]);
				mysql_pquery(dbCon, query);
			}
		}
		else {
			mysql_format(dbCon, query, sizeof(query), "UPDATE `faction` SET `rank%d`='%e' WHERE `id`=%d",slot,factionRanks[id][slot],factionData[id][fID]);
			mysql_pquery(dbCon, query);
		}
    }
    return 1;
}

Faction_SaveSkin(id, slot = -1) {
    if(Iter_Contains(Iter_Faction, id)) {
        new query[64];
		if(slot==-1) {
			for (new j = 0; j != MAX_FACTION_SKINS; j ++) {
				format(query, sizeof(query), "UPDATE `faction` SET `skin%d`=%d WHERE `id`=%d",j+1,factionSkins[id][j],factionData[id][fID]);
				mysql_pquery(dbCon, query);
			}
		}
		else {
			format(query, sizeof(query), "UPDATE `faction` SET `skin%d`=%d WHERE `id`=%d",slot+1,factionSkins[id][slot],factionData[id][fID]);
			mysql_pquery(dbCon, query);			
		}
    }
    return 1;
}

Faction_SaveWeapon(id, slot = -1) {
    if(Iter_Contains(Iter_Faction, id)) {
        new query[64];
		if(slot==-1) {
			for (new j = 0; j != MAX_FACTION_WEAPONS; j ++) {
				format(query, sizeof(query), "UPDATE `faction` SET `weapon%d`=%d, `ammo%d`=%d WHERE `id`=%d",j+1,factionWeapons[id][j][0],j+1,factionWeapons[id][j][1],factionData[id][fID]);
				mysql_pquery(dbCon, query);
			}
		}
		else {
			format(query, sizeof(query), "UPDATE `faction` SET `weapon%d`=%d, `ammo%d`=%d WHERE `id`=%d",slot+1,factionWeapons[id][slot][0],slot+1,factionWeapons[id][slot][1],factionData[id][fID]);
			mysql_pquery(dbCon, query);			
		}
    }
    return 1;
}

CMD:factionhelp(playerid) {
	SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: (/gov)ernment, /invite, /uninvite, /suit");
	return 1;
}

CMD:suit(playerid, params[]) {

	new skinid, faction_id = playerData[playerid][pFactionID];

	if (faction_id == -1)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องเป็นสมาชิกของแฟคชั่น");

	if (factionData[faction_id][fMaxSkins] == 0)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "สกินยังไม่ถูกตั้งค่าโปรดติดต่อผู้ดูแลระบบ!");

	if (sscanf(params, "d", skinid)) {
        SendClientMessage(playerid, COLOR_GREEN,    "___________________________[คำสั่ง]___________________________");
        SendFormatMessage(playerid, COLOR_GRAD1,    "การใช้: /suit [หมายเลข 1-%d]", factionData[faction_id][fMaxSkins]);
	    return 1;
	}

	if (skinid <= 0 || skinid > factionData[faction_id][fMaxSkins]) {
	    return SendFormatMessage(playerid, COLOR_GRAD1, "   สกินที่ระบุไม่ถูกต้อง สกินต้องอยู่ระหว่าง 1 ถึง %d", factionData[faction_id][fMaxSkins]);
	}

	if(!IsPlayerInRangeOfPoint(playerid, 2.5, factionData[faction_id][fSpawnX], factionData[faction_id][fSpawnY], factionData[faction_id][fSpawnZ]) && GetPlayerVirtualWorld(playerid) == factionData[faction_id][fSpawnWorld]) {
		return  SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้อยู่ที่จุดเกิดแฟคชั่นของคุณ ");
	}

	SetPlayerSkin(playerid, factionSkins[faction_id][skinid - 1]);
	playerData[playerid][pModel] = factionSkins[faction_id][skinid - 1];

	return 1;
}

flags:factioncmds(CMD_MM)
CMD:factioncmds(playerid) {
    SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /viewfactions, /makefaction, /removefaction");
    return 1;
}

flags:viewfactions(CMD_LEAD)
CMD:viewfactions(playerid) {
    ViewFactions(playerid);
    return 1;
}

flags:makefaction(CMD_MM)
CMD:makefaction(playerid, params[])
{
	new
        id,
		type,
        abbrev[15],
		name[60];

	if (sscanf(params, "ds[15]s[60]", type, abbrev, name))
	{
        SendClientMessage(playerid, COLOR_GREEN,    "___________________________[คำสั่ง]___________________________");
        SendClientMessage(playerid, COLOR_GRAD1,    "การใช้: /makefaction [ประเภท] [ชื่อย่อ] [ชื่อฝ่าย]");
        SendClientMessage(playerid, COLOR_GRAD2,    "[ประเภท] 1: ผู้บังคับใช้กฎหมาย (Law Enforcement) - 2: แพทย์ (Medical) - 3: นักข่าว (News Network) - 4: ผิดกฎหมาย");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[ ! ]"EMBED_WHITE" ชื่อย่อห้ามมีช่องว่าง");
		return 1;
	}

    if(type < 1 || type > 4) {
        SendClientMessage(playerid, COLOR_RED,   "ผิดพลาด: "EMBED_WHITE"ประเภทแฟคชั่นต้องไม่ต่ำกว่า 1 หรือมากกว่า 4");
        return 1;
    }

    if((id = Iter_Free(Iter_Faction)) != -1) {

	    format(factionData[id][fName], 60, name);
        format(factionData[id][fShortName], 15, abbrev);

        factionData[id][fColor] = 0xFFFFFF;
        factionData[id][fType] = type;
        factionData[id][fMaxRanks] = 6;
        factionData[id][fMaxSkins] = 0;
        factionData[id][fMaxVehicles] = 0;

		for (new j = 0; j != MAX_FACTION_RANKS; j ++) {
		    format(factionRanks[id][j], 30, "ยศ %d", j + 1);
		}

		for (new j = 0; j != MAX_FACTION_SKINS; j ++) {
		    factionSkins[id][j] = 0;
		}

	    mysql_tquery(dbCon, "INSERT INTO `faction` (`type`) VALUES(0)", "OnFactionCreated", "d", id);

        SendFormatMessage(playerid, COLOR_GREY, "เซิร์ฟเวอร์: "EMBED_WHITE"คุณได้สร้างแฟคชั่นไอดี "EMBED_ORANGE"%d", id + 1);

        Iter_Add(Iter_Faction, id);
    }
    else {
        SendFormatMessage(playerid, COLOR_RED,   "ผิดพลาด: "EMBED_WHITE"ไม่สามารถสร้างแฟคชั่นได้มากกว่านี้แล้ว จำกัดไว้ที่ "EMBED_ORANGE"%d", MAX_FACTIONS);
    }
	return 1;
}

CMD:removefaction(playerid, params[]) {
	new
	    id = 0;

	if (sscanf(params, "d", id))
 	{
		SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
		SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /removefaction [ไอดี (/viewfactions)]");
		return 1;
	}

	id--;
	if(Iter_Contains(Iter_Faction, id))
	{
		new
	        string[80];

		//ปลดผู้เล่นออกจากแฟคชั่นที่ถูกลบ
		format(string, sizeof(string), "UPDATE `players` SET `faction`=0,`spawntype`=0  WHERE `faction`=%d", factionData[id][fID]);
		mysql_tquery(dbCon, string);

		foreach (new i : Player)
		{
			if (playerData[i][pFaction] == factionData[id][fID]) {
		    	playerData[i][pFaction] = 0;
		    	playerData[i][pFactionID] = -1;
		    	playerData[i][pFactionRank] = 0;
				SetPlayerSkin(i, playerData[i][pModel]);
			}
			DeletePVar(i, "FactionEditID");
		}

		//ลบยานพาหนะทั้งหมดของแฟคชั่น

		foreach(new i : Iter_ServerCar) {
			new
				cur = i;
			if(vehicleVariables[i][vVehicleFaction] != 0 && vehicleVariables[i][vVehicleFaction] == factionData[id][fID]) {

				Log(a_action_log, INFO, "%s: ลบยานพาหนะ %s(SQLID %d) ของแฟคชั่น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), vehicleVariables[i][vVehicleID], factionData[id][fName], factionData[id][fID]);

				format(string, sizeof(string), "DELETE FROM `vehicle` WHERE `vehicleID` = '%d'", vehicleVariables[i][vVehicleID]);
				mysql_tquery(dbCon, string);

				DestroyVehicle(vehicleVariables[i][vVehicleScriptID]);
				Iter_SafeRemove(Iter_ServerCar, cur, i);
			}
		}

		format(string, sizeof(string), "DELETE FROM `faction` WHERE `id` = '%d'", factionData[id][fID]);
		mysql_tquery(dbCon, string);

		if(IsValidDynamic3DTextLabel(factionData[id][fLabelSpawn])) 
			DestroyDynamic3DTextLabel(factionData[id][fLabelSpawn]);
		
		if(IsValidDynamicPickup(factionData[id][fPickupSpawn])) 
			DestroyDynamicPickup(factionData[id][fPickupSpawn]);

		Log(a_action_log, INFO, "%s: ลบแฟคชั่น %s(%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID]);

		SendFormatMessage(playerid, COLOR_GRAD1, "   คุณได้ลบแฟคชั่นไอดี %d", id + 1);
		Iter_Remove(Iter_Faction, id);
	}
	else {
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ไม่พบแฟคชั่นไอดี %d อยู่ในระบบ", id + 1);
	}
	return 1;
}

forward OnFactionCreated(factionid);
public OnFactionCreated(factionid)
{
	if (factionid == -1)
	    return 0;

	factionData[factionid][fID] = cache_insert_id();

	Faction_Save(factionid);
	Faction_SaveRank(factionid);
    Faction_SaveSkin(factionid);
	return 1;
}

ViewFactions(playerid)
{
	new string[2048], menu[20], count;

	format(string, sizeof(string), "%s{B4B5B7}หน้า 1\n", string);

	SetPVarInt(playerid, "page", 1);

	foreach(new i : Iter_Faction) {
		if(count == 20)
		{
			format(string, sizeof(string), "%s{B4B5B7}หน้า 2\n", string);
			break;
		}
		format(menu, 20, "menu%d", ++count);
		SetPVarInt(playerid, menu, i);
		format(string, sizeof(string), "%s({FFBF00}%i"EMBED_WHITE") | "EMBED_YELLOW"%s\n", string, i + 1, factionData[i][fName]);
	}
	if(!count) Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "รายชื่อแฟคชั่น", "ไม่พบข้อมูลของแฟคชั่น..", "ปิด", "");
	else Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "รายชื่อแฟคชั่น", string, "แก้ไข", "กลับ");
	return 1;
}

Dialog:FactionsList(playerid, response, listitem, inputtext[])
{
	if(response) {

		new menu[20];
		//Navigate
		if(listitem != 0 && listitem != 21) {

			if(!(playerData[playerid][pCMDPermission] & CMD_MM)) {
				SendClientMessage(playerid, COLOR_LIGHTRED, "เกิดข้อผิดพลาด"EMBED_WHITE": คุณไม่ได้รับอนุญาตให้ใช้ฟังก์ชั่นการแก้ไข "EMBED_RED"(MANAGEMENT ONLY)");
				return ViewFactions(playerid);
			}
			new str_biz[20];
			format(str_biz, 20, "menu%d", listitem);

			SetPVarInt(playerid, "FactionEditID", GetPVarInt(playerid, str_biz));
			ShowPlayerEditFaction(playerid);
			return 1;
		}

		new currentPage = GetPVarInt(playerid, "page");
		if(listitem==0) {
			if(currentPage>1) currentPage--;
		}
		else if(listitem == 21) currentPage++;

		new string[2048], count;
		format(string, sizeof(string), "%s{B4B5B7}หน้า %d\n", string, (currentPage==1) ? 1 : currentPage-1);

		SetPVarInt(playerid, "page", currentPage);

		new skipitem = (currentPage-1) * 20;

		foreach(new i : Iter_Faction) {

			if(skipitem)
			{
				skipitem--;
				continue;
			}
			if(count == 20)
			{
				format(string, sizeof(string), "%s{B4B5B7}หน้า 2\n", string);
				break;
			}
			format(menu, 20, "menu%d", ++count);
			SetPVarInt(playerid, menu, i);
			format(string, sizeof(string), "%s({FFBF00}%i"EMBED_WHITE") | "EMBED_YELLOW"%s\n", string, i + 1, factionData[i][fName]);

		}

		Dialog_Show(playerid, FactionsList, DIALOG_STYLE_LIST, "รายชื่อแฟคชั่น", string, "แก้ไข", "กลับ");
	}
	return 1;
}

ShowPlayerEditFaction(playerid)
{
    new id = GetPVarInt(playerid, "FactionEditID");
	if(Iter_Contains(Iter_Faction, id))
	{
		new caption[128], dialog_str[1024];
		format(caption, sizeof(caption), "แก้ไขแฟคชั่น: "EMBED_YELLOW"%s"EMBED_WHITE"(SQLID:%d)", factionData[id][fName], factionData[id][fID]);
        format(dialog_str, sizeof dialog_str, "ชื่อ\t%s\n", factionData[id][fName]);
        format(dialog_str, sizeof dialog_str, "%sชื่อย่อ\t%s\n", dialog_str, factionData[id][fShortName]);
        format(dialog_str, sizeof dialog_str, "%sสี\t{%06x}%06x\n", dialog_str, factionData[id][fColor], factionData[id][fColor]);
        format(dialog_str, sizeof dialog_str, "%sประเภท\t%s\n", dialog_str, GetFactionTypeName(factionData[id][fType]));
        format(dialog_str, sizeof dialog_str, "%sยศ\t%d/%d\n", dialog_str, factionData[id][fMaxRanks], MAX_FACTION_RANKS);
        format(dialog_str, sizeof dialog_str, "%sสกิน\t%d/%d\n", dialog_str, factionData[id][fMaxSkins], MAX_FACTION_SKINS);
        format(dialog_str, sizeof dialog_str, "%sยานพาหนะสูงสุด\t%d\n", dialog_str, factionData[id][fMaxVehicles]);
        format(dialog_str, sizeof dialog_str, "%sอาวุธ\t[รายละเอียดเพิ่มเติม]\n", dialog_str);
        format(dialog_str, sizeof dialog_str, "%sปรับจุดเกิดมายังจุดปัจจุบันของคุณ", dialog_str);
		Dialog_Show(playerid, FactionEdit, DIALOG_STYLE_TABLIST, caption, dialog_str, "แก้ไข", "กลับ");
	}
	return 1;
}

Dialog:FactionEdit(playerid, response, listitem, inputtext[])
{
	if(response) {

		new caption[128];    
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem)
		{
			case 0: // แก้ไขชื่อ
			{
				format(caption, sizeof(caption), "แก้ไข -> ชื่อ: "EMBED_YELLOW"%s", factionData[id][fName]);
				Dialog_Show(playerid, FactionEdit_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อต้องมากกว่า "EMBED_ORANGE"0 "EMBED_WHITE"และไม่เกิน "EMBED_ORANGE"60 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อแฟคชั่นที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 1: // แก้ไขชื่อย่อ
			{
				format(caption, sizeof(caption), "แก้ไข -> ชื่อย่อ: "EMBED_YELLOW"%s", factionData[id][fShortName]);
				Dialog_Show(playerid, FactionEdit_ShortName, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ความยาวของชื่อย่อต้องมากกว่า "EMBED_ORANGE"0 "EMBED_WHITE"และไม่เกิน "EMBED_ORANGE"15 "EMBED_WHITE"ตัวอักษร\n\nกรอกชื่อแฟคชั่นที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 2: // แก้ไขสี
			{
				format(caption, sizeof(caption), "แก้ไข -> สี: {%06x}%06x", factionData[id][fColor], factionData[id][fColor]);
				Dialog_Show(playerid, FactionEdit_Color, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ตัวอย่างโค้ดสี: "EMBED_YELLOW"ffff00"EMBED_WHITE"\n\nกรอกโค้ดสีที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
			}
			case 3: // แก้ไขประเภท
			{
				format(caption, sizeof(caption), "แก้ไข -> ประเภท: %s", GetFactionTypeName(factionData[id][fType]));
				Dialog_Show(playerid, FactionEdit_Type, DIALOG_STYLE_LIST, caption, "1: ผู้บังคับใช้กฎหมาย (Law Enforcement)\n2: แพทย์ (Medical)\n3: นักข่าว (News Network)\n4: ผิดกฎหมาย", "เปลี่ยน", "กลับ");
			}
			case 4: // แก้ไขยศ
			{
				Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "จำนวนยศ\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 5: // แก้ไขสกิน
			{
				Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "จำนวนสกิน\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 6: // แก้ไขจำนวนพาหนะสูงสุด
			{
				Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "แก้ไข -> พาหนะ", "ปัจจุบัน: %d\n\nกรอกจำนวนพาหนะสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxVehicles]);
			}
			case 7: // อาวุธ
			{
				ShowPlayerEditFaction_Weapon(playerid);
			}
			case 8: // จุดเกิด
			{
				format(caption, sizeof(caption), "แก้ไข -> แก้ไขจุดเกิด");
				Dialog_Show(playerid, FactionEdit_Spawn, DIALOG_STYLE_MSGBOX, caption, "คุณแน่ใจหรือที่จะปรับจุดเกิดแฟคชั่นนี้มายังตำแหน่งปัจจุบันของคุณ", "ยืนยัน", "กลับ");
			}
		}
	}
	else
	{
	    DeletePVar(playerid, "FactionEditID");
        ViewFactions(playerid);
	}
    return 1;
}

Dialog:FactionEdit_SetRankName(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new rank_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID");

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][rank_slot], rank_slot + 1);

	    if (strlen(inputtext) < 1 || strlen(inputtext) > 30)
	        return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": ความยาวของชื่อต้องไม่ต่ำกว่า "EMBED_ORANGE"1"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"30"EMBED_WHITE"\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][rank_slot], rank_slot + 1);

		SendFormatMessage(playerid, COLOR_GRAD, " ชื่อยศของ "EMBED_WHITE"%s"EMBED_GRAD" ยศที่ "EMBED_WHITE"%d"EMBED_GRAD" จาก "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%s"EMBED_GRAD"", factionData[id][fName], rank_slot + 1, factionRanks[id][rank_slot], inputtext);
		Log(a_action_log, INFO, "%s: เปลี่ยนชื่อยศของ %s(%d) ยศที่ %d จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], rank_slot + 1, factionRanks[id][rank_slot], inputtext);
		format(factionRanks[id][rank_slot], 30, inputtext);
	    Faction_SaveRank(id, rank_slot);
	}
	return ShowPlayerEditFaction_RankList(playerid);
}

ShowPlayerEditFaction_RankList(playerid) {
	new
		string[45 * MAX_FACTION_RANKS], id = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < factionData[id][fMaxRanks]; i ++)
		format(string, sizeof(string), "%sยศ %d: "EMBED_YELLOW"%s\n", string, i + 1, factionRanks[id][i]);

	return Dialog_Show(playerid, FactionEdit_RankName, DIALOG_STYLE_LIST, "ยศ -> ชื่อยศ", string, "แก้ไข", "กลับ");
}

Dialog:FactionEdit_RankName(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetRankName, DIALOG_STYLE_INPUT, "ยศ -> ชื่อยศ", ""EMBED_WHITE"ยศ: "EMBED_YELLOW"%s "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนชื่อยศใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionRanks[id][listitem], listitem + 1);
	}
	return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "จำนวนยศ\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_Rank(playerid, response, listitem, inputtext[])
{
	if(response) { 
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem) {
			case 0: {
				return Dialog_Show(playerid, FactionEdit_RankMax, DIALOG_STYLE_INPUT, "แก้ไข -> ยศ", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n\nกรอกจำนวนยศสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
			}
			case 1: {
				if(factionData[id][fMaxRanks] == 0) return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "จำนวนยศ\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
				else return ShowPlayerEditFaction_RankList(playerid);
			}
		}
	}
	return ShowPlayerEditFaction(playerid);
}

Dialog:FactionEdit_RankMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0 || typeint > MAX_FACTION_RANKS) {
			return Dialog_Show(playerid, FactionEdit_RankMax, DIALOG_STYLE_INPUT, "แก้ไข -> ยศ", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": จำนวนต้องไม่ต่ำกว่า "EMBED_ORANGE"0"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"%d"EMBED_WHITE"\n\nกรอกจำนวนยศสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, MAX_FACTION_RANKS);
		}
		SendFormatMessage(playerid, COLOR_GRAD, " ยศสูงสุดของ "EMBED_WHITE"%s"EMBED_GRAD" จาก "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%s"EMBED_GRAD"", factionData[id][fName], factionData[id][fMaxRanks], typeint);
		Log(a_action_log, INFO, "%s: เปลี่ยนยศสูงสุดของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxRanks], typeint);
	    factionData[id][fMaxRanks] = typeint;
	    Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Rank, DIALOG_STYLE_LIST, "แก้ไข -> ยศ", "จำนวนยศ\t(%d/%d)\nชื่อยศ\t", "แก้ไข", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_VehMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0) {
			return Dialog_Show(playerid, FactionEdit_VehMax, DIALOG_STYLE_INPUT, "แก้ไข -> พาหนะ", "ปัจจุบัน: %d\n\nกรอกจำนวนพาหนะสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxVehicles]);
		}
		Log(a_action_log, INFO, "%s: เปลี่ยนจำนวนพาหนะสูงสุดของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxVehicles], typeint);
	    factionData[id][fMaxVehicles] = typeint;
	    Faction_Save(id);
	}
	return ShowPlayerEditFaction(playerid);
}

Dialog:FactionEdit_Type(playerid, response, listitem, inputtext[])
{
	if(response) {
		new id = GetPVarInt(playerid, "FactionEditID");
		listitem++;
		SendFormatMessage(playerid, COLOR_GRAD, " ชื่อประเภท "EMBED_WHITE"%s"EMBED_GRAD" จาก "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%s"EMBED_GRAD"", factionData[id][fName], GetFactionTypeName(factionData[id][fType]), GetFactionTypeName(listitem));
		Log(a_action_log, INFO, "%s: เปลี่ยนประเภท %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], GetFactionTypeName(factionData[id][fType]), GetFactionTypeName(listitem));

		factionData[id][fType] = listitem;
	    Faction_Save(id);
	}
	return ShowPlayerEditFaction(playerid);
}

Dialog:FactionEdit_Color(playerid, response, listitem, inputtext[])
{
	if(response) {

		new caption[128], id = GetPVarInt(playerid, "FactionEditID"), color;
		if (strlen(inputtext) != 6 || sscanf(inputtext, "x", color)) {
			format(caption, sizeof(caption), "แก้ไข -> สี: {%06x}%06x", factionData[id][fColor], factionData[id][fColor]);
			return Dialog_Show(playerid, FactionEdit_Color, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"ตัวอย่างโค้ดสี: "EMBED_YELLOW"ffff00"EMBED_WHITE"\n\nกรอกโค้ดสีที่ต้องการในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ");
		}
		SendFormatMessage(playerid, COLOR_GRAD, " ชื่อสี "EMBED_WHITE"%s"EMBED_GRAD" เป็น {%06x}%06x"EMBED_GRAD"", factionData[id][fName], color, color);
		
		new string[256];
		format(string, sizeof string, "%s: เปลี่ยนสี %s(%d) จาก %06x เป็น %06x", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fColor], color);
		Log(a_action_log, INFO, string);

	    factionData[id][fColor] = color;
	    Faction_Save(id);
	}
	return ShowPlayerEditFaction(playerid);
}

Dialog:FactionEdit_Name(playerid, response, listitem, inputtext[])
{
	if(response) {
		new caption[128];
		new id = GetPVarInt(playerid, "FactionEditID");

		if(isnull(inputtext) || strlen(inputtext) >= 60) {
			format(caption, sizeof(caption), "แก้ไข -> ชื่อ: "EMBED_YELLOW"%s", factionData[id][fName]);
			Dialog_Show(playerid, FactionEdit_Name, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อต้องมากกว่า "EMBED_YELLOW"0 "EMBED_WHITE"และไม่เกิน "EMBED_YELLOW"60 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}
		SendFormatMessage(playerid, COLOR_GRAD, " ชื่อ "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%s"EMBED_GRAD"", factionData[id][fName], inputtext);
		Log(a_action_log, INFO, "%s: เปลี่ยนชื่อ %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fName], inputtext);

		format(factionData[id][fName], 60, inputtext);

		Faction_SpawnUpdate(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

		Faction_Save(id);
	}
	return ShowPlayerEditFaction(playerid);
}

Dialog:FactionEdit_ShortName(playerid, response, listitem, inputtext[])
{
	if(response) {
		new caption[128];
		new id = GetPVarInt(playerid, "FactionEditID");

		if(isnull(inputtext) || strlen(inputtext) >= 15) {
			format(caption, sizeof(caption), "แก้ไข -> ชื่อย่อ: "EMBED_YELLOW"%s", factionData[id][fShortName]);
			Dialog_Show(playerid, FactionEdit_ShortName, DIALOG_STYLE_INPUT, caption, ""EMBED_LIGHTRED"พบข้อผิดพลาด:\n"EMBED_WHITE"ความยาวของชื่อย่อต้องมากกว่า "EMBED_YELLOW"0 "EMBED_WHITE"และไม่เกิน "EMBED_YELLOW"15 "EMBED_WHITE"ตัวอักษร", "เปลี่ยน", "กลับ");
			return 1;
		}
		SendFormatMessage(playerid, COLOR_GRAD, " ชื่อย่อ "EMBED_WHITE"%s"EMBED_GRAD" เป็น "EMBED_WHITE"%s"EMBED_GRAD"", factionData[id][fShortName], inputtext);
		Log(a_action_log, INFO, "%s: เปลี่ยนชื่อย่อ %s(%d) จาก %s เป็น %s", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fShortName], inputtext);
	
		format(factionData[id][fShortName], 15, inputtext);
		Faction_Save(id);
	}
	return ShowPlayerEditFaction(playerid);
}

GetFactionTypeName(type) {
    new faction_type[24];
    switch(type) {
        case 1: format(faction_type, sizeof faction_type, "ผู้บังคับใช้กฎหมาย");
        case 2: format(faction_type, sizeof faction_type, "แพทย์");
        case 3: format(faction_type, sizeof faction_type, "นักข่าว");
        case 4: format(faction_type, sizeof faction_type, "ผิดกฎหมาย");
        default: format(faction_type, sizeof faction_type, "ไม่ระบุ");
    }
    return faction_type;
}

Faction_Name(factionid)
{
    new
		name[60] = "ประชาชน";

 	if (factionid == -1)
	    return name;

	format(name, 60, factionData[factionid][fName]);
	return name;
}

Faction_GetName(playerid)
{
    new
		factionid = playerData[playerid][pFactionID],
		name[60] = "ประชาชน";

 	if (factionid == -1)
	    return name;

	format(name, 60, factionData[factionid][fName]);
	return name;
}

Faction_GetRank(playerid)
{
    new
		factionid = playerData[playerid][pFactionID],
		rank[30] = "ไม่มี";

 	if (factionid == -1)
	    return rank;

	format(rank, 30, factionRanks[factionid][playerData[playerid][pFactionRank] - 1]);
	return rank;
}

Faction_SpawnUpdate(id) {
	new string[128];

	if(IsValidDynamic3DTextLabel(factionData[id][fLabelSpawn])) 
		DestroyDynamic3DTextLabel(factionData[id][fLabelSpawn]);
	
	if(IsValidDynamicPickup(factionData[id][fPickupSpawn])) 
		DestroyDynamicPickup(factionData[id][fPickupSpawn]);

	format(string, sizeof(string), "• %s"EMBED_WHITE" •\nกดปุ่ม \""EMBED_YELLOW"N"EMBED_WHITE"\" เพื่อหยิบอาวุธ", factionData[id][fName]);
	factionData[id][fLabelSpawn] = CreateDynamic3DTextLabel(string, -1, factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], 25, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, factionData[id][fSpawnWorld], factionData[id][fSpawnInt], -1, 25.0);

	factionData[id][fPickupSpawn] = CreateDynamicPickup(356, 23, factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnWorld], factionData[id][fSpawnInt], -1, 25.0);
	return 1;
}

Dialog:FactionEdit_Skin(playerid, response, listitem, inputtext[])
{
	if(response) { 
        new id = GetPVarInt(playerid, "FactionEditID");
		switch(listitem) {
			case 0: {
				return Dialog_Show(playerid, FactionEdit_SkinMax, DIALOG_STYLE_INPUT, "แก้ไข -> สกิน", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n\nกรอกจำนวนสกินสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
			}
			case 1: {
				if(factionData[id][fMaxSkins] == 0) return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "จำนวนสกิน\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
				else return ShowPlayerEditFaction_SkinList(playerid);
			}
		}
	}
	return ShowPlayerEditFaction(playerid);
}

ShowPlayerEditFaction_SkinList(playerid) {
	new
		string[45 * MAX_FACTION_SKINS], id = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < factionData[id][fMaxSkins]; i ++)
		format(string, sizeof(string), "%sสกิน %d: "EMBED_YELLOW"%d\n", string, i + 1, factionSkins[id][i]);

	return Dialog_Show(playerid, FactionEdit_SkinID, DIALOG_STYLE_LIST, "สกิน -> ไอดีสกิน", string, "แก้ไข", "กลับ");
}

Dialog:FactionEdit_SkinMax(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if(response) {
		new typeint = strval(inputtext);
		if(typeint < 0 || typeint > MAX_FACTION_SKINS) {
			return Dialog_Show(playerid, FactionEdit_SkinMax, DIALOG_STYLE_INPUT, "แก้ไข -> สกิน", ""EMBED_WHITE"ปัจจุบัน: %d/%d\n"EMBED_LIGHTRED"ข้อผิดพลาด"EMBED_WHITE": จำนวนต้องไม่ต่ำกว่า "EMBED_ORANGE"0"EMBED_WHITE" หรือมากกว่า "EMBED_ORANGE"%d"EMBED_WHITE"\n\nกรอกจำนวนสกินสูงสุดในช่องว่างด้านล่างนี้:", "เปลี่ยน", "กลับ", factionData[id][fMaxRanks], MAX_FACTION_RANKS, MAX_FACTION_RANKS);
		}
		SendFormatMessage(playerid, COLOR_GRAD, " สกินสูงสุดของ "EMBED_WHITE"%s"EMBED_GRAD" จาก "EMBED_WHITE"%d"EMBED_GRAD" เป็น "EMBED_WHITE"%d"EMBED_GRAD"", factionData[id][fName], factionData[id][fMaxSkins], typeint);
		Log(a_action_log, INFO, "%s: เปลี่ยนสกินสูงสุดของ %s(%d) จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fMaxSkins], typeint);

	    factionData[id][fMaxSkins] = typeint;
	    Faction_Save(id);
	}
	return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "จำนวนสกิน\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_SKINS);
}

Dialog:FactionEdit_SkinID(playerid, response, listitem, inputtext[])
{
	new id = GetPVarInt(playerid, "FactionEditID");
	if (response)
	{
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetSkinID, DIALOG_STYLE_INPUT, "สกิน -> ไอดีสกิน", ""EMBED_WHITE"สกิน: "EMBED_YELLOW"%d "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนไอดีสกินใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionSkins[id][listitem], listitem + 1);
	}
	return Dialog_Show(playerid, FactionEdit_Skin, DIALOG_STYLE_LIST, "แก้ไข -> สกิน", "จำนวนสกิน\t(%d/%d)\nไอดีสกิน\t", "แก้ไข", "กลับ", factionData[id][fMaxSkins], MAX_FACTION_RANKS);
}

Dialog:FactionEdit_SetSkinID(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new skin_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID"), skin_id = strval(inputtext);

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetSkinID, DIALOG_STYLE_INPUT, "สกิน -> ไอดีสกิน", ""EMBED_WHITE"สกิน: "EMBED_YELLOW"%d "EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nกรุณาป้อนไอดีสกินใหม่ด้านล่างนี้:", "เปลี่ยน", "กลับ", factionSkins[id][skin_slot], skin_slot + 1);

		SendFormatMessage(playerid, COLOR_GRAD, " ไอดีสกินของ "EMBED_WHITE"%s"EMBED_GRAD" สกินที่ %d จาก "EMBED_WHITE"%d"EMBED_GRAD" เป็น "EMBED_WHITE"%d"EMBED_GRAD"", factionData[id][fName], skin_slot + 1, factionSkins[id][skin_slot], skin_id);
		Log(a_action_log, INFO, "%s: เปลี่ยนไอดีสกินของ %s(%d) สกินที่ %d จาก %d เป็น %d", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], skin_slot + 1, factionSkins[id][skin_slot], skin_id);
		factionSkins[id][skin_slot] = skin_id;
	    Faction_SaveSkin(id, skin_slot);
	}
	return ShowPlayerEditFaction_SkinList(playerid);
}

ShowPlayerEditFaction_Weapon(playerid) {
	new
		string[64 * MAX_FACTION_WEAPONS], id = GetPVarInt(playerid, "FactionEditID");

	for (new i = 0; i < MAX_FACTION_WEAPONS; i ++) {
		if(i==0) format(string, sizeof(string), ""EMBED_YELLOW"%s"EMBED_WHITE"(%d) จำนวน "EMBED_ORANGE"%d", ReturnFactionWeaponName(factionWeapons[id][i][0]), factionWeapons[id][i][0], factionWeapons[id][i][1]);
		else format(string, sizeof(string), "%s\n"EMBED_YELLOW"%s"EMBED_WHITE"(%d) จำนวน "EMBED_ORANGE"%d", string, ReturnFactionWeaponName(factionWeapons[id][i][0]), factionWeapons[id][i][0], factionWeapons[id][i][1]);
	}
	return Dialog_Show(playerid, FactionEdit_Weapon, DIALOG_STYLE_LIST, "แก้ไข -> แก้ไขอาวุธ", string, "แก้ไข", "กลับ");
}

Dialog:FactionEdit_Weapon(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "FactionEditID");
		SetPVarInt(playerid, "FactionEditSlot", listitem);
		return Dialog_Show(playerid, FactionEdit_SetWeapon, DIALOG_STYLE_INPUT, "แก้ไข -> แก้ไขอาวุธ", ""EMBED_WHITE"ช่องที่ %d: "EMBED_YELLOW"%s"EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nตัวอย่าง \""EMBED_YELLOW"ไอดีอาวุธ "EMBED_ORANGE"จำนวน"EMBED_WHITE"\": \nพิมพ์ \""EMBED_YELLOW"31 "EMBED_ORANGE"300"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"M4 "EMBED_WHITE"จำนวน "EMBED_ORANGE"300"EMBED_WHITE")\nพิมพ์ \""EMBED_YELLOW"100 "EMBED_ORANGE"200"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"เลือด "EMBED_WHITE"จำนวน "EMBED_ORANGE"200"EMBED_WHITE")\n\nเพิ่มเติม: \nไอดี "EMBED_YELLOW"100"EMBED_WHITE" = เลือด \nไอดี "EMBED_YELLOW"200"EMBED_WHITE" = เกราะ\n\nกรุณาป้อนไอดีอาวุธด้านล่างนี้", "ตั้งค่า", "กลับ", listitem + 1, ReturnFactionWeaponName(factionWeapons[id][listitem][0]), factionWeapons[id][listitem][1]);
	}
	return ShowPlayerEditFaction(playerid);
}

Dialog:FactionEdit_SetWeapon(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new wp_slot = GetPVarInt(playerid, "FactionEditSlot"), id = GetPVarInt(playerid, "FactionEditID");

	    if (isnull(inputtext))
			return Dialog_Show(playerid, FactionEdit_SetWeapon, DIALOG_STYLE_INPUT, "แก้ไข -> แก้ไขอาวุธ", ""EMBED_WHITE"ช่องที่ %d: "EMBED_YELLOW"%s"EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nตัวอย่าง \""EMBED_YELLOW"ไอดีอาวุธ "EMBED_ORANGE"จำนวน"EMBED_WHITE"\": \nพิมพ์ \""EMBED_YELLOW"31 "EMBED_ORANGE"300"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"M4 "EMBED_WHITE"จำนวน "EMBED_ORANGE"300"EMBED_WHITE")\nพิมพ์ \""EMBED_YELLOW"100 "EMBED_ORANGE"200"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"เลือด "EMBED_WHITE"จำนวน "EMBED_ORANGE"200"EMBED_WHITE")\n\nเพิ่มเติม: \nไอดี "EMBED_YELLOW"100"EMBED_WHITE" = เลือด \nไอดี "EMBED_YELLOW"200"EMBED_WHITE" = เกราะ\n\nกรุณาป้อนไอดีอาวุธด้านล่างนี้", "ตั้งค่า", "กลับ", 
			wp_slot + 1, ReturnFactionWeaponName(factionWeapons[id][wp_slot][0]), factionWeapons[id][wp_slot][1]);

		new tmp[2][8];
		strexplode(tmp, inputtext, " ");

		new gunid = strval(tmp[0]), ammo = strval(tmp[1]);

		if(gunid < 0 || (gunid > 46 && gunid != 100 && gunid != 200) || gunid == 19 || gunid == 20 || gunid == 21)
			return Dialog_Show(playerid, FactionEdit_SetWeapon, DIALOG_STYLE_INPUT, "แก้ไข -> แก้ไขอาวุธ", ""EMBED_LIGHTRED"พบข้อผิดพลาด"EMBED_WHITE": ไอดีอาวุธไม่ถูกต้อง\n\nช่องที่ %d: "EMBED_YELLOW"%s"EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nตัวอย่าง \""EMBED_YELLOW"ไอดีอาวุธ "EMBED_ORANGE"จำนวน"EMBED_WHITE"\": \nพิมพ์ \""EMBED_YELLOW"31 "EMBED_ORANGE"300"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"M4 "EMBED_WHITE"จำนวน "EMBED_ORANGE"300"EMBED_WHITE")\nพิมพ์ \""EMBED_YELLOW"100 "EMBED_ORANGE"200"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"เลือด "EMBED_WHITE"จำนวน "EMBED_ORANGE"200"EMBED_WHITE")\n\nเพิ่มเติม: \nไอดี "EMBED_YELLOW"100"EMBED_WHITE" = เลือด \nไอดี "EMBED_YELLOW"200"EMBED_WHITE" = เกราะ\n\nกรุณาป้อนไอดีอาวุธด้านล่างนี้", "ตั้งค่า", "กลับ", 
			wp_slot + 1, ReturnFactionWeaponName(factionWeapons[id][wp_slot][0]), factionWeapons[id][wp_slot][1]);

		if(ammo <= 0 && gunid > 0)
			return Dialog_Show(playerid, FactionEdit_SetWeapon, DIALOG_STYLE_INPUT, "แก้ไข -> แก้ไขอาวุธ", ""EMBED_LIGHTRED"พบข้อผิดพลาด"EMBED_WHITE": จำนวนไม่ถูกต้อง\n\nช่องที่ %d: "EMBED_YELLOW"%s"EMBED_WHITE"("EMBED_ORANGE"%d"EMBED_WHITE")\n\nตัวอย่าง \""EMBED_YELLOW"ไอดีอาวุธ "EMBED_ORANGE"จำนวน"EMBED_WHITE"\": \nพิมพ์ \""EMBED_YELLOW"31 "EMBED_ORANGE"300"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"M4 "EMBED_WHITE"จำนวน "EMBED_ORANGE"300"EMBED_WHITE")\nพิมพ์ \""EMBED_YELLOW"100 "EMBED_ORANGE"200"EMBED_WHITE"\" (หมายถึง "EMBED_YELLOW"เลือด "EMBED_WHITE"จำนวน "EMBED_ORANGE"200"EMBED_WHITE")\n\nเพิ่มเติม: \nไอดี "EMBED_YELLOW"100"EMBED_WHITE" = เลือด \nไอดี "EMBED_YELLOW"200"EMBED_WHITE" = เกราะ\n\nกรุณาป้อนไอดีอาวุธด้านล่างนี้", "ตั้งค่า", "กลับ", 
			wp_slot + 1, ReturnFactionWeaponName(factionWeapons[id][wp_slot][0]), factionWeapons[id][wp_slot][1]);

		Log(a_action_log, INFO, "%s: เปลี่ยนอาวุธของ %s(%d) ช่องที่ %d จาก %s(%d) จำนวน %d เป็น %s(%d) จำนวน %d", 
		ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], wp_slot + 1, ReturnFactionWeaponName(factionWeapons[id][wp_slot][0]), factionWeapons[id][wp_slot][0], factionWeapons[id][wp_slot][1], ReturnFactionWeaponName(gunid), gunid, ammo);

		SendFormatMessage(playerid, COLOR_GRAD, " อาวุธของ "EMBED_WHITE"%s"EMBED_GRAD" ช่องที่ %d จาก "EMBED_WHITE"%s(%d)"EMBED_GRAD" เป็น "EMBED_WHITE"%s(%d)"EMBED_GRAD"", factionData[id][fName], wp_slot + 1, ReturnFactionWeaponName(factionWeapons[id][wp_slot][0]), factionWeapons[id][wp_slot][1], ReturnFactionWeaponName(gunid), ammo);

		factionWeapons[id][wp_slot][0] = gunid;
		factionWeapons[id][wp_slot][1] = ammo;
		Faction_SaveWeapon(id, wp_slot);
	}
	return ShowPlayerEditFaction_Weapon(playerid);
}

Dialog:FactionEdit_Spawn(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "FactionEditID");
		new Float:px, Float:py, Float:pz, Float:pa, pint = GetPlayerInterior(playerid), pworld = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, px, py, pz);
		GetPlayerFacingAngle(playerid, pa);

		SendFormatMessage(playerid, COLOR_GRAD, " จุดเกิดของ "EMBED_WHITE"%s"EMBED_GRAD" ถูกเปลี่ยนมายังที่อยู่ปัจจุบันของคุณแล้ว", factionData[id][fName]);
		Log(a_action_log, INFO, "%s: เปลี่ยนจุดเกิดของ %s(%d) จาก %f,%f,%f (int:%d|world:%d) เป็น %f,%f,%f (int:%d|world:%d)", ReturnPlayerName(playerid), factionData[id][fName], factionData[id][fID], factionData[id][fSpawnX], factionData[id][fSpawnY], factionData[id][fSpawnZ], factionData[id][fSpawnInt], factionData[id][fSpawnWorld], px, py, pz, pint, pworld);

        factionData[id][fSpawnX]=px;
        factionData[id][fSpawnY]=py;
        factionData[id][fSpawnZ]=pz;
		factionData[id][fSpawnA]=pa;
        factionData[id][fSpawnInt]=pint;
        factionData[id][fSpawnWorld]=pworld;

		Faction_SpawnUpdate(id);
		Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
	   	Faction_Save(id);
	}
	return ShowPlayerEditFaction(playerid);
}

hook OP_KeyStateChange(playerid, newkeys, oldkeys)
{
	if(Pressed(KEY_NO)) {
		new faction_id = playerData[playerid][pFactionID];
		if(faction_id != -1) {
			if(IsPlayerInRangeOfPoint(playerid, 5.0, factionData[faction_id][fSpawnX], factionData[faction_id][fSpawnY], factionData[faction_id][fSpawnZ]) && GetPlayerVirtualWorld(playerid) == factionData[faction_id][fSpawnWorld] && GetPlayerInterior(playerid) == factionData[faction_id][fSpawnInt]) {
				
				if(FillupDelay[playerid] != 0 && gettime() - FillupDelay[playerid] < 30) {
					SendFormatMessage(playerid, COLOR_LIGHTRED, "เกิดข้อผิดพลาด"EMBED_WHITE": คุณไม่สามารถหยิบอาวุธได้ในขณะนี้ ลองใหม่อีกครั้งในอีก "EMBED_ORANGE"%d"EMBED_WHITE" วินาที", 30 - (gettime() - FillupDelay[playerid]));
					return 1;
				}

				if(factionData[faction_id][fType] == FACTION_POLICE) {
					SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* เจ้าหน้าที่ %s ได้หยิบอาวุธออกจากคลัง", ReturnPlayerName(playerid));
				}
				else {
					SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s ได้หยิบอาวุธออกจากคลัง", ReturnPlayerName(playerid));
				}
				ApplyAnimation(playerid,"COLT45","colt45_reload",4.0,0,0,0,0,0);

				ResetPlayerWeapons(playerid);

				for (new j = 0; j != 10; j ++) {
				    if(factionWeapons[faction_id][j][0] == 100) { // เลือด
				        SetPlayerHealthEx(playerid, factionWeapons[faction_id][j][1]);
				    }
				    else if(factionWeapons[faction_id][j][0] == 200) { // เกราะ
				        SetPlayerArmour(playerid, factionWeapons[faction_id][j][1]);
				    }
				    else {
				        if(factionWeapons[faction_id][j][0] > 0) {
				           GivePlayerWeapon(playerid, factionWeapons[faction_id][j][0], factionWeapons[faction_id][j][1]);
				        }
				    }
				}

				FillupDelay[playerid] = gettime();
			}
		}
	}
	return 1;
}

hook OnPlayerConnect(playerid) {
	FillupDelay[playerid]=0;
	return 1;
}

flags:makeleader(CMD_LEAD)
CMD:makeleader(playerid, params[]) {

	new
		userid,
		id;		

	if (sscanf(params, "ud", userid, id)) {
        SendClientMessage(playerid, COLOR_GREEN,    "___________________________[คำสั่ง]___________________________");
        SendClientMessage(playerid, COLOR_GRAD1,    "การใช้: /makeleader [ไอดี/ชื่อบางส่วน] [ไอดีแฟคชั่น(/viewfactions)]");
		return 1;
	}

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (id < 0 || id > MAX_FACTIONS)
	    return SendClientMessage(playerid, COLOR_GRAD1, "   คุณระบุไอดีฝ่ายหรือกลุ่มผิดพลาด");

	if (id == 0)
	{
		if(playerData[userid][pFactionID] != -1) {
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, " คุณได้ปลด %s จากแฟคชั่น %s", ReturnPlayerName(userid), Faction_GetName(userid));
			SendFormatMessage(userid, COLOR_LIGHTBLUE, " %s ได้ปลดคุณออกจากแฟคชั่น %s", ReturnPlayerName(playerid), Faction_GetName(userid));
			SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s ได้ปลด %s ออกจากการเป็นผู้นำ %s"EMBED_YELLOW" (%d)", ReturnPlayerName(playerid), ReturnPlayerName(userid), Faction_GetName(userid), playerData[userid][pFactionID] + 1);

			playerData[userid][pFaction] = 0;
			playerData[userid][pFactionID] = -1;
			playerData[userid][pFactionRank] = 0;
		}
		else return SendClientMessage(playerid, COLOR_GRAD1, " ผู้เล่นนั้นไม่ได้อยู่ในแฟคชั่นใด ๆ");
	}
	else
	{
		id--;
		if(Iter_Contains(Iter_Faction, id)) {
			playerData[userid][pFaction] = factionData[id][fID];
			playerData[userid][pFactionID] = id;
			playerData[userid][pFactionRank] = 1;

			SendFormatMessage(userid, COLOR_LIGHTBLUE, " คุณได้รับการแต่งตั้งให้เป็นผู้นำ %s"EMBED_LIGHTBLUE" โดยแอดมิน %s", Faction_GetName(userid), ReturnPlayerName(playerid));
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, " คุณได้แต่งตั้งให้ %s เป็นผู้นำ %s", ReturnPlayerName(userid), Faction_GetName(userid));
			SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s ได้แต่งตั้งให้ %s เป็นผู้นำ %s"EMBED_YELLOW" (%d)", ReturnPlayerName(playerid), ReturnPlayerName(userid), Faction_GetName(userid), id + 1);
		}
		else {
			SendFormatMessage(playerid, COLOR_LIGHTRED, "เกิดข้อผิดพลาด"EMBED_WHITE": ไม่พบแฟคชั่นไอดี "EMBED_ORANGE"%d"EMBED_WHITE" อยู่ในระบบ (/viewfactions)", id + 1);
		}
	}
	return 1;
}

CMD:invite(playerid, params[]) {

	new userid = INVALID_PLAYER_ID, id = playerData[playerid][pFactionID];

	if(id == -1 || !Iter_Contains(Iter_Faction, id)) {
        SendClientMessage(playerid, COLOR_GRAD1,  "   คุณไม่ใช่ส่วนหนึ่งของแฟคชั่น!");
		return 1;
	}

	if (sscanf(params, "u", userid)) {
        SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /invite [ไอดี/ชื่อบางส่วน]");
		return 1;
	}

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (playerData[playerid][pFactionRank] == 1)
	{
		if (playerData[userid][pFactionID] == -1)
		{
			SendFormatMessage(userid, COLOR_LIGHTBLUE, "%s ได้รับคุณเข้าแฟคชั่น %s", ReturnPlayerName(playerid), Faction_GetName(playerid));
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "คุณได้รับ %s เข้าแฟคชั่น %s", ReturnPlayerName(userid), Faction_GetName(playerid));

			playerData[userid][pFaction] = playerData[playerid][pFaction];
			playerData[userid][pFactionID] = playerData[playerid][pFactionID];
			playerData[userid][pFactionRank] = factionData[id][fMaxRanks];
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "  ผู้เล่นนั้นมีแฟคชั่นอยู่แล้ว");
		    return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   สำหรับผู้นำแฟคชั่นเท่านั้น!");
	}
	return 1;
}

CMD:uninvite(playerid, params[]) {

	new userid = INVALID_PLAYER_ID, id = playerData[playerid][pFactionID];

	if(id == -1 || !Iter_Contains(Iter_Faction, id)) {
        SendClientMessage(playerid, COLOR_GRAD1,  "   คุณไม่ใช่ส่วนหนึ่งของแฟคชั่น!");
		return 1;
	}

	if (sscanf(params, "u", userid)) {
        SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /uninvite [ไอดี/ชื่อบางส่วน]");
		return 1;
	}

	if(userid == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_GRAD1, "   ผู้เล่นนั้นตัดการเชื่อมต่อ");

	if (playerData[playerid][pFactionRank] == 1)
	{
		if (playerData[userid][pFactionID] == playerData[playerid][pFaction])
		{
			SendFormatMessage(userid, COLOR_LIGHTBLUE, "%s ได้เตะคุณออกจากแฟคชั่น %s", ReturnPlayerName(playerid), Faction_GetName(playerid));
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "คุณได้เตะ %s ออกจากแฟคชั่น %s", ReturnPlayerName(userid), Faction_GetName(playerid));

			playerData[userid][pFaction]=0;
			playerData[userid][pFactionID]=-1;
			playerData[userid][pFactionRank]=0;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "  ผู้เล่นนั้นไม่ได้อยู่แฟคชั่นเดียวกับคุุณ");
		    return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   สำหรับผู้นำแฟคชั่นเท่านั้น!");
	}
	return 1;
}

alias:government("gov")
CMD:government(playerid, params[]) {

	new id = playerData[playerid][pFactionID];

	if(id == -1 || !Iter_Contains(Iter_Faction, id)) {
        SendClientMessage(playerid, COLOR_GRAD1,  "   คุณไม่ใช่ส่วนหนึ่งของแฟคชั่น!");
		return 1;
	}

	new
	    result[128];

	if (sscanf(params, "s[128]", result)) {
        SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /government [ข้อความ]");
		return 1;
	}

	if (playerData[playerid][pFactionRank] == 1)
	{
		if(Iter_Contains(Iter_Faction, id)) {
			SendFormatMessageToAll(COLOR_WHITE, "{%06x}|================== (( %s{%06x} )) ==================|", factionData[id][fColor], factionData[id][fName], factionData[id][fColor]);
			SendFormatMessageToAll(COLOR_WHITE, "ประกาศจาก %s %s(%d): %s", Faction_GetRank(playerid), ReturnPlayerName(playerid), playerid, result);
			SendFormatMessageToAll(COLOR_WHITE, "{%06x}|================== (( %s{%06x} )) ==================|", factionData[id][fColor], factionData[id][fName], factionData[id][fColor]);
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   สำหรับผู้นำแฟคชั่นเท่านั้น!");
	}
	return 1;
}