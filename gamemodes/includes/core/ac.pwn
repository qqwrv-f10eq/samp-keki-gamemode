forward OnCheatDetected(playerid, const ip_address[], type, code); 
public OnCheatDetected(playerid, const ip_address[], type, code) 
{ 
    if(type) {
        Log(ac_log, INFO, "[AC]: ต้องสงสัยไอพี IP %s ใช้โปรแกรมช่วยเล่นรหัส: %d", ip_address, code);
        BlockIpAddress(ip_address, 0);
    }
    else 
    { 
        Log(ac_log, INFO, "[AC]: ต้องสงสัย %s ใช้โปรแกรมช่วยเล่นรหัส: %d", ReturnPlayerName(playerid), code);

        switch(code) 
        { 
            case 5, 6, 11, 22: return 1; 
            case 12: {
                new Float:hp;
                AntiCheatGetHealth(playerid, hp);
                SetPlayerHealth(playerid, hp);
                return 1; 
            }
            case 13: {
                new Float:hp;
                AntiCheatGetArmour(playerid, hp);
                SetPlayerArmour(playerid, hp);
                return 1; 
            }
            case 14: 
            { 
                ResetPlayerMoney(playerid); 
                GivePlayerMoney(playerid, playerData[playerid][pCash]); 
                return 1; 
            } 
            case 32: 
            { 
                new Float:x, Float:y, Float:z; 
                AntiCheatGetPos(playerid, x, y, z); 
                SetPlayerPos(playerid, x, y, z); 
                return 1; 
            } 
            case 40: SendClientMessage(playerid, -1, MAX_CONNECTS_MSG); 
            case 41: SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG); 
            default: 
            { 
                new strtmp[sizeof KICK_MSG]; 
                format(strtmp, sizeof strtmp, KICK_MSG, code); 
                SendClientMessage(playerid, -1, strtmp); 
            } 
        } 
        AntiCheatKickWithDesync(playerid, code); 
    }
    return 1; 
}  