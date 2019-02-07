//------------#NimA00GaMeR---------------------------------------------------------------------------------
//------------NNN----------------NN---------0000000000000-----0000000000000-----GGGGGGGGGGGGGGGGGGGGGGGG---
//------------NN-NN--------------NN--------00-----------00---00-----------00----GG-------------------------
//------------NN--NN-------------NN-------00-------------00-00-------------00---GG-------------------------
//------------NN---NN------------NN-------00-------------00-00-------------00---GG-------------------------
//------------NN----NN-----------NN-------00-------------00-00-------------00---GG-------------------------
//------------NN-----NN----------NN-------00-------------00-00-------------00---GG-------------------------
//------------NN------NN---------NN-------00-------------00-00-------------00---GG-------------------------
//------------NN-------NN--------NN-------00-------------00-00-------------00---GG-----GGGGGGGGGGGGGGGGG---
//------------NN--------NN-------NN-------00-------------00-00-------------00---GG--------------------GG---
//------------NN---------NN------NN-------00-------------00-00-------------00---GG--------------------GG---
//------------NN----------NN-----NN-------00-------------00-00-------------00---GG--------------------GG---
//------------NN-----------NN----NN-------00-------------00-00-------------00---GG--------------------GG---
//------------NN------------NN---NN-------00-------------00-00-------------00---GG--------------------GG---
//------------NN-------------NN--NN-------00-------------00-00-------------00---GG--------------------GG---
//------------NN--------------NN-NN--------00-----------00---00-----------00----GG--------------------GG---
//------------NN---------------NNN-----------000000000000-----000000000000------GGGGGGGGGGGGGGGGGGGGGGGG---
//---------------------------------------------------------------------------------------------------------
//----------------------------------THIS FILTERSCRIPT MADE BY:NIMA00GAMER----------------------------------
//----------------------------------------TeamSpeak Controller V1.0----------------------------------------

#include <a_samp>
#include <TSConnector>


#define TS_IP "127.0.0.1" // IP Of TeamSpeak Server
#define TS_PORT 9987 // Port Of TeamSpeak Server
#define TS_QUESER "serveradmin" // Query's User Of TeamSpeak Server
#define TS_QPASS "5lrviiGI" // Query's Password TeamSpeak Server

#define RANK_STATUS_W 40 // Status Off Player:
#define RANK_STATUS_ON 41 // Player Is Online
#define RANK_STATUS_OFF 42 // Player Is Offline

#define CHANNEL_ONLINE_USERS 19 // ID Off Online Users: 00 Channel
#define CHANNEL_SAMP_ONLINE_USERS 20 // ID Off SA:MP Server's Online Users: 00 Channel

new TS_Onlines;
new TS_SampOnlines;

public OnFilterScriptInit()
{
    TSC_Connect(TS_QUESER, TS_QPASS, TS_IP, TS_PORT);
    TSC_ChangeNickname("SA:MP Control");

    TS_Onlines = 0;
    TS_SampOnlines = 0;
	print("\n---------------------------------------");
	print("  -NimA00GaMeR's TS Controller Loaded.-  ");
	print("         -Don't Remove Credits!-         ");
	print("---------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n---------------------------------------");
	print("  -NimA00GaMeR's TS Controller Unloaded.-  ");
	print("         -Don't Remove Credits!-         ");
	print("---------------------------------------\n");
	return 1;
}


forward TS_UpdateOnlineP();
forward TS_UpdateOnlineM();

public TS_UpdateOnlineP()
{
    new channelname[512];
    format(channelname, sizeof(channelname), "[cspacer]TS Online Users : [%d/1024]", TS_Onlines);
    TSC_SetChannelName(CHANNEL_ONLINE_USERS, channelname);
    return 1;
}
public TS_UpdateOnlineM()
{
    new channelname[512];
    format(channelname, sizeof(channelname), "[cspacer]TS Online Users : [%d/1024]", TS_Onlines);
    TSC_SetChannelName(CHANNEL_ONLINE_USERS, channelname);
    return 1;
}

//TSSSSS:DDDDDD
IsPlayerOnline(const nick[])
{
    if(!nick[0]) return INVALID_PLAYER_ID; // empty nick

    static name[MAX_PLAYER_NAME + 1];
    for(new i, g = GetMaxPlayers(); i < g; i++)
        if(IsPlayerConnected(i))
        {
            GetPlayerName(i, name, sizeof(name));
            if(!strcmp(nick, name))
                return i;
        }

    return INVALID_PLAYER_ID;
}
public TSC_OnError(TSC_ERROR_TYPE:error_type, error_id, const error_msg[])
{
    printf("%s", error_msg);
    return 1;
}
public TSC_OnClientConnect(clientid, nickname[])
{
    TS_Onlines +=1;
    TS_UpdateOnlineP();
    TSC_RemoveClientFromServerGroup(clientid, RANK_STATUS_W);

    // player is online
    TSC_RemoveClientFromServerGroup(clientid, RANK_STATUS_ON);
    // player is offline
    TSC_RemoveClientFromServerGroup(clientid, RANK_STATUS_OFF);


    new Online = IsPlayerOnline(nickname);
    new Online2[128];
    TSC_AddClientToServerGroup(clientid, RANK_STATUS_W);

    if(Online != INVALID_PLAYER_ID) // or if you don't want ID use if(IsPlayerOnline(targetname) != INVALID_PLAYER_ID)
    {
        // player is online
        Online2 = "[color=green]Online[/color]";
        TSC_AddClientToServerGroup(clientid, RANK_STATUS_ON);

    }
    else
    {
        // player is offline
        Online2 = "[color=red]Offline[/color]";
        TSC_AddClientToServerGroup(clientid, RANK_STATUS_OFF);

    }
    new string[512];
    format(string, sizeof(string), "Welcome [color=green]%s[/color]\n Your status in samp server : %s", nickname, Online2);
//    print(string);
    TSC_SendClientMessage(clientid, string);

//    TSC_AddClientToServerGroup(clientid, TS_SERVER_GROUP_PLAYER);
    return 1;
}

public TSC_OnClientDisconnect(clientid, reasonid, reasonmsg[])
{
    TS_Onlines -=1;
    TS_UpdateOnlineM();
    return 1;
}

public OnPlayerConnect(playerid)
{
    TS_SampOnlines ++;
	UpdateSampOnlinesChannel();
	new PlayerIP[24];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	new ClientID = TSC_GetClientIdByIpAddress(PlayerIP);
	new ClientDes[200];
	new PlayerName[24];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	format(ClientDes, sizeof(ClientDes), "Player's name in SA-MP: %s", PlayerName);
	TSC_SetClientDescription(ClientID, ClientDes);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	TS_SampOnlines --;
	UpdateSampOnlinesChannel();

	new PlayerIP[24];
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	new ClientID = TSC_GetClientIdByIpAddress(PlayerIP);
	new ClientDes[200];
	format(ClientDes, sizeof(ClientDes), "");
	TSC_SetClientDescription(ClientID, ClientDes);
	return 1;
}

forward UpdateSampOnlinesChannel();
public UpdateSampOnlinesChannel()
{
    new channelname[512];
    format(channelname, sizeof(channelname), "[cspacer]SA-MP Online Users : [%d/%d]", TS_SampOnlines, GetMaxPlayers());
    TSC_SetChannelName(CHANNEL_SAMP_ONLINE_USERS, channelname);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
