#define MAX_AIRDROP_BOX 5
#define FLOAT_INFINITY   (Float:0x7F800000)

enum E_BOX_DATA {
    bool:IsExist,
    ObjectBox,
    ObjectFlash
}

new BoxInfo[MAX_AIRDROP_BOX][E_BOX_DATA];
new bool:IsGetBox[MAX_PLAYERS][MAX_AIRDROP_BOX];

CMD:box(playerid, params[])
{
    if (playerData[playerid][pAdmin])
    {
        new bool:checked;
        for(new i=0; i != MAX_AIRDROP_BOX; i++) {
            if(!BoxInfo[i][IsExist]) {
                BoxInfo[i][IsExist]=true;

                new Float:x ,Float:y ,Float:z;
                GetPlayerPos(playerid, x, y, z);

                BoxInfo[i][ObjectBox] = CreateDynamicObject(19054, x, y, z+90, 0, 0, 0);
                BoxInfo[i][ObjectFlash] = CreateDynamicObject(18728, x, y, z+85, 0, 0, 0); 
                MoveDynamicObject(BoxInfo[i][ObjectBox], x, y, z-0.4, 10.00);
                MoveDynamicObject(BoxInfo[i][ObjectFlash], x, y, z-1.2, 10.00);
                SetTimerEx("Box2",20000 , 0, "d", i);

                SendClientMessage(playerid, -1, "เซิร์ฟเวอร์: คุณได้สร้าง Airdrop ไอดี "EMBED_ORANGE"%d"EMBED_WHITE"", i);

                checked = true;

                break;
            }
        }
        if(!checked) SendClientMessage(playerid, COLOR_LIGHTRED, "เซิร์ฟเวอร์: ถึงขีดจำกัดในการสร้างกล่อง Airdrop แล้ว");
    }
    else
    {
        SendClientMessage(playerid, -1, "เซิร์ฟเวอร์: คุณไม่ใช่แอดมินไม่สามารถปล่อยกล่องได้");
    }
    return 1;
}

forward Box2(id); // index from BoxInfo
public Box2(id)
{  
    DestroyDynamicObject(BoxInfo[id][ObjectBox]);     //เป็นการลบObject Box1
    DestroyDynamicObject(BoxInfo[id][ObjectFlash]);   //เป็นการลบObject flash1
    BoxInfo[id][IsExist]=false;

    foreach(new i : Player) {
        if(IsGetBox[i][id]) {
            IsGetBox[i][id]=false;
        }
        SendClientMessage(i, -1, "เซิร์ฟเวอร์: Airdrop ID "EMBED_ORANGE"%d"EMBED_WHITE" ได้ถูกทำลายแล้ว", id);
    }
    return 1;
}

CMD:getbox(playerid, params[])
{
    new
        Float:fDistance = FLOAT_INFINITY,
        iIndex = -1
    ;

    for(new i=0; i != MAX_AIRDROP_BOX; i++) {
        if(BoxInfo[i][IsExist]) { // เฉพาะกล่องที่ถูกสร้าง

            new Float:x ,Float:y ,Float:z;
            GetDynamicObjectPos(BoxInfo[i][ObjectBox], x, y, z); 

            new
                Float:temp = GetPlayerDistanceFromPoint(playerid, x, y, z);

            if (temp < fDistance && temp <= 5.0)
            {
                fDistance = temp;
                iIndex = i;
            }
        }
    }

    if(iIndex != -1) {
        if(!IsGetBox[playerid][iIndex]) 
        {
            IsGetBox[playerid][iIndex] = true;

            switch(random(10))
            {
            case 0:
            {
                SendClientMessage(playerid, -1, "Server : คุณได้ของชิ้นที่ 1"); //ใส่ของรางวัล
            }
            case 1:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 2 ");//ใส่ของรางวัล
            }
            case 2:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 3");//ใส่ของรางวัล
            }
            case 3:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 4");//ใส่ของรางวัล
            }
            case 4:
            {
                SendClientMessage(playerid, -1, "Server : คุณได้ของชิ้นที่ 5");//ใส่ของรางวัล
            }
            case 5:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 6");//ใส่ของรางวัล
            }
            case 6:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 7");//ใส่ของรางวัล
            }
            case 7:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 8");//ใส่ของรางวัล
            }
            case 8:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 9");//ใส่ของรางวัล
            }
            case 9:
            {
                SendClientMessage(playerid, -1, "Server :  คุณได้ของชิ้นที่ 10");//ใส่ของรางวัล
            }
            }
        }
        else return SendClientMessage(playerid, -1, "Server : คุณรับของไปแล้ว ไม่สามารถรับของได้อีก");
    }
    else {
        SendClientMessage(playerid, -1, "Server : คุณไม่ได้อยู่จุดที่กล่องดรอปหรือกล่องยังไม่ได้ดรอป");
    }
    return 1;
}