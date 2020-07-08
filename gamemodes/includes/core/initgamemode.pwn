/*
//--------------------------------[INITGAMEMODE.PWN]--------------------------------
*/

InitiateGamemode()
{
	SetGameModeText(SERVER_GM_TEXT);

	SetNameTagDrawDistance(25.0);
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	
    // Textdraws
    print("[Textdraws] Loading Textdraws...");
    LoadTextDraws();

	// โหลดข้อมูลจาก Database
	mysql_tquery(dbCon, "SELECT * FROM `faction`", "Faction_Load", "");
	mysql_tquery(dbCon, "SELECT * FROM `vehicle`", "Vehicle_Load", "");
	mysql_tquery(dbCon, "SELECT * FROM `entrance`", "Entrance_Load", "");

	AntiDeAMX();

	print("\n-------------------------------------------");
	print("Keki Project");
	print("Copyright (C) 2018 Ak-kawit \"Aktah\" Tahae");
	print("-------------------------------------------\n");
	print("Successfully initiated the gamemode...");
}