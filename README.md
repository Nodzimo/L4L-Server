# Left 4 Legend <sup>v2 alpha</sub>
> [!WARNING]
> В работе!

## Оглавление
- [Установка сервера](#установка-сервера)
- [Конфигурация](#конфигурация)
- [Моды](#моды)
- [SourceMod расширения](#sourcemod-расширения)
- [SourceMod плагины](#sourcemod-плагины)
- [V-скрипты](#v-скрипты)
- [Карты](#карты)
- [Консольные команды](#консольные-команды)
- [Онлайн-инструменты](#онлайн-инструменты)
- [Клиент](#клиент)
- [Репозиторий](#репозиторий)
- [Steam](#steam)

## Документация

### Установка сервера
- [Source Dedicated Server](https://developer.valvesoftware.com/wiki/Source_Dedicated_Server)
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
   - `force_install_dir`
   - `login anonymous`
   - `app_update 222860 validate`
   - `quit`
- Решение проблемы с установкой сервера на линукс: [Invalid platform SteamCMD errors for L4D2](https://github.com/ValveSoftware/steam-for-linux/issues/11522)
- [Command line options](https://developer.valvesoftware.com/wiki/Command_line_options)
- [Host Dedicated Steam Game Servers with Linux - Palworld, CS2, SteamCMD!](https://www.youtube.com/watch?v=frp-bNoqjzc)
- `status`
- `exit`

### Конфигурация
- `Unknown command "mat_bloom_scalefactor_scalar"`
   - Закомментировать команду в `left4dead2/cfg/modsettings.cfg`

### Моды
1. [Metamod:Source 1.12.0-dev+1219](https://www.metamodsource.net/downloads.php?branch=stable)
   - Документация: [Metamod:Source documentation](https://wiki.alliedmods.net/Category:Metamod:Source_Documentation)
   - Консольные команды: [Console commands (Metamod:Source)](https://wiki.alliedmods.net/Console_Commands_(Metamod:Source))
   - `meta version`
   - `meta list`
2. [SourceMod 1.12.0.7219](https://www.sourcemod.net/downloads.php?branch=stable)
   - Документация: [SourceMod documentation](https://wiki.alliedmods.net/index.php/Category:SourceMod_Documentation)
   - Установка SourceMod: [Installing SourceMod](https://wiki.alliedmods.net/Installing_SourceMod)
   - Добавление админов: [Adding admins (SourceMod)](https://wiki.alliedmods.net/Adding_Admins_(SourceMod))
   - Админские команды: [Admin commands (SourceMod)](https://wiki.alliedmods.net/Admin_Commands_(SourceMod))
   - `sm version`

### SourceMod расширения
`sm exts list`
1. [Accelerator (2.6.0-manual): SRCDS Crash Handler](https://forums.alliedmods.net/showthread.php?t=277703)
   - [Throttle dashboard](https://crash.limetech.org/dashboard)
   - Решение проблемы с расширением Accelerator на линуксе: [\<FAILED\> file "accelerator.ext.so": bin/libstdc++.so.6: version `GLIBCXX_3.4.21' not found](https://forums.alliedmods.net/showpost.php?p=2636287&postcount=306)

### SourceMod плагины
`sm plugins list`
1. [[L4D2] Custom admin commands (1.3.9e) by honorcode23, Shadowysn (improvements)](https://forums.alliedmods.net/showpost.php?p=2704580&postcount=483)
   - Добавляет в меню `sm_admin` дополнительные команды, например: неуязвимость, телепорт, инкап и тому подобные.
2. [[L4D] Map Changer (3.8) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?t=311161)
   - Мультикомбайн: автоматическое добавление новых карт в меню `sm_maps`, рейтинг карт, настройка смены кампании после финала и так далее.
3. [[L4D2] Incapped Crawling with Animation (2.9) by SilverShot, mod by Lux](https://forums.alliedmods.net/showthread.php?t=137381)
   - Проверить: модельки персонажей (особенно Ро) переворачивались и колбасились в инкапе на старом L4L

#### Плагины для разработки и тестирования
- [[ANY] Dev Cmds (1.52) by SilverShot](https://forums.alliedmods.net/showthread.php?t=187566)
   - Набор отладочных команд, например: перезагрузка всех плагинов, управление ботами, рестарт раунда и многое другое.
- [[DEV] Autoreload plugins (1.16) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?p=2686825)
   - Горячая перезагрузка плагина при его компиляции или удалении

#### L4D2 Survivor Bot AI Improver
- [Репозиторий оригинала](https://github.com/Kerouha/L4D2-Survivor-Bot-AI-Improver)
   - Автор практически забил на плагин, но время от времени вливает изменения в [экспериментальную ветку](https://github.com/Kerouha/L4D2-Survivor-Bot-AI-Improver/tree/experimental)
- [Репозиторий форка](https://github.com/Emana202/L4D2-Survivor-Bot-AI-Improver)
   - Обновляется гораздо чаще оригинала и медленно, но верно поддерживается. Изменения из форка время от времени вливаются в оригинальный репозиторий и наоборот.
   - [Тема на форуме](https://forums.alliedmods.net/showthread.php?t=342872)

#### Репозитории плагинов
- [Jackzmc / sourcemod-plugins](https://github.com/Jackzmc/sourcemod-plugins)
- [fbef0102 / L4D1_2-Plugins](https://github.com/fbef0102/L4D1_2-Plugins)
- [fbef0102 / Sourcemod-Plugins](https://github.com/fbef0102/Sourcemod-Plugins)
- [fdxx / l4d2_plugins](https://github.com/fdxx/l4d2_plugins)
- [wyxls / SourceModPlugins-L4D2](https://github.com/wyxls/SourceModPlugins-L4D2)
- [A1oneR / L4D2_DRDK_Plugins](https://github.com/A1oneR/L4D2_DRDK_Plugins)

### V-скрипты
[Мастерская Left 4 Dead 2](https://steamcommunity.com/app/550/workshop)

[Коллекция всех V-скриптов в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3608129891)

- [Carryable placer](https://steamcommunity.com/sharedfiles/filedetails/?id=3208147246)
- [Unreachable item spawns fixes (100+)](https://steamcommunity.com/sharedfiles/filedetails/?id=2493132849)
- [[VSCRIPT] No Friendly Fire on Charger Carry](https://steamcommunity.com/sharedfiles/filedetails/?id=3432580793)
- [Smoker insta-grab fix](https://steamcommunity.com/sharedfiles/filedetails/?id=2945656229)
- [Wandering Witch Shove Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3359130948)
- [No Camera Shake When Bots Shoot You [VScript]](https://steamcommunity.com/sharedfiles/filedetails/?id=3233665119)
- [Full Clip On Mag Insert VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3339719078)
- [C1M3 Instant Horde Remover](https://steamcommunity.com/sharedfiles/filedetails/?id=3356940910)
- [No Fall Stagger Cancel VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3313875830)
- [Automatic Guns/Autofire VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=2949667423)
- [No Active Camera Damage VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3323149700)

### Карты
[Коллекция всех карт в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3608021337)

- [Whitaker's Weapons Range by danfs0 [RE-UPLOAD]](https://steamcommunity.com/sharedfiles/filedetails/?id=3001153036)
- [Dead South](https://steamcommunity.com/sharedfiles/filedetails/?id=3378140391)
> [!CAUTION]
> Проверить: первая карта (но это не точно) часто крашилась на сборке Nightmare

#### Снежные, зимние, новогодние
- [Snow Den 2.0, Holiday release (definitive version)](https://steamcommunity.com/sharedfiles/filedetails/?id=3396441138)
> [!CAUTION]
> Проверить: первая карта крашилась на старом L4L
- [A Christmas Bridge](https://steamcommunity.com/sharedfiles/filedetails/?id=3385079215)
- [Dead Center: Christmas Edition (Part 1)](https://steamcommunity.com/sharedfiles/filedetails/?id=2668272749)
- [No Mercy Christmas Edition (Part 2)](https://steamcommunity.com/sharedfiles/filedetails/?id=3101550309)
> [!CAUTION]
> Проверить: первая карта сильно лагала на старом L4L
- [Winter Carnival](https://steamcommunity.com/sharedfiles/filedetails/?id=2891062323)
- [Winter Harvest Train](https://steamcommunity.com/sharedfiles/filedetails/?id=3427138500)
- [Death Toll Winter](https://steamcommunity.com/sharedfiles/filedetails/?id=2884330969)

### Консольные команды
- [List of Left 4 Dead 2 console commands and variables](https://developer.valvesoftware.com/wiki/List_of_Left_4_Dead_2_console_commands_and_variables)

### Онлайн-инструменты
- [Steam ID Finder](https://steamid.pro)
- [STEAMID I/O - lookup and convert your steamID, steamID3, steamID64, customURL and community id](https://steamid.io)

### Клиент
- [Left 4 Dead 2 Complete Launch Options](https://steamcommunity.com/sharedfiles/filedetails/?id=3543870520)
- [Ultimate L4D2 Config](https://github.com/theletterjwithadot/Ultimate-Config-for-L4D2)

### Репозиторий
- `git rm --cached -r`
   - Удалить файл из репозитория, если он уже туда попал, но оставить его локально на тачке
   - После этой команды нужно закоммитить и запушить изменения в репозиторий
   - Пример:
      ```
      git rm --cached -r "Platform/Windows/SteamCMD"
      git commit -m "Stop tracking SteamCMD runtime files"
      ```
- Максимальный размер коммита для GitHub репозитория: **30 мегабайт** (но это не точно)
- [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

### Steam
- `An error occurred while attempting to download a file from the UGC server!`
   - Временная проблема на стороне Steam, обычно исправляют в течении нескольких дней
- [Как передать управление группой](https://steamcommunity.com/discussions/forum/26/1291817837640449310)
- **Branding image** в Steam-коллекции поддерживает следующие форматы: **JPEG**, **GIF**, **PNG**.