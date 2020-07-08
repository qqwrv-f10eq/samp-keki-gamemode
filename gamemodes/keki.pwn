/*
	Keki Project
		Copyright (C) 2018 Ak-kawit \"Aktah\" Tahae

	Length:
		Username: 20 // SA-MP จำกัดเพียงแค่ 20 ตัวอักษรในการเข้าสู่เซิร์ฟเวอร์
		Player Name: 24 // SetPlayerName สามารถทำให้ชื่อยาวได้ถึง 24 ตัวอักษร

	Tips:
		mysql_query: เซิร์ฟเวอร์จะหยุดทำงานจนกว่าจะ Query เสร็จ
		mysql_tquery: เซิร์ฟเวอร์ไม่จะหยุดทำงานแต่ Query ทีละคิว
		mysql_pquery: เซิร์ฟเวอร์ไม่จะหยุดทำงานและสามารถ Query พร้อมกันได้เป็นพาราเรล

		Copying strings: 
			ข้อความสั้นๆใน Array เล็กๆ "b = a;" ไวกว่า หรือ strcat รองลงมา (สำคัญระวังพวก NULL)
			ข้อความสั้นๆใน Array ใหญ่ๆ strcat ไวสุด
			ข้อความยาวๆๆใน Array ใหญ่ๆ ใช้ "b = a;" เร็วสุด รองลงมา memcpy
			Array ใหญ่ๆ ใช้ "b = a;"

*/

#include <a_samp>
/*  ---------------- SCRIPT VERSION ----------------- */
#define SERVER_GM_TEXT "CAKE:1.0"

#undef  MAX_PLAYERS
#define MAX_PLAYERS (100)

native WP_Hash(buffer[], len, const str[]); // Southclaws/samp-whirlpool
/*=======================================================================================================
										[Includes]
=======================================================================================================*/
//#include <fixes2> // Wait for test y_timer
#include <crashdetect>   // Zeex/samp-plugin-crashdetect
#include <foreach> // Open-GTO/foreach:v19.0
#include <sscanf2> // maddinat0r/sscanf:v2.8.2
#include <streamer>      // samp-incognito/samp-streamer-plugin

// aktah/YSI-Includes Fix new sampctl
#include <YSI\y_timers>  // pawn-lang/YSI-Includes
#include <YSI\y_hooks> // pawn-lang/YSI-Includes
#include <nex-ac> // NexiusTailer/Nex-AC

#define CE_AUTO
#include <CEFix>   // aktah/SAMP-CEFix

#include <easyDialog> // aktah/easyDialog:2.0 edit for CEFix Plugin
#include <a_mysql> // pBlueG/SA-MP-MySQL
#include <Pawn.CMD> // urShadow/Pawn.CMD
#include <md-sort> // oscar-broman/md-sort
#include <log-plugin> // maddinat0r/samp-log
#include <preloadanim> // zAnimsFix & _Zume
#include <strlib>//oscar-broman/strlib
#include <Pawn.Regex> // urShadow/Pawn.Regex
#include <gvar> // samp-incognito/samp-gvar-plugin

DEFINE_HOOK_REPLACEMENT(OnPlayer, OP_);

new
    Logger:ac_log,
	Logger:system_log,
	Logger:a_action_log;

/*=======================================================================================================
										[Modules]
=======================================================================================================*/
// General
#include "includes/utils/colors.pwn"
#include "includes/defines.pwn"
#include "includes/enums.pwn"
#include "includes/variables.pwn"
#include "includes/functions.pwn"
#include "includes/wrappers.pwn"
#include "includes/timers.pwn"
#include "includes/overwrite.pwn"
#include "includes/mysql.pwn"
#include "includes/callbacks.pwn"
#include "includes/textdraws.pwn"

// Core
#include "includes/core/initgamemode.pwn"
#include "includes/core/auth.pwn"
#include "includes/core/ac.pwn"

// System
#include "includes/system/vehicle.pwn"
#include "includes/system/faction.pwn"
#include "includes/system/damages.pwn"
#include "includes/system/entrance.pwn"

// ทดสอบระบบจาก http://forum.script-wise.in.th
//#include "includes/system/airdrop.pwn" // by InwOJice, Edit by Me !!!

// CMD
#include "includes/player/cmd.pwn"
#include "includes/admin/cmd.pwn"

// Map
// Miscellaneous

/*======================================================================================================*/

main(){}

public OnGameModeInit()
{
	OnGameModeInitEx();

	#if defined SWRP_OnGameModeInit
		return SWRP_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit SWRP_OnGameModeInit
#if defined SWRP_OnGameModeInit
	forward SWRP_OnGameModeInit();
#endif

OnGameModeInitEx()
{
	ac_log = CreateLog("server/anticheat");
	system_log = CreateLog("server/system");
	a_action_log = CreateLog("server/admin_action");

	print("Preparing the gamemode, please wait...");
	g_mysql_Init();
	InitiateGamemode();
}

public OnGameModeExit()
{
	DestroyLog(ac_log);
	DestroyLog(system_log);
	DestroyLog(a_action_log);

	print("Exiting the gamemode, please wait...");
	g_mysql_Exit();
	return 1;
}

AntiDeAMX()
{
    new b;
    #emit load.pri b
    #emit stor.pri b
}