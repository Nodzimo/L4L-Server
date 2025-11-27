# Left 4 Legend <sup>v2 alpha</sub>
> [!WARNING]
> В работе!

## Оглавление
- [Left 4 Legend v2 alpha](#left-4-legend-v2-alpha)
  - [Оглавление](#оглавление)
  - [Документация](#документация)
    - [Установка сервера](#установка-сервера)
    - [Конфигурация](#конфигурация)
    - [Моды](#моды)
    - [SourceMod расширения](#sourcemod-расширения)
    - [SourceMod плагины](#sourcemod-плагины)
      - [Зависимости](#зависимости)
      - [Плагины для разработки и тестирования](#плагины-для-разработки-и-тестирования)
      - [L4D2 Survivor Bot AI Improver](#l4d2-survivor-bot-ai-improver)
      - [Репозитории плагинов](#репозитории-плагинов)
    - [V-скрипты](#v-скрипты)
    - [Карты](#карты)
      - [Снежные, зимние, новогодние](#снежные-зимние-новогодние)
    - [Dev-сборка](#dev-сборка)
    - [Консольные команды](#консольные-команды)
    - [Онлайн-инструменты](#онлайн-инструменты)
    - [Клиент](#клиент)
      - [Мастерская](#мастерская)
      - [Программы](#программы)
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
- `Unknown command ","`
   - В конфигах нельзя писать комментарии на кириллице
- `Unknown command "mat_bloom_scalefactor_scalar"`
   - Закомментировать команду в `left4dead2/cfg/modsettings.cfg`
- `sb_all_bot_game 1` (по умолчанию 0)
   - Пробуждает сервер из гибернации, даже если он пустой: `Server waking up from hibernation`
   - Сервер не выключится через 5 минут, если все игроки ушли в АФК: `Sending 'crash'... Reason: Empty Server`
   - Игроков не выкинет с сервера через 5 минут бездействия:
      ```
      Disconnected
      The server shut down because all players were idle.
      ```
   - Сервер будет работать без игроков, не уходя в гибернацию: `not hibernating`
- `allow_all_bot_survivor_team 1` (по умолчанию 0)
   - Если все игроки умерли, то боты продолжают играть дальше и идти вперёд.
### Моды
1. [Metamod:Source 1.12.0-dev+1219](https://www.metamodsource.net/downloads.php?branch=stable)
   - Документация: [Metamod:Source documentation](https://wiki.alliedmods.net/Category:Metamod:Source_Documentation)
   - Консольные команды: [Console commands (Metamod:Source)](https://wiki.alliedmods.net/Console_Commands_(Metamod:Source))
   - `meta version`
   - `meta list`
2. [SourceMod 1.12.0.7219](https://www.sourcemod.net/downloads.php?branch=stable)
   - Документация: [SourceMod documentation](https://wiki.alliedmods.net/index.php/Category:SourceMod_Documentation)
   - Установка SourceMod: [Installing SourceMod](https://wiki.alliedmods.net/Installing_SourceMod)
   - Рекомендации для нескольких экземпляров одного сервера: [Multiple or Forked Servers (SourceMod)](https://wiki.alliedmods.net/Multiple_or_Forked_Servers_(SourceMod))
   - Добавление админов: [Adding admins (SourceMod)](https://wiki.alliedmods.net/Adding_Admins_(SourceMod))
   - Админские команды: [Admin commands (SourceMod)](https://wiki.alliedmods.net/Admin_Commands_(SourceMod))
   - [SourceMod 1.11.0.6970](https://www.sourcemod.net/downloads.php?branch=1.11-dev)
      - Для компиляции плагинов на старом синтаксисе **SourcePawn**
   - `sm version`
   - `sm_admin`

### SourceMod расширения
`sm exts list`
1. [Accelerator (2.6.0-manual): SRCDS Crash Handler](https://forums.alliedmods.net/showthread.php?t=277703)
   - Расширение для автоматической загрузки краш-репортов на [Throttle dashboard](https://crash.limetech.org/dashboard)
   - Решение проблемы с расширением Accelerator на линуксе: [\<FAILED\> file "accelerator.ext.so": bin/libstdc++.so.6: version `GLIBCXX_3.4.21' not found](https://forums.alliedmods.net/showpost.php?p=2636287&postcount=306)
2. [SteamWorks Extension (1.2.4) by Kyle Sanderson](https://github.com/hexa-core-eu/SteamWorks)
   - Требуется для плагина **Steam Works Group Manager**

### SourceMod плагины
`sm plugins list`
1. [[L4D2] Custom admin commands (1.3.9e) by honorcode23, Shadowysn (improvements)](https://forums.alliedmods.net/showpost.php?p=2704580&postcount=483)
   - Добавляет в админку дополнительные команды, например: неуязвимость, телепорт, инкап и тому подобные.
2. [[L4D] Map Changer (3.8) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?t=311161)
   - Мультикомбайн: автоматическое добавление новых карт в меню, рейтинг карт, настройка смены кампании после финала и так далее.
   - `sm_maps`
> [!IMPORTANT]
> Нужно в меню переименовать раздел с кастомными картами
3. [[L4D2] Incapped Crawling with Animation (2.9) by SilverShot, mod by Lux](https://forums.alliedmods.net/showthread.php?t=137381)
> [!CAUTION]
> Проверить: модельки персонажей (особенно Ро) переворачивались и колбасились в инкапе на старом L4L
4. [[L4D2] Weapon/Zombie Spawner (1.3c) by Zuko & McFlurry, Zheldorg](https://forums.alliedmods.net/showpost.php?p=2732571&postcount=491)
   - Добавляет в админку спавн оружия и заражённых
5. [[ANY] Restart Empty Server (or Map) (2.9) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?t=315367)
   - Автоматический перезапуск пустого сервера, чтобы он не оставался с кастомной картой
> [!IMPORTANT]
> Нужно настроить время до рестарта сервера, после выхода с него последнего игрока.
>
> Сейчас это происходит моментально, без возможности быстро перезайти на сервер при необходимости.
6. [L4D2 Keep Lasers (1.4) by dcx2 (assist Mr. Zero) - 2020 by SilverShot, 2021 by In1ernal Error](https://forums.alliedmods.net/showthread.php?t=173749)
7. [[L4D & L4D2] Gear Transfer (2.36) by SilverShot](https://forums.alliedmods.net/showthread.php?t=137616)
   - Опционально: плагин **Bot Healing Values**, чтобы боты передавали медикаменты только ЧБ-персонажам.
8. [[L4D & L4D2] Vote Mode (2.2) by SilverShot](https://forums.alliedmods.net/showthread.php?t=179279)
   - Смена режима во время игры: мутации, кооперативные и соревновательные режимы, и многие другие.
   - Опционально: плагин **Mission and Weapons - Info Editor** для загрузки корректной карты при смене режимов Survival/Scavenge
   - Опционально: клиентский V-скрипт **Rayman1103's Mutation Mod** - кастомные мутации, чтобы можно было переключаться на них во время игры
   - `sm_votemode`
9. [[L4D & L4D2] Mission and Weapons - Info Editor (1.26) by SilverShot](https://forums.alliedmods.net/showthread.php?t=310586)
   - Опционально: для плагина **Vote Mode**
10. [[L4D/L4D2] Thirdpersonshoulder Shotgun Sound Fix (1.2) by MasterMind420, Lux, HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_shotgun_sound_fix)
    - Зависимость: плагин **ThirdPersonShoulder Detect**
11. [ThirdPersonShoulder_Detect (1.5.3) by MasterMind420 & Lux](https://forums.alliedmods.net/showpost.php?p=2830180&postcount=32)
    - Требуется для плагина **ThirdPersonShoulder Shotgun Sound Fix**
12. [Connect Announce (1.9) by Arg!](https://forums.alliedmods.net/showthread.php?t=77306)
    - Оповестительные сообщения в чате при входе/выходе игроков
    - Для рядовых игроков показывается краткая информация: страна и причина отключения
    - Для админов выводятся подробности: страна, регион, город, причина отключения, Steam ID, IP.
    - Зависимость: скрипты **Multi Colors** для компиляции плагина
13. [Steam Works Group Manager (1.9) by Someone](https://github.com/SomethingFromSomewhere/SWGM)
    - Библиотека с интеграцией **SteamWorks** для проверки подписки/прав игрока в Steam группе
    - Зависимость: расширение **SteamWorks**
    - `Failed to auto generate config for SWGM.smx, make sure the directory has write permission.`
         - Для автоматической генерации конфига нужно вручную создать для него конечную папку: `left4dead2/cfg/sourcemod/swgm`
         - Точный путь конфига можно узнать в исходнике: `AutoExecConfig(true, "swgm", "sourcemod/swgm");`
    - Форкнул: взял свежие исходники плагина из репозитория и скомпилировал их на базе последней версии **SteamWorks**
> [!IMPORTANT]
> Надо написать плагин с приветственными/информационными сообщениями для игроков, которые не подписаны на группу.
14. [[L4D & L4D2] Left 4 DHooks Direct (1.159) by SilverShot](https://forums.alliedmods.net/showthread.php?t=321696)
    - Главная зависимость для подавляющего большинства других плагинов и разработки своих. Иногда из-за обновлений игры (даже в пару килобайт) этот плагин ломается, а вместе с ним отваливается половина других плагинов и всё сообщество ждёт от автора фикса.
15. [L4D1/2 Drop Secondary (2.7-2025/11/8) by HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/drop_secondary)
    - Дроп второстепенного оружия после смерти: все пистолеты и милишки, включая бензопилу.
    - Зависимость: **Left 4 DHooks Direct**
16. [[L4D1/2] Weapon Drop (1.13-2024/2/15) by Machine, dcx2, Electr000999 /z, Senip, Shao, NoroHime, HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_drop)
    - Дроп текущего оружия/предмета командой `sm_drop` или `sm_g`
    - Пока нет форка: стоит блокировка на дроп всего второстепенного оружия
> [!IMPORTANT]
> Надо форкать, потому что плагин позволяет выкидывать все предметы, оставляя игрока в А-позе, либо блокирует возможность выбрасывать всё второстепенное оружие.
17. [Server namer (3.2) by sheo](https://forums.alliedmods.net/showthread.php?p=2030557)
    - Динамически меняет имя сервера в зависимости от условий
    - Если на сервере запущена игра, то в его имени выводится: название, номер, сборка, режим игры и сложность (если режим поддерживает разные уровни сложности).
    - Если сервер пустой, то в его имени выводится название, номер и сборка: **Vanilla**, **Legacy**, **LMBX**, **Test**, **Dev**.

#### Зависимости
1. [Multi Colors 2.1.2](https://github.com/Bara/Multi-Colors)
   - Общая зависимость для плагинов, которые используют цвета в сообщениях игрового чата

#### Плагины для разработки и тестирования
- [[ANY] Dev Cmds (1.52) by SilverShot](https://forums.alliedmods.net/showthread.php?t=187566)
   - Набор отладочных команд, например: перезагрузка всех плагинов, управление ботами, рестарт раунда и многое другое.
- [[DEV] Autoreload plugins (1.16) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?p=2686825)
   - Горячая перезагрузка плагина при его добавлении/компиляции/удалении

#### L4D2 Survivor Bot AI Improver
> [!CAUTION]
> С этим плагином было много проблем на старом L4L: ошибки, лаги, краши.
>
> Поэтому в сборке его нет и возможно не будет **(!)**
>
> Вместо него надо попробовать **Left 4 Bots 2** из мастерской, который активно поддерживается и обновляется.

На форуме убедительно доказывают, что он работает стабильно и не лагает, даже если смешать его с другими плагинами про ботов и V-скриптом **Left 4 Bots 2**.

- [Репозиторий оригинала](https://github.com/Kerouha/L4D2-Survivor-Bot-AI-Improver)
   - Автор практически забил на плагин, но эпизодически вливает изменения в [экспериментальную ветку](https://github.com/Kerouha/L4D2-Survivor-Bot-AI-Improver/tree/experimental)
- [Репозиторий форка](https://github.com/Emana202/L4D2-Survivor-Bot-AI-Improver)
   - Обновляется гораздо чаще оригинала и медленно, но верно поддерживается. Изменения из форка, время от времени, вливаются в оригинальный репозиторий и наоборот.
   - [Тема на форуме](https://forums.alliedmods.net/showthread.php?t=342872)

#### Репозитории плагинов
- [Jackzmc / sourcemod-plugins](https://github.com/Jackzmc/sourcemod-plugins)
- [fbef0102 / L4D1_2-Plugins](https://github.com/fbef0102/L4D1_2-Plugins), [fbef0102 / Sourcemod-Plugins](https://github.com/fbef0102/Sourcemod-Plugins)
   - Один из самых активных разработчиков в сообществе: самостоятельно пишет плагины, публичные и приватные за деньги, реворкает/ремейкает чужие и заброшенные. Выкладывает всё в свой репозиторий и хорошо поддерживает его.
- [fdxx / l4d2_plugins](https://github.com/fdxx/l4d2_plugins)
- [wyxls / SourceModPlugins-L4D2](https://github.com/wyxls/SourceModPlugins-L4D2)
- [A1oneR / L4D2_DRDK_Plugins](https://github.com/A1oneR/L4D2_DRDK_Plugins)
- [Dosergen / Stuff](https://github.com/Dosergen/Stuff)
   - Активный админ кастомных L4D1-2 серверов: берёт оригинальные плагины, фиксит, что может, подгоняет их под свои нужды и добавляет поддержку первой Left 4 Dead.
- [garamond13 SourcePawn repositories](https://github.com/garamond13?tab=repositories&language=sourcepawn)
- [Hatsune-Imagine / l4d2-plugins](https://github.com/Hatsune-Imagine/l4d2-plugins)
- [PaaNChaN / L4D2_Plugins](https://github.com/PaaNChaN/L4D2_Plugins)
- [Target5150 / MoYu_Server_Stupid_Plugins](https://github.com/Target5150/MoYu_Server_Stupid_Plugins)
- [SirPlease / L4D2-Competitive-Rework](https://github.com/SirPlease/L4D2-Competitive-Rework)
   - Набор соревновательных плагинов, часть из которых подходит и для кооператива, с хорошей поддержкой репозитория.
- [Tabbernaut / L4D2-Plugins](https://github.com/Tabbernaut/L4D2-Plugins)
- [Stabbath / L4D2-Stuff](https://github.com/Stabbath/L4D2-Stuff)

### V-скрипты
[Мастерская Left 4 Dead 2](https://steamcommunity.com/app/550/workshop)

[Коллекция серверных V-скриптов в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3608129891)

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
> [!CAUTION]
> Проверить: не работает в соревновательных режимах?
>
> Проверить: клипается ли звук выстрелов с дефолтных пистолетов?
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

### Dev-сборка
После рестарта пустого сервера загружается случайная официальная кампания со второй карты

### Консольные команды
- [List of Left 4 Dead 2 console commands and variables](https://developer.valvesoftware.com/wiki/List_of_Left_4_Dead_2_console_commands_and_variables)

### Онлайн-инструменты
- [Steam ID Finder](https://steamid.pro)
- [STEAMID I/O - lookup and convert your steamID, steamID3, steamID64, customURL and community id](https://steamid.io)
- [GitHub Repository Downloader](https://sauravhathi.github.io/github-repository-downloader)

### Клиент
- [Left 4 Dead 2 Complete Launch Options](https://steamcommunity.com/sharedfiles/filedetails/?id=3543870520)
- [Ultimate L4D2 Config](https://github.com/theletterjwithadot/Ultimate-Config-for-L4D2)

#### Мастерская
[Коллекция клиентских V-скриптов в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3610995671)

- [Rayman1103's Mutation Mod](https://steamcommunity.com/sharedfiles/filedetails/?id=121070254)
   - Для корректного переключения мутаций во время игры через плагин **Vote Mode**

#### Программы
- [Source Admin Tool (HLSW Alternative)](https://forums.alliedmods.net/showthread.php?t=289370)
   - Мониторинг серверов с чатом и RCON

### Репозиторий
- `git rm --cached -r`
   - Удалить файл из репозитория, если он уже туда попал, но оставить его локально на тачке
   - После этой команды нужно закоммитить и запушить изменения в репозиторий
   - Пример:
      ```
      git rm --cached -r "Platform/Windows/SteamCMD"
      git commit -m "Stop tracking SteamCMD runtime files"
      ```
- Максимальный размер коммита для GitHub репозитория: **150 мегабайт** (но это не точно)
- [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

### Steam
- `An error occurred while attempting to download a file from the UGC server!`
   - Временная проблема на стороне Steam, обычно исправляют в течении нескольких дней
- [Как передать управление группой](https://steamcommunity.com/discussions/forum/26/1291817837640449310)
- **Branding image** в Steam-коллекции поддерживает следующие форматы: **JPEG**, **GIF**, **PNG**.