#include <YSI\y_hooks>

#define MAX_ADMIN_VEHICLES 50
#define MAX_DYNAMIC_VEHICLES 1000

new AdminSpawnedVehicles[MAX_ADMIN_VEHICLES];
new Iterator:Iter_ServerCar<MAX_DYNAMIC_VEHICLES>;

enum E_VEHICLE_DATA {
    vVehicleID,
	vVehicleModelID,
	Float: vVehiclePosition[3],
	Float: vVehicleRotation,
	vVehicleFaction,
    vVehicleFactionID,
	vVehicleColour[2],
	vVehicleScriptID,
	vVehicleWorld,
	vVehicleInterior
}
new vehicleVariables[MAX_DYNAMIC_VEHICLES][E_VEHICLE_DATA];

// Color Selection
new const ColorMenuSelect[][]={
{0,0},{1,0},{8,0},{11,0},{13,0},{14,0},{15,0},{19,0},{23,0},{24,0},{25,0},{26,0},{27,0},{29,0},{33,0},{34,0},{35,0},{38,0},{39,0},{49,0},{50,0},{52,0},{56,0},{60,0},{63,0},{64,0},{67,0},{71,0},{90,0},{96,0},{109,0},{111,0},{118,0},{122,0},{138,0},{140,0},{148,0},{157,0},{192,0},{193,0},{196,0},{213,0},{250,0},{251,0},{252,0},{253,0},{255,0},{3,1},{17,1},{42,1},{43,1},{45,1},{58,1},{70,1},{82,1},{117,1},{121,1},{124,1},{2,2},{7,2},{10,2},{12,2},{20,2},{28,2},{32,2},
{53,2},{54,2},{59,2},{79,2},{87,2},{93,2},{94,2},{95,2},{100,2},{101,2},{103,2},{106,2},{108,2},{109,2},{112,2},{116,2},{125,2},{130,2},{135,2},{139,2},{152,2},{166,2},{198,2},{201,2},{205,2},{208,2},{209,2},{210,2},{223,2},{246,2},{16,3},{28,3},{44,3},{51,3},{83,3},{86,3},{114,3},{137,3},{145,3},{151,3},{153,3},{154,3},{160,3},{186,3},{187,3},{188,3},{189,3},{191,3},{202,3},{215,3},{226,3},{227,3},{229,3},{234,3},{235,3},{241,3},{243,3},{245,3},{6,4},{65,4},{142,4},
{194,4},{195,4},{197,4},{221,4},{228,4},{6,5},{158,5},{175,5},{181,5},{182,5},{183,5},{219,5},{222,5},{239,5},{30,6},{31,6},{40,6},{41,6},{58,6},{62,6},{66,6},{74,6},{78,6},{84,6},{88,6},{113,6},{119,6},{123,6},{129,6},{131,6},{149,6},{159,6},{168,6},{173,6},{174,6},{180,6},{212,6},{224,6},{230,6},{238,6},{244,6},{254,6},{147,7},{167,7},{171,7},{179,7},{190,7},{211,7},{232,7},{233,7},{237,7},{5,8},{126,8},{146,8},{176,8},{177,8},{178,8},{46,9},{47,9},{48,9},{55,9},
{58,9},{61,9},{68,9},{69,9},{73,9},{76,9},{77,9},{81,9},{89,9},{99,9},{102,9},{104,9},{107,9},{110,9},{120,9},{138,9},{140,9},{141,9},{157,9},{192,9},{193,9},{196,9},{213,9},{250,9},{253,9}
};

new const ColorMenuInfo[][] = {
{1, "Basic"},
{3, "Red"},
{2, "Blue"},
{16, "Green"},
{6, "Yellow"},
{158, "Orange"},
{30, "Brown"},
{179, "Purple"},
{190, "Pink"},
{110, "Tan"}
};

new const g_arrSelectColors[256] = {
	0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
	0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
	0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
	0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
	0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
	0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
	0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
	0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
	0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
	0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
	0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
	0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
	0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF, 0x177517FF, 0x210606FF,
	0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF, 0xB7B7B7FF, 0x464C8DFF,
	0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF, 0x1E1D13FF, 0x1E1306FF,
	0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF, 0x992E1EFF, 0x2C1E08FF,
	0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF, 0x481A0EFF, 0x7A7399FF,
	0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF, 0x7B3E7EFF, 0x3C1737FF,
	0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF, 0x163012FF, 0x16301BFF,
	0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF, 0x2B3C99FF, 0x3A3A0BFF,
	0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF, 0x2C5089FF, 0x15426CFF,
	0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF, 0x995C52FF, 0x99581EFF,
	0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF, 0x96821DFF, 0x197F19FF,
	0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF, 0x8A653AFF, 0x732617FF,
	0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF, 0x561A28FF, 0x4E0E27FF,
	0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF
};

new
	PlayerText:ColorSelectText[MAX_PLAYERS],
	PlayerText:ColorSelectLeft[MAX_PLAYERS],
	PlayerText:ColorSelectRight[MAX_PLAYERS],
	PlayerText:ColorSelection[MAX_PLAYERS][8];

new
	PlayerText:ColorSelectText2[MAX_PLAYERS],
	PlayerText:ColorSelectLeft2[MAX_PLAYERS],
	PlayerText:ColorSelectRight2[MAX_PLAYERS],
	PlayerText:ColorSelection2[MAX_PLAYERS][8];

new bool:ColorSelectShow[MAX_PLAYERS char],
    ColorSelectItem[MAX_PLAYERS],
	ColorSelectPage[MAX_PLAYERS],
	ColorSelectPages[MAX_PLAYERS],
	ColorSelect[MAX_PLAYERS] = -1,
	ColorSelectListener[MAX_PLAYERS][8];

