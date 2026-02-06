local TAG = "[L4L VScript Hardcore] ";

if (!("Left4Bots" in getroottable()) || !("Settings" in ::Left4Bots)) {
	printl(TAG + "Left 4 Bots not initialized");

	return 0;
}

local settings = ::Left4Bots.Settings;

function LogState(prefix) {
	printl(TAG + prefix +
		" file_weapons_prefix=\"" + settings.file_weapons_prefix + "\"" +
		" chat_hello_replies=\"" + settings.chat_hello_replies + "\"" +
		" chat_hello_count=" + ::Left4Bots.ChatHelloReplies.len() +
		" deploy_upgrades=" + settings.deploy_upgrades
	);
}

function ApplyHelloReplies() {
	if (settings.chat_hello_replies != "")
		::Left4Bots.ChatHelloReplies = split(settings.chat_hello_replies, ",");
	else
		::Left4Bots.ChatHelloReplies = [];

	::Left4Bots.ChatHelloAlreadyReplied = {};

	printl(TAG + "ChatHelloReplies rebuilt, count=" + ::Left4Bots.ChatHelloReplies.len());
}

function ReloadWeapons() {
	if ("Bots" in ::Left4Bots) {
		foreach(bot in ::Left4Bots.Bots)::Left4Bots.LoadWeaponPreferences(bot, bot.GetScriptScope());
	}

	if ("L4D1Survivors" in ::Left4Bots) {
		foreach(bot in ::Left4Bots.L4D1Survivors)::Left4Bots.LoadWeaponPreferences(bot, bot.GetScriptScope());
	}
}

LogState("L4B settings before:");

settings.chat_hello_replies = "Welcome to Hardcore";
ApplyHelloReplies();

settings.deploy_upgrades = 0; // 1

settings.file_weapons_prefix = "left4bots2/cfg/weapons_hardcore/";
ReloadWeapons();

LogState("L4B settings after:");

return 1;