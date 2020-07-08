//--------------------------------[WRAPPERS.PWN]--------------------------------

stock KickEx(playerid)
{
	SetTimerEx("KickTimer", 400, 0, "i", playerid);
	return 1;
}

forward KickTimer(playerid);
public KickTimer(playerid)
{
	if (IsPlayerConnected(playerid)) 
        Kick(playerid);
	return 1;
}

stock randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

stock PlayerPlaySoundEx(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
     PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

Dialog:ShowOnly(playerid, response, listitem, inputtext[]) {
	playerid = INVALID_PLAYER_ID;
	response = 0;
	listitem = 0;
	inputtext[0] = '\0';
}