new bool:ColorSelectShow2[MAX_PLAYERS char],
    ColorSelectItem2[MAX_PLAYERS],
	ColorSelectPage2[MAX_PLAYERS],
	ColorSelectPages2[MAX_PLAYERS],
	ColorSelect2[MAX_PLAYERS] = -1,
	ColorSelectListener2[MAX_PLAYERS][8];

flags:veh(CMD_ADM3)
CMD:veh(playerid, params[]) {

    new
    	carid[32],
    	Float: carSpawnPos[4],
    	color1,
    	color2
    ;

    if (!sscanf(params, "s[32]I(-1)I(-1)", carid, color1, color2)) {

        if ((carid[0] = GetVehicleModelByName(carid)) == 0)
            return SendClientMessage(playerid, COLOR_GREY, "   เลขยานพาหนะต้องไม่ต่ำกว่า 400 หรือมากกว่า 611 !");

        for(new i=0;i!=MAX_ADMIN_VEHICLES;i++) if(!AdminSpawnedVehicles[i])
        {
        	GetPlayerPos(playerid, carSpawnPos[0], carSpawnPos[1], carSpawnPos[2]);
        	GetPlayerFacingAngle(playerid, carSpawnPos[3]);

            if(color1 < 0) {
                color1 = random(126);
            }
            if(color2 < 0) {
                color2 = random(126);
            }
            
        	AdminSpawnedVehicles[i] = CreateVehicle(carid[0], carSpawnPos[0], carSpawnPos[1], carSpawnPos[2], carSpawnPos[3], color1, color2, -1);
        	LinkVehicleToInterior(AdminSpawnedVehicles[i], GetPlayerInterior(playerid));
        	SetVehicleVirtualWorld(AdminSpawnedVehicles[i], GetPlayerVirtualWorld(playerid));

        	PutPlayerInVehicle(playerid, AdminSpawnedVehicles[i], 0);

        	new
        		engine,
        		lights,
        		alarm,
        		doors,
        		bonnet,
        		boot,
        		objective;

        	GetVehicleParamsEx(AdminSpawnedVehicles[i], engine, lights, alarm, doors, bonnet, boot, objective);
        	SetVehicleParamsEx(AdminSpawnedVehicles[i], 1, lights, alarm, doors, bonnet, boot, objective);

        	switch(carid[0]) {
        		case 427, 428, 432, 601, 528: SetVehicleHealth(AdminSpawnedVehicles[i], 5000.0);
        	}

        	SendFormatMessage(playerid, -1, "  คุณได้เสก "EMBED_YELLOW"%s"EMBED_WHITE" (ไอดี "EMBED_ORANGE"%d"EMBED_WHITE")", ReturnVehicleModelName(carid[0]), AdminSpawnedVehicles[i]);

        	break;
        }
    }
    else {
        SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
        SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /veh [ไอดีรุ่น/ชื่อบางส่วน] <สีที่ 1> <สีที่ 2>");
    }
	return 1;
}

flags:davehs(CMD_ADM3)
CMD:davehs(playerid, params[]) {
    new vehCount;
    for(new i=0;i!=MAX_ADMIN_VEHICLES;i++) {
        if(AdminSpawnedVehicles[i]) {
            DestroyVehicle(AdminSpawnedVehicles[i]);
    		AdminSpawnedVehicles[i] = 0;
    		vehCount++;
    	}
    }

    if(vehCount)
    	SendAdminMessage(COLOR_YELLOW, "AdmWarning: %s ได้ทำลายยานพาหนะแอดมินทั้งหมด %d คัน", ReturnPlayerName(playerid), vehCount);
	return 1;
}

flags:daveh(CMD_ADM3)
CMD:daveh(playerid, params[]) {
    new id, bool:success;
    if (sscanf(params, "d", id))
    {
     	if (IsPlayerInAnyVehicle(playerid))
    	 	id = GetPlayerVehicleID(playerid);
    	else {
            SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
            SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /daveh [ไอดียานพาหนะ]");
            return 1;
        }
    }

    for(new i=0;i!=MAX_ADMIN_VEHICLES;i++) if(AdminSpawnedVehicles[i] == id)
    {
    	SendFormatMessage(playerid, COLOR_GRAD1, "   คุณได้ทำลายยานพาหนะไอดี "EMBED_ORANGE"%d", AdminSpawnedVehicles[i]);
    	DestroyVehicle(AdminSpawnedVehicles[i]);
    	AdminSpawnedVehicles[i] = 0;
    	success = true;
    	return 1;
    }

    if(!success) SendClientMessage(playerid, COLOR_LIGHTRED, "คุณไม่ได้อยู่ในยานพาหนะที่แอดมินเสกขึ้น");

	return 1;
}

flags:vehcmds(CMD_MM)
CMD:vehcmds(playerid) {
    SendClientMessage(playerid, COLOR_GRAD1, "คำสั่ง: /saveveh (ใช้กับรถเสก /veh), /removeveh");
    return 1;
}

flags:removeveh(CMD_MM)
CMD:removeveh(playerid, params[])
{
	new
	    id = 0;

	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else {
			SendClientMessage(playerid, COLOR_GREEN, "___________________________[คำสั่ง]___________________________");
			SendClientMessage(playerid, COLOR_GRAD1, "การใช้: /removeveh [ไอดี (/dl)]");
			return 1;
		}
	}
	if((id = Vehicle_GetID(id)) != -1)
	{
		new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `vehicle` WHERE `vehicleID` = '%d'", vehicleVariables[id][vVehicleID]);
		mysql_tquery(dbCon, string);

		if(vehicleVariables[id][vVehicleFactionID] != -1) {
			Log(a_action_log, INFO, "%s: ลบยานพาหนะ %s(SQLID %d) ของแฟคชั่น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], factionData[vehicleVariables[id][vVehicleFactionID]][fName], factionData[vehicleVariables[id][vVehicleFactionID]][fID]);
		}
		else {
			Log(a_action_log, INFO, "%s: ลบยานพาหนะ %s(SQLID %d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID]);
		}

		SendFormatMessage(playerid, COLOR_GRAD1, "   คุณได้ทำลายยานพาหนะไอดี %d", vehicleVariables[id][vVehicleScriptID]);
		DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);
		Iter_Remove(Iter_ServerCar, id);
	}
	else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องเป็นยานพาหนะ Dynamic เท่านั้น");
	}
	return 1;
}

