//--------------------------------[ENUMS.PWN]--------------------------------

enum PlayerFlags:(<<= 1) { // BitFlag
    IS_SPAWNED = 1,
	IS_LOGGED,
    IS_MASKED,
    IS_ADM_DUTY
};

enum (<<= 1)
{
    CMD_TESTER = 1,
    CMD_ADM1,
    CMD_ADM2,
    CMD_ADM3,
    CMD_LEAD, // Lead Admin
    CMD_MM, // Management
    CMD_DEV, // Developer
};

enum E_PLAYER_DATA
{
    pSQLID,
    pAdmin,
    pPnumber,
    pLevel,
    pModel,
    pCash,
    pDonateRank,
    pSpawnType,
    pInterior,
    pVWorld,

    pFaction,
    pFactionID,
    pFactionRank,

    Float:pArmour,
    Float:pHealth,
    Float:pSHealth,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,

    pTalkStyle,

    pIP[16],
    pCMDPermission,
    pSpectating
};

enum E_FACTION_DATA
{
	fID,
	fName[60],
	fShortName[15],
    fType,
    fColor,
	Float:fSpawnX,
	Float:fSpawnY,
	Float:fSpawnZ,
    Float:fSpawnA,
    fSpawnInt,
    fSpawnWorld,
    fCash,

    fMaxSkins,
    fMaxRanks,
    fMaxVehicles,
    
    bool:fOOC,
    fPickupSpawn,
    STREAMER_TAG_3D_TEXT_LABEL:fLabelSpawn
};

enum cache_data // Phone
{
	current_page,
	notify_page,
	row_selected,
	bool:mode_airplane,
	bool:mode_silent,
	bool:mode_speaker,
	ringtone_call,
	ringtone_text,

	calltype, // 0-Hotline 1-Private, 2-Payphone, 3-Toll Free
	outgoing_call,
	incoming_call,
	callline,

	Timer:ph_timer,
	bool:exist_time,
	
	phone_data[4],
	data_selected,
	data_type, // 0-Contact, 1-SMS
}