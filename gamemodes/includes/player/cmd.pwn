/*
	Player Commands:
		- HELP
		- BWMode
		- Other
*/

//=====================================[ HELP ]============================================
CMD:help(playerid) {
   	SendClientMessage(playerid, COLOR_GREEN,"___________Keki Project___________");
    SendClientMessage(playerid, COLOR_LIGHTCYAN,"[ตัวละคร] /stats, /changespawn");
	return 1;
}
//=====================================[ BWMode ]============================================
CMD:respawnme(playerid)
{
	if(!isDeathmode{playerid})
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณยังไม่ตาย");
		
	if(InjuredTime[playerid] <= 0)
	{
		bf_off(player_bf[playerid], IS_SPAWNED);
		
		InjuredTime[playerid] = 0;
		isDeathmode{playerid} = false;
		isInjuredmode{playerid}=false;
		SetPVarInt(playerid, "MedicBill", 1);
		
		resetPlayerDamage(playerid);
		SpawnPlayer(playerid);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "กรุณารอ 60 วินาที");
	
	return 1;
}

CMD:acceptdeath(playerid, params[])
{
    if(!isInjuredmode{playerid} || isDeathmode{playerid})
 		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณไม่ได้รับบาดเจ็บ");

	if(InjuredTime[playerid] > 120)
		return SendClientMessage(playerid, COLOR_GRAD1, "   คุณต้องรอเวลาประมาณ 2 นาทีเพื่อที่จะยอมรับความตาย");

	isDeathmode{playerid} = true;
	InjuredTime[playerid] = 60;
	
    SendClientMessage(playerid, COLOR_YELLOW, "-> คุณตายแล้วในขณะนี้ คุณจำเป็นต้องรอ 60 วินาทีและหลังจากนั้นคุณถึงจะสามารถ /respawnme");

    if (!IsPlayerInAnyVehicle(playerid)) 
		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 0, 0, 1, 0, 1);
    

	return 1;
}
//=====================================[ BWMode ]============================================


//=====================================[ Other ]============================================
CMD:stats(playerid, params[])
{
	ShowStats(playerid,playerid);
	return 1;
}

ShowStats(playerid,targetid)
{
	new string[1000];
	format(string, sizeof string, ""EMBED_WHITE"ชื่อ "EMBED_YELLOW"%s "EMBED_WHITE"- [%s]"EMBED_GRAD"", ReturnPlayerName(targetid), ReturnDateTime(2));
	format(string, sizeof string, "%s\n\nตัวละคร | กลุ่ม:["EMBED_WHITE"%d"EMBED_GRAD"]["EMBED_WHITE"%s"EMBED_GRAD"] ยศ:["EMBED_WHITE"%s"EMBED_GRAD"] อาชีพ:["EMBED_WHITE"%s"EMBED_GRAD"]", string, playerData[targetid][pFactionID] + 1, Faction_GetName(targetid), Faction_GetRank(targetid), "ไม่มี");
	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "สถิติ", string, "ปิด", "");
}

CMD:changespawn(playerid) {
	Dialog_Show(playerid, ChangeSpawnDialog, DIALOG_STYLE_LIST, "เปลี่ยนย้ายจุดเกิด", "ตัวเมือง\nบ้าน\nแฟคชั่น", "เลือก", "ปิด");
	return 1;
}

Dialog:ChangeSpawnDialog(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		if(SPAWN_POINT_PROPERTY == listitem || (SPAWN_POINT_FACTION == listitem && playerData[playerid][pFactionID] == -1)) {
			SendFormatMessage(playerid, COLOR_LIGHTRED, "พบข้อผิดพลาด"EMBED_WHITE": คุณไม่มี%s", inputtext);
			return 1;
		}
		playerData[playerid][pSpawnType] = listitem;
		SendFormatMessage(playerid, -1, "คุณได้ย้ายจุดเกิดของคุณไปยัง %s", inputtext);
	}
	return 1;
}
//=====================================[ Other ]============================================