flags:saveveh(CMD_MM)
CMD:saveveh(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
    	return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณต้องอยู่บนยานพาหนะเพื่อบันทึกมัน");

    if(GetPVarInt(playerid, "sCc") == GetPlayerVehicleID(playerid)) {
    	new i = Iter_Free(Iter_ServerCar);
        if(i != -1)
    	{

            // เปลี่ยนรถเสกแอดมินเป็นรถ Dynamic
            new
                vehicleid = GetPlayerVehicleID(playerid); // x, y, z + z angle

            new bool:checked=false;
    	    for(new x=0;x!=MAX_ADMIN_VEHICLES;x++) {
    	    	if(AdminSpawnedVehicles[x] == vehicleid) {
     	    		AdminSpawnedVehicles[x] = 0;
                    checked = true;

                    new
                        queryString[255],
                        Float: vPos[4];

                    GetVehiclePos(vehicleid, vPos[0], vPos[1], vPos[2]);
                    GetVehicleZAngle(vehicleid, vPos[3]);

                    format(queryString, sizeof(queryString), "INSERT INTO vehicle (vehicleModelID, vehiclePosX, vehiclePosY, vehiclePosZ, vehiclePosRotation) VALUES('%d', '%f', '%f', '%f', '%f')", GetVehicleModel(vehicleid), vPos[0], vPos[1], vPos[2], vPos[3]);
                    mysql_query(dbCon,queryString);

                    new insertid = cache_insert_id();

                    vehicleVariables[i][vVehicleID] = insertid;
                    vehicleVariables[i][vVehicleModelID] = GetVehicleModel(vehicleid);
                    vehicleVariables[i][vVehiclePosition][0] = vPos[0];
                    vehicleVariables[i][vVehiclePosition][1] = vPos[1];
                    vehicleVariables[i][vVehiclePosition][2] = vPos[2];
                    vehicleVariables[i][vVehicleRotation] = vPos[3];
                    vehicleVariables[i][vVehicleFaction] = 0;
                    vehicleVariables[i][vVehicleFactionID] = -1;
                    vehicleVariables[i][vVehicleScriptID] = vehicleid;

                    ChangeVehicleColor(vehicleid, vehicleVariables[i][vVehicleColour][0], vehicleVariables[i][vVehicleColour][1]);

                    Iter_Add(Iter_ServerCar, i);

                    DeletePVar(playerid, "sCc");

                    SendFormatMessage(playerid, COLOR_GRAD1, "%s ถูกเพิ่มเป็นยานพาหนะ Dynamic เรียบร้อยแล้ว !", ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]));

                    break;
    	    	}
    	    }
            if(!checked) {
                SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องใช้ยานพาหนะเสกของแอดมินเท่านั้น (/veh)");
            }
    	    return 1;
    	}
    }
    else {
        SetPVarInt(playerid, "sCc", GetPlayerVehicleID(playerid));
        return SendClientMessage(playerid, COLOR_LIGHTRED, "คุณแน่ใจหรือว่าจะบันทึกยานพาหนะนี้? พิมพ์คำสั่งนี้อีกครั้งเพื่อยืนยัน");
    }
	return 1;
}

flags:editveh(CMD_MM)
CMD:editveh(playerid, params[])
{
    new id = -1;
    if((id = Vehicle_GetID(GetPlayerVehicleID(playerid))) != -1)
	{
        SetPVarInt(playerid, "VehicleDynamicID", id);    
        EditVehicleMenu(playerid);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "ต้องเป็นยานพาหนะ Dynamic เท่านั้น");
	}
    return 1;
}

EditVehicleMenu(playerid) {
    new caption[80];
    format(caption, sizeof caption, "แก้ไขยานพาหนะ Dynamic: "EMBED_ORANGE"%d", GetPVarInt(playerid, "VehicleDynamicID"));
    return Dialog_Show(playerid, VehicleEditDialog, DIALOG_STYLE_LIST, caption, "ย้ายจุดเกิด\nสำหรับแฟคชั่น..\nเปลี่ยนสี", "เลือก", "ยกเลิก");
}

