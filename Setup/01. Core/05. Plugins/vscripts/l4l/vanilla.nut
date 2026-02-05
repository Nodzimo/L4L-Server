local TAG = "[L4L VScript Vanilla] ";

if (!("Left4Bots" in getroottable()) || !("Settings" in ::Left4Bots)) {
	printl(TAG + "Left 4 Bots not initialized");

	return 0;
}

local settings = ::Left4Bots.Settings;

function LogState(prefix) {
	printl(TAG + prefix +
		" chat_hello_replies=\"" + settings.chat_hello_replies + "\"" +
		" deploy_upgrades=" + settings.deploy_upgrades +
		" team_max_chainsaws=" + settings.team_max_chainsaws +
		" throw_vomitjar=" + settings.throw_vomitjar
	);
}

LogState("L4B settings before:");

settings.chat_hello_replies = "Welcome to Vanilla";
settings.deploy_upgrades = 1;
settings.team_max_chainsaws = 1;
settings.throw_vomitjar = 1;

LogState("L4B settings after:");

return 1;