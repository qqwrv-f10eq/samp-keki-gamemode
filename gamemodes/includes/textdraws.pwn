forward LoadTextDraws();
public LoadTextDraws() {
    g_ServerRestartCount = TextDrawCreate(237.000000, 409.000000, "~r~Server Restart:~w~ 00:00");
	TextDrawBackgroundColor(g_ServerRestartCount, 255);
	TextDrawFont(g_ServerRestartCount, 1);
	TextDrawLetterSize(g_ServerRestartCount, 0.480000, 1.300000);
	TextDrawColor(g_ServerRestartCount, -1);
	TextDrawSetOutline(g_ServerRestartCount, 1);
	TextDrawSetProportional(g_ServerRestartCount, 1);
	TextDrawSetSelectable(g_ServerRestartCount, 0);
}