Dialog:VehicleEdit_Faction(playerid, response, listitem, inputtext[])
{
	if(response) {
        if(GetPVarType(playerid, "VehicleDynamicID")) {
            new id = GetPVarInt(playerid, "VehicleDynamicID");
            new factionid = strval(inputtext) - 1;

            if(vehicleVariables[id][vVehicleFactionID] != factionid) {

                if(factionid >= 0) {
                    if(Iter_Contains(Iter_Faction, factionid)) {
                    	vehicleVariables[id][vVehicleFactionID] = factionid;
						vehicleVariables[id][vVehicleFaction] = factionData[factionid][fID];
                    }
					else {
						return EditVehicleMenu(playerid);
					}
                }
                else {
                    vehicleVariables[id][vVehicleFactionID] = -1;
					vehicleVariables[id][vVehicleFaction] = 0;
                }
                Vehicle_Save(id);
                SendFormatMessage(playerid, COLOR_GRAD, " เจ้าของยานพาหนะ "EMBED_WHITE"%s"EMBED_GRAD" ถูกเปลี่ยนเป็น %s"EMBED_GRAD"(%d)", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), Faction_Name(vehicleVariables[id][vVehicleFactionID]), vehicleVariables[id][vVehicleFactionID] + 1);
                Log(a_action_log, INFO, "%s: เปลี่ยนเจ้าของยานพาหนะ %s(%d) เป็น %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID], Faction_Name(vehicleVariables[id][vVehicleFactionID]), vehicleVariables[id][vVehicleFactionID] + 1);
            }
        }
    }
    return EditVehicleMenu(playerid);
}
Dialog:VehicleEditDialog(playerid, response, listitem, inputtext[])
{
	if(response) {
	    if(!(playerData[playerid][pCMDPermission] & CMD_MM)) {
	    	SendClientMessage(playerid, COLOR_LIGHTRED, "เกิดข้อผิดพลาด"EMBED_WHITE": คุณไม่ได้รับอนุญาตให้ใช้ฟังก์ชั่นการแก้ไข "EMBED_RED"(MANAGEMENT ONLY)");
	    	return EditVehicleMenu(playerid);
	    }
        if(GetPVarType(playerid, "VehicleDynamicID")) {
            new id = GetPVarInt(playerid, "VehicleDynamicID");
            switch(listitem) {
                case 0: { // ย้ายจุดเกิด

                    new vehicleid = vehicleVariables[id][vVehicleScriptID];
                    GetVehiclePos(vehicleid, vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
                    GetVehicleZAngle(vehicleid, vehicleVariables[id][vVehicleRotation]);

                    vehicleVariables[id][vVehicleWorld]=GetPlayerVirtualWorld(playerid);
                    vehicleVariables[id][vVehicleInterior]=GetPlayerInterior(playerid);

                    Vehicle_Save(id);

                    DestroyVehicle(vehicleVariables[id][vVehicleScriptID]);
            
                    vehicleVariables[id][vVehicleScriptID] = CreateVehicle(vehicleVariables[id][vVehicleModelID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], 60000);

                    LinkVehicleToInterior(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleInterior]);
                    SetVehicleVirtualWorld(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleWorld]);

                    if(vehicleVariables[id][vVehicleFactionID] != -1) {
                        SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], factionData[vehicleVariables[id][vVehicleFactionID]][fShortName]);
                    }
                    else {
                        new plate[8];
                        format(plate, 8, "%s", Vehicle_RandomPlate());
                        SetVehicleNumberPlate(vehicleVariables[id][vVehicleScriptID], plate);
                    }
                    PutPlayerInVehicle(playerid, vehicleVariables[id][vVehicleScriptID], 0);
                        
                    // Waiting for engine system
                    new
                        engine,
                        lights,
                        alarm,
                        doors,
                        bonnet,
                        boot,
                        objective;

                    GetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], engine, lights, alarm, doors, bonnet, boot, objective);
                    SetVehicleParamsEx(vehicleVariables[id][vVehicleScriptID], 1, lights, alarm, doors, bonnet, boot, objective);

                    SendFormatMessage(playerid, COLOR_GRAD, " จุดเกิดของ "EMBED_WHITE"%s"EMBED_GRAD" ถูกเปลี่ยนมายังที่อยู่ปัจจุบันของคุณแล้ว", ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]));
                    Log(a_action_log, INFO, "%s: เปลี่ยนจุดเกิดของ %s(%d)", ReturnPlayerName(playerid), ReturnVehicleModelName(vehicleVariables[id][vVehicleModelID]), vehicleVariables[id][vVehicleID]);

                }
                case 1: {
                    new caption[128];
                    format(caption, sizeof caption, ""EMBED_WHITE"แก้ไขยานพาหนะ Dynamic: "EMBED_ORANGE"%d"EMBED_WHITE" -> แฟคชั่น", id);
                    Dialog_Show(playerid, VehicleEdit_Faction, DIALOG_STYLE_INPUT, caption, ""EMBED_WHITE"เจ้าของในปัจจุบัน: "EMBED_WHITE"%s"EMBED_WHITE"\n\nรายละเอียดแฟคชั่น "EMBED_YELLOW"/viewfactions"EMBED_WHITE" (ปรับเป็น "EMBED_ORANGE"0"EMBED_WHITE" เพื่อให้ทุกคนสามารถใช้ได้)\nกรอกไอดีแฟคชั่นที่ต้องการให้เป็นเจ้าของในกล่องด้านล่างนี้:", "ปรับ", "ยกเลิก", Faction_Name(vehicleVariables[id][vVehicleFactionID]));    
                }
                case 2: {
                    ColorSelect[playerid] = -1;
                    ColorSelect2[playerid] = -1;
                    ShowPlayerColorSelection(playerid, 1);
                    ShowPlayerColorSelection2(playerid, 1);
                }
            }
        }
	}
    else {
        DeletePVar(playerid, "VehicleDynamicID");
    }
	return 1;
}

forward Vehicle_Load();
public Vehicle_Load()
{
    new
	    rows;

	cache_get_row_count(rows);

	for (new i = 0; i < rows; i ++) if (i < MAX_VEHICLES)
	{
	    cache_get_value_name_int(i, "vehicleID", vehicleVariables[i][vVehicleID]);
	    cache_get_value_name_int(i, "vehicleModelID", vehicleVariables[i][vVehicleModelID]);
	    cache_get_value_name_float(i, "vehiclePosX", vehicleVariables[i][vVehiclePosition][0]);
	    cache_get_value_name_float(i, "vehiclePosY", vehicleVariables[i][vVehiclePosition][1]);
	    cache_get_value_name_float(i, "vehiclePosZ", vehicleVariables[i][vVehiclePosition][2]);
	    cache_get_value_name_float(i, "vehiclePosRotation", vehicleVariables[i][vVehicleRotation]);

	    cache_get_value_name_int(i, "vehicleFaction", vehicleVariables[i][vVehicleFaction]);

	    cache_get_value_name_int(i, "vehicleCol1", vehicleVariables[i][vVehicleColour][0]);
	    cache_get_value_name_int(i, "vehicleCol2", vehicleVariables[i][vVehicleColour][1]);
	    cache_get_value_name_int(i, "vehicleWorld", vehicleVariables[i][vVehicleWorld]);
	    cache_get_value_name_int(i, "vehicleInterior", vehicleVariables[i][vVehicleInterior]);
	    
	    vehicleVariables[i][vVehicleFactionID] = -1;

	    if(vehicleVariables[i][vVehicleColour][0] < 0) {
	    	vehicleVariables[i][vVehicleColour][0] = random(126);
	    }
	    if(vehicleVariables[i][vVehicleColour][1] < 0) {
	    	vehicleVariables[i][vVehicleColour][1] = random(126);
	    }

	    vehicleVariables[i][vVehicleScriptID] = CreateVehicle(vehicleVariables[i][vVehicleModelID], vehicleVariables[i][vVehiclePosition][0], vehicleVariables[i][vVehiclePosition][1], vehicleVariables[i][vVehiclePosition][2], vehicleVariables[i][vVehicleRotation], vehicleVariables[i][vVehicleColour][0], vehicleVariables[i][vVehicleColour][1], 60000);

	    LinkVehicleToInterior(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleInterior]);
	    SetVehicleVirtualWorld(vehicleVariables[i][vVehicleScriptID], vehicleVariables[i][vVehicleWorld]);
    
	    if(vehicleVariables[i][vVehicleFaction] != 0) {
			foreach(new x : Iter_Faction) {
				if(factionData[x][fID] == vehicleVariables[i][vVehicleFaction]) {
					vehicleVariables[i][vVehicleFactionID] = x;
				}
			}
	    	SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], factionData[vehicleVariables[i][vVehicleFactionID]][fShortName]);
	    }
	    else {
	    	new plate[8];
	    	format(plate, sizeof(plate), Vehicle_RandomPlate());
	    	SetVehicleNumberPlate(vehicleVariables[i][vVehicleScriptID], plate);
	    }

        // Waiting for engine system
        new
            engine,
            lights,
            alarm,
            doors,
            bonnet,
            boot,
            objective;

        GetVehicleParamsEx(vehicleVariables[i][vVehicleScriptID], engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleVariables[i][vVehicleScriptID], 1, lights, alarm, doors, bonnet, boot, objective);

        Iter_Add(Iter_ServerCar, i);
	}
    printf("Vehicle loaded (%d/%d)", Iter_Count(Iter_ServerCar), MAX_VEHICLES);
	return 1;
}

Vehicle_Save(id) {
	if(Iter_Contains(Iter_ServerCar, id)) {

	    GetVehiclePos(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
	    GetVehicleZAngle(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleRotation]);

        new query[MAX_STRING];
        MySQLUpdateInit("vehicle", "vehicleID", vehicleVariables[id][vVehicleID]); 
        MySQLUpdateInt(query, "vehicleModelID", vehicleVariables[id][vVehicleModelID]);
        MySQLUpdateFlo(query, "vehiclePosX", vehicleVariables[id][vVehiclePosition][0]);
        MySQLUpdateFlo(query, "vehiclePosY", vehicleVariables[id][vVehiclePosition][1]);
        MySQLUpdateFlo(query, "vehiclePosZ", vehicleVariables[id][vVehiclePosition][2]);
        MySQLUpdateFlo(query, "vehiclePosRotation", vehicleVariables[id][vVehicleRotation]);
        MySQLUpdateInt(query, "vehicleFaction", vehicleVariables[id][vVehicleFaction]);
        MySQLUpdateInt(query, "vehicleCol1", vehicleVariables[id][vVehicleColour][0]);
        MySQLUpdateInt(query, "vehicleCol2", vehicleVariables[id][vVehicleColour][1]);
        MySQLUpdateInt(query, "vehicleWorld", vehicleVariables[id][vVehicleWorld]);
        MySQLUpdateInt(query, "vehicleInterior", vehicleVariables[id][vVehicleInterior]);
		MySQLUpdateFinish(query);
	}
	return 1;
}

static Vehicle_RandomPlate()
{
	const len = 7;
	new plate[len+1];
	for (new i = 0; i < len; i++)
	{
	    if (i > 0 && i < 4) // letter or number?
	    {
	     	plate[i] = 'A' + random(26);
	    }
	    else
	    { // number
	    	plate[i] = '0' + random(10);
	    }
	}
	return plate;
}

Vehicle_GetID(id)
{
	foreach(new i : Iter_ServerCar) if (vehicleVariables[i][vVehicleScriptID] == id) {
		return i;
	}
	return -1;
}

hook OP_StateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_ONFOOT) {
	    DeletePVar(playerid, "VehicleDynamicID");
    }
    return 1;
}

hook OP_Connect(playerid) {
	new
	    Float:x = 160.0,
	    Float:y = 280.0;

	for (new i = 0; i < 8; i ++)
	{
		if (i > 0 && (i == 4))
		{
		    x = 160.0;
			y = 280.0+14.0;
		}
		else if(i > 0)
		{
			x += 13;
		}
 		ColorSelection[playerid][i] = CreatePlayerTextDraw(playerid, x, y, "_");
		PlayerTextDrawBackgroundColor(playerid, ColorSelection[playerid][i], 0);
		PlayerTextDrawFont(playerid, ColorSelection[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, ColorSelection[playerid][i], 13, 14);
		PlayerTextDrawColor(playerid, ColorSelection[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawUseBox(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, ColorSelection[playerid][i], 0);
		PlayerTextDrawTextSize(playerid, ColorSelection[playerid][i], 13.0000, 14.000000);
		PlayerTextDrawSetSelectable(playerid, ColorSelection[playerid][i], 1);
		PlayerTextDrawSetPreviewModel(playerid, ColorSelection[playerid][i], 19300);

		ColorSelection2[playerid][i] = CreatePlayerTextDraw(playerid, 260+x, y, "_");
		PlayerTextDrawBackgroundColor(playerid, ColorSelection2[playerid][i], 0);
		PlayerTextDrawFont(playerid, ColorSelection2[playerid][i], 5);
		PlayerTextDrawLetterSize(playerid, ColorSelection2[playerid][i], 13, 14);
		PlayerTextDrawColor(playerid, ColorSelection2[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawUseBox(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, ColorSelection2[playerid][i], 0);
		PlayerTextDrawTextSize(playerid, ColorSelection2[playerid][i], 13.0000, 14.000000);
		PlayerTextDrawSetSelectable(playerid, ColorSelection2[playerid][i], 1);
		PlayerTextDrawSetPreviewModel(playerid, ColorSelection2[playerid][i], 19300);
	}
	ColorSelectText[playerid] = CreatePlayerTextDraw(playerid, 185.599990, 311.795379, "Primary Colors");
	PlayerTextDrawAlignment(playerid,ColorSelectText[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,ColorSelectText[playerid], 255);
	PlayerTextDrawFont(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawLetterSize(playerid,ColorSelectText[playerid], 0.389999, 1.699998);
	PlayerTextDrawColor(playerid,ColorSelectText[playerid], -1);
	PlayerTextDrawSetOutline(playerid,ColorSelectText[playerid], 0);
	PlayerTextDrawSetProportional(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawSetShadow(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawUseBox(playerid,ColorSelectText[playerid], 1);
	PlayerTextDrawBoxColor(playerid,ColorSelectText[playerid], 0);
	PlayerTextDrawTextSize(playerid,ColorSelectText[playerid], 190.000000, 128.000000);
	PlayerTextDrawSetSelectable(playerid,ColorSelectText[playerid], 1);


	ColorSelectLeft[playerid] = CreatePlayerTextDraw(playerid, 145.599945, 287.422149, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, ColorSelectLeft[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectLeft[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectLeft[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectLeft[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectLeft[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectLeft[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectLeft[playerid], 4);
	PlayerTextDrawSetSelectable(playerid, ColorSelectLeft[playerid], true);


	ColorSelectRight[playerid] = CreatePlayerTextDraw(playerid, 212.200164, 287.422149, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, ColorSelectRight[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectRight[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectRight[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectRight[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectRight[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectRight[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectRight[playerid], 4);
	PlayerTextDrawSetProportional(playerid, ColorSelectRight[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ColorSelectRight[playerid], true);

	ColorSelectText2[playerid] = CreatePlayerTextDraw(playerid, 260+185.599990, 311.795379, "Secondary Colors");
	PlayerTextDrawAlignment(playerid,ColorSelectText2[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,ColorSelectText2[playerid], 255);
	PlayerTextDrawFont(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawLetterSize(playerid,ColorSelectText2[playerid], 0.389999, 1.699998);
	PlayerTextDrawColor(playerid,ColorSelectText2[playerid], -1);
	PlayerTextDrawSetOutline(playerid,ColorSelectText2[playerid], 0);
	PlayerTextDrawSetProportional(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawSetShadow(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawUseBox(playerid,ColorSelectText2[playerid], 1);
	PlayerTextDrawBoxColor(playerid,ColorSelectText2[playerid], 0);
	PlayerTextDrawTextSize(playerid,ColorSelectText2[playerid], 190.000000, 128.000000);
	PlayerTextDrawSetSelectable(playerid,ColorSelectText2[playerid], 1);

	ColorSelectLeft2[playerid] = CreatePlayerTextDraw(playerid, 260+145.599945, 287.422149, "ld_beat:left");
	PlayerTextDrawLetterSize(playerid, ColorSelectLeft2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectLeft2[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectLeft2[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectLeft2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectLeft2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectLeft2[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectLeft2[playerid], 4);
	PlayerTextDrawSetSelectable(playerid, ColorSelectLeft2[playerid], true);

	ColorSelectRight2[playerid] = CreatePlayerTextDraw(playerid, 260+212.200164, 287.422149, "ld_beat:right");
	PlayerTextDrawLetterSize(playerid, ColorSelectRight2[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, ColorSelectRight2[playerid], 14.399991, 14.933345);
	PlayerTextDrawAlignment(playerid, ColorSelectRight2[playerid], 1);
	PlayerTextDrawColor(playerid, ColorSelectRight2[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ColorSelectRight2[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ColorSelectRight2[playerid], 0);
	PlayerTextDrawFont(playerid, ColorSelectRight2[playerid], 4);
	PlayerTextDrawSetProportional(playerid, ColorSelectRight2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ColorSelectRight2[playerid], true);    
    return 1;
}


hook OP_ClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if (ColorSelectShow{playerid} || ColorSelectShow2{playerid})
		{
			ClearColorSelect(playerid);
		}
    }
    return 1;
}

hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(ColorSelectShow{playerid})
	{
		if(playertextid == PlayerText:INVALID_TEXT_DRAW)
		{
			ClearColorSelect(playerid);
		}
		else if(playertextid == ColorSelectText[playerid])
		{
			ColorSelect[playerid] = -1;
			ShowPlayerColorSelection(playerid, 1);
			return 1;
		}

		else if(playertextid == ColorSelectLeft[playerid])
		{
			if (ColorSelectPage[playerid] < 2)
				return 0;

			else
				ShowPlayerColorSelection(playerid, ColorSelectPage[playerid] - 1);
		}

		else if(playertextid == ColorSelectRight[playerid])
		{
			if (ColorSelectPage[playerid] == ColorSelectPages[playerid])
				return 0;

			else
				ShowPlayerColorSelection(playerid, ColorSelectPage[playerid] + 1);
		}

		for(new i = 0; i < 8; i++)
		{
			if(playertextid == ColorSelection[playerid][i])
			{
				if(ColorSelect[playerid] == -1)
				{
					ColorSelect[playerid] = ColorSelectListener[playerid][i];
					ShowPlayerColorSelection(playerid, 1);

				}
				else
				{
                    if(GetPVarType(playerid, "VehicleDynamicID")) {
                        new id = GetPVarInt(playerid, "VehicleDynamicID"); 
                        vehicleVariables[id][vVehicleColour][0] = ColorSelectListener[playerid][i];
                        ChangeVehicleColor(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1]);
                    }          
				}
				break;
			}
		}
	}
	if(ColorSelectShow2{playerid})
	{
		if(playertextid == PlayerText:INVALID_TEXT_DRAW)
		{
			ClearColorSelect(playerid);
		}
		else if(playertextid == ColorSelectText2[playerid])
		{
			ColorSelect2[playerid] = -1;
			ShowPlayerColorSelection2(playerid, 1);
			return 1;
		}

		else if(playertextid == ColorSelectLeft2[playerid])
		{
			if (ColorSelectPage2[playerid] < 2)
				return 0;

			else
				ShowPlayerColorSelection2(playerid, ColorSelectPage2[playerid] - 1);
		}

		else if(playertextid == ColorSelectRight2[playerid])
		{
			if (ColorSelectPage2[playerid] == ColorSelectPages2[playerid])
				return 0;

			else
				ShowPlayerColorSelection2(playerid, ColorSelectPage2[playerid] + 1);
		}

		for(new i = 0; i < 8; i++)
		{
			if(playertextid == ColorSelection2[playerid][i])
			{
				if(ColorSelect2[playerid] == -1)
				{
					ColorSelect2[playerid] = ColorSelectListener2[playerid][i];
					ShowPlayerColorSelection2(playerid, 1);

				}
				else
				{
                    if(GetPVarType(playerid, "VehicleDynamicID")) {
                        new id = GetPVarInt(playerid, "VehicleDynamicID"); 
                        vehicleVariables[id][vVehicleColour][1] = ColorSelectListener2[playerid][i];
                        ChangeVehicleColor(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1]);
                    }
				}
				break;
			}
		}
	}
    return 1;
}

ShowPlayerColorSelection(playerid, page)
{
	new string[64], selecttype, selectstart;

    ColorSelectPage[playerid] = page;

	if(ColorSelect[playerid] >= 0)
	{
        for (new i = 0; i != sizeof(ColorMenuSelect); i ++)
        {
			if(ColorMenuSelect[i][1] == ColorSelect[playerid])
			{
			    if(!selectstart)
			    {
			        selectstart = i + (8 * (page-1));
			    }
				selecttype++;
			}
		}

		ColorSelectItem[playerid] = selecttype;
		ColorSelectPages[playerid] = floatround(floatdiv(ColorSelectItem[playerid], 8), floatround_ceil);

	}
	else
	{
        selectstart = 8 * (page-1);
		ColorSelectItem[playerid] = sizeof(ColorMenuInfo);
		ColorSelectPages[playerid] = floatround(floatdiv(ColorSelectItem[playerid], 8), floatround_ceil);
    }

	for(new i = 0 ; i < 8 ; i++ )
	{
		PlayerTextDrawHide(playerid, ColorSelection[playerid][i]);
	}
	PlayerTextDrawHide(playerid, ColorSelectText[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectLeft[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectRight[playerid]);

	new start = (8 * (page-1));

	for (new i = start; i != start + 8 && i < ColorSelectItem[playerid]; i ++)
	{
	    if(ColorSelect[playerid] >= 0)
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection[playerid][i-start], g_arrSelectColors[ColorMenuSelect[selectstart+i-start][0]]);
	    	ColorSelectListener[playerid][i-start] = ColorMenuSelect[selectstart+i-start][0];

	    }
	    else
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection[playerid][i-start], g_arrSelectColors[ColorMenuInfo[selectstart+i-start][0]]);
		    ColorSelectListener[playerid][i-start] = i;

	    }
	    PlayerTextDrawShow(playerid, ColorSelection[playerid][i-start]);
	}

	if(ColorSelect[playerid] >= 0)
	{
		format(string, sizeof(string),"%s (%d/%d)", ColorMenuInfo[ColorSelect[playerid]][1], page, ColorSelectPages[playerid]);
		PlayerTextDrawColor(playerid,ColorSelectText[playerid], g_arrSelectColors[ColorMenuInfo[ColorSelect[playerid]][0]]);
		PlayerTextDrawSetString(playerid, ColorSelectText[playerid], string);
	}
	else
	{
	    PlayerTextDrawColor(playerid,ColorSelectText[playerid], -1);
		PlayerTextDrawSetString(playerid, ColorSelectText[playerid], "Primary Colors");
	}
	PlayerTextDrawShow(playerid, ColorSelectText[playerid]);


	if(page-1 != 0)
	{
		PlayerTextDrawShow(playerid, ColorSelectLeft[playerid]);
	}
	if(page+1 <= ColorSelectPages[playerid])
	{
		PlayerTextDrawShow(playerid, ColorSelectRight[playerid]);
	}

	ColorSelectShow{playerid} = true;

	SelectTextDraw(playerid, 0x585858FF);
	return 1;
}


ShowPlayerColorSelection2(playerid, page)
{
	new string[64], selecttype, selectstart;

    ColorSelectPage2[playerid] = page;

	if(ColorSelect2[playerid] >= 0)
	{
        for (new i = 0; i != sizeof(ColorMenuSelect); i ++)
        {
			if(ColorMenuSelect[i][1] == ColorSelect2[playerid])
			{
			    if(!selectstart)
			    {
			        selectstart = i + (8 * (page-1));
			    }
				selecttype++;
			}
		}

		ColorSelectItem2[playerid] = selecttype;
		ColorSelectPages2[playerid] = floatround(floatdiv(ColorSelectItem2[playerid], 8), floatround_ceil);

	}
	else
	{
        selectstart = 8 * (page-1);
		ColorSelectItem2[playerid] = sizeof(ColorMenuInfo);
		ColorSelectPages2[playerid] = floatround(floatdiv(ColorSelectItem2[playerid], 8), floatround_ceil);
    }

	for(new i = 0 ; i < 8 ; i++ )
	{
		PlayerTextDrawHide(playerid, ColorSelection2[playerid][i]);
	}
	PlayerTextDrawHide(playerid, ColorSelectText2[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectLeft2[playerid]);
	PlayerTextDrawHide(playerid, ColorSelectRight2[playerid]);

	new start = (8 * (page-1));

	for (new i = start; i != start + 8 && i < ColorSelectItem2[playerid]; i ++)
	{
	    if(ColorSelect2[playerid] >= 0)
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection2[playerid][i-start], g_arrSelectColors[ColorMenuSelect[selectstart+i-start][0]]);
	    	ColorSelectListener2[playerid][i-start] = ColorMenuSelect[selectstart+i-start][0];

	    }
	    else
	    {
			PlayerTextDrawBackgroundColor(playerid, ColorSelection2[playerid][i-start], g_arrSelectColors[ColorMenuInfo[selectstart+i-start][0]]);
		    ColorSelectListener2[playerid][i-start] = i;

	    }
	    PlayerTextDrawShow(playerid, ColorSelection2[playerid][i-start]);
	}

	if(ColorSelect2[playerid] >= 0)
	{
		format(string, sizeof(string),"%s (%d/%d)", ColorMenuInfo[ColorSelect2[playerid]][1], page, ColorSelectPages2[playerid]);
		PlayerTextDrawColor(playerid,ColorSelectText2[playerid], g_arrSelectColors[ColorMenuInfo[ColorSelect2[playerid]][0]]);
		PlayerTextDrawSetString(playerid, ColorSelectText2[playerid], string);
	}
	else
	{
	    PlayerTextDrawColor(playerid,ColorSelectText2[playerid], -1);
		PlayerTextDrawSetString(playerid, ColorSelectText2[playerid], "Secondary Colors");
	}
	PlayerTextDrawShow(playerid, ColorSelectText2[playerid]);


	if(page-1 != 0)
	{
		PlayerTextDrawShow(playerid, ColorSelectLeft2[playerid]);
	}
	if(page+1 <= ColorSelectPages2[playerid])
	{
		PlayerTextDrawShow(playerid, ColorSelectRight2[playerid]);
	}

	ColorSelectShow2{playerid} = true;

	SelectTextDraw(playerid, 0x585858FF);
	return 1;
}

ClearColorSelect(playerid)
{
	if(ColorSelectShow{playerid} || ColorSelectShow2{playerid})
	{
		for(new i = 0 ; i < 8 ; i++ )
		{
			PlayerTextDrawHide(playerid, ColorSelection[playerid][i]);
			PlayerTextDrawHide(playerid, ColorSelection2[playerid][i]);
		}
		PlayerTextDrawHide(playerid, ColorSelectText[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectLeft[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectRight[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectText2[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectLeft2[playerid]);
		PlayerTextDrawHide(playerid, ColorSelectRight2[playerid]);
		ColorSelectPage[playerid] = 1;
		ColorSelectPage2[playerid] = 1;

		ColorSelect[playerid] = -1;
		ColorSelect2[playerid] = -1;

		ColorSelectShow{playerid} = false;
		ColorSelectShow2{playerid} = false;

		if(GetPVarType(playerid, "VehicleDynamicID"))
		{
	        EditVehicleMenu(playerid);
            Vehicle_Save(GetPVarInt(playerid, "VehicleDynamicID"));
		}
	}
	return 1;
}

hook OP_EnterVehicle(playerid, vehicleid, ispassenger)
{
	foreach(new i : Iter_ServerCar) {
		if(vehicleVariables[i][vVehicleScriptID] == vehicleid && vehicleVariables[i][vVehicleFaction] != -1 && vehicleVariables[i][vVehicleFaction] != playerData[playerid][pFaction]) {

			if(playerData[playerid][pAdmin]) {
				SendFormatMessage(playerid, COLOR_GREY, "   %s (รุ่น %d, ไอดี %d) เป็นเจ้าของโดย %s"EMBED_GREY"(%d)", ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), vehicleVariables[i][vVehicleModelID], vehicleVariables[i][vVehicleScriptID], Faction_Name(vehicleVariables[i][vVehicleFactionID]), vehicleVariables[i][vVehicleFactionID] + 1);
				return 1;
			}
			else {
				SendFormatMessage(playerid, COLOR_GREY, "   %s คันนี้เป็นเจ้าของโดย %s", ReturnVehicleModelName(vehicleVariables[i][vVehicleModelID]), Faction_Name(vehicleVariables[i][vVehicleFactionID]));
				PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
				ClearAnimations(playerid);
				return 1;
			}
		}
	}
    return 1;
}