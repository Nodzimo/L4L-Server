# Left 4 Legend <sup>v2 beta</sub>
> [!WARNING]
> В работе!

> [!TIP]
> Сайт: [L4L.su](https://L4L.su)
> 
> Баны: [Bans.L4L.su](https://Bans.L4L.su)
> 
> Дискорд: [Discord.L4L.su](https://Discord.L4L.su)
> 
> Группа: [steamcommunity.com/groups/Left4Legend](https://steamcommunity.com/groups/Left4Legend)

| №   | Сервер         | Адрес                                        | Карты              | sm_basepath        |
| --- | -------------- | -------------------------------------------- | ------------------ | ------------------ |
| 1   | L4L Vanilla #1 | [L4L.su:27031](steam://connect/L4L.su:27031) | main, winter, xmas | sourcemod_vanilla1 |
| 2   | L4L Vanilla #2 | [L4L.su:27032](steam://connect/L4L.su:27032) | main, winter, xmas | sourcemod_vanilla2 |
| 3   | L4L Vanilla #3 | [L4L.su:27033](steam://connect/L4L.su:27033) | main, winter, xmas | sourcemod_vanilla3 |
| 4   | L4L Vanilla #4 | [L4L.su:27034](steam://connect/L4L.su:27034) | main, winter, xmas | sourcemod_vanilla4 |
| 5   | L4L Vanilla #5 | [L4L.su:27035](steam://connect/L4L.su:27035) | main, winter, xmas | sourcemod_vanilla5 |
| 6   | L4L Legacy     | [L4L.su:27041](steam://connect/L4L.su:27041) |                    | sourcemod_legacy   |
| 7   | L4L LMBX       | [L4L.su:27051](steam://connect/L4L.su:27051) |                    | sourcemod_lmbx     |
| 8   | L4L Test       | [L4L.su:27021](steam://connect/L4L.su:27021) | lab, second        | sourcemod_test     |
| 9   | L4L Dev        | localhost:27020                              |                    | sourcemod_dev      |

## Оглавление
- [Left 4 Legend v2 beta](#left-4-legend-v2-beta)
  - [Оглавление](#оглавление)
  - [Дорожная карта](#дорожная-карта)
  - [Хостинг](#хостинг)
  - [Документация](#документация)
    - [Установка сервера](#установка-сервера)
    - [Моды](#моды)
    - [SourceMod расширения](#sourcemod-расширения)
    - [SourceMod плагины](#sourcemod-плагины)
      - [Зависимости](#зависимости)
      - [Плагины L4L](#плагины-l4l)
      - [Плагины для разработки и тестирования](#плагины-для-разработки-и-тестирования)
      - [Сезонное](#сезонное)
      - [L4D2 Survivor Bot AI Improver](#l4d2-survivor-bot-ai-improver)
      - [Репозитории плагинов](#репозитории-плагинов)
    - [V-скрипты](#v-скрипты)
      - [Неактуально](#неактуально)
    - [Карты](#карты)
      - [Основные](#основные)
      - [Второстепенные](#второстепенные)
      - [Зимние](#зимние)
      - [Новогодние](#новогодние)
      - [Тестовые](#тестовые)
    - [Краши](#краши)
    - [Отладка](#отладка)
    - [Dev-сборка](#dev-сборка)
    - [Обслуживание](#обслуживание)
    - [Консольные команды](#консольные-команды)
    - [Онлайн-инструменты](#онлайн-инструменты)
    - [Клиент](#клиент)
      - [Мастерская](#мастерская)
      - [Программы](#программы)
    - [Репозиторий](#репозиторий)
    - [Steam](#steam)

## Дорожная карта
- До 16 декабря 2025 года
  1. ~~Переезд на VPS с возможностью интеграции Discord~~
  2. ~~Ванильная сборка, которая послужит ядром для остальных сборок~~.
  3. ~~Интеграция Discord~~
  4. ~~SourceBans++~~
  5. ~~Поднять старый сайт с мониторингом серверов~~
- В очереди:
  1. **RCON** не работает на VPS
  2. Не отправляются сообщения из Discord на сервер
  3. Коллекции кастомных карт и автоматизация их установки на серверы
- Q4 2025 - Q1 2026
  1. Перезапуск сайта: [L4L.su](https://l4l.su)
  2. Перезапуск Steam-группы: [Left 4 Legend](https://steamcommunity.com/groups/Left4Legend)
  3. Релиз ваниллы
- Q2 2026
  1. Переосмысление Legacy-сборки
  2. Переосмысление и декомпозиция **Left 4 Legend: Plugin** с публикацией в опенсорс и на форум
- Когда-нибудь
  1. SourceTV
     - [Поддержка SourceTV](https://github.com/shqke/sourcetvsupport)
     - [Документация SourceTV](https://developer.valvesoftware.com/wiki/SourceTV)
  2. Статистика с графиками и отчётами на сайте
     - [HLstatsX v2](https://github.com/SnipeZilla/HLstatsX-v2)
     - [HLstatsX: Community Edition](https://github.com/A1mDev/hlstatsx-community-edition)
     - [DragoStats Coop](https://forums.alliedmods.net/showthread.php?t=320247)

## Хостинг
1. Локальный
   - Тип: **DS**
   - DC: **Балашиха**
   - CPU: **Intel Core i5-7200U**
   - Core: **x4 @ 2.50** GHz
   - RAM: **8**
   - SSD: **500** GB Samsung 870 EVO
   - OS: **Ubuntu 24.04.3 LTS**
   - Нагрузка:
     - Idle: **≈50%**
     - Peak: **≈70%**
2. [Джино](https://jino.ru/vps)
   - Тип: **VPS**
   - Тариф: **Гамма Плюс +**
   - DC: **Москва**
   - CPU: **Intel Xeon E5-2678 v3**
   - Core: **x3 @ 2.0** GHz (заявлено)
   - Core: **x3 @ 2.50** GHz (по мониторингу)
   - RAM: **10**
   - SSD: **70**
   - OS: **Ubuntu 24.04.3 LTS**
   - IP: в тариф не входит и докупается отдельно
   - Нагрузка:
     - Idle: **≈50%**
     - Peak: **≈70%**
3. [UFO.Hosting](https://ufo.hosting/vps-vds)
   - Тип: **VPS**
   - Тариф: **Diadem**
   - DC: **Алматы**
   - CPU: **Intel Xeon E5-2697A v4**
   - Core: **vCore x4 @ 2.40** GHz (заявлено)
   - Core: **x4 @ 2.60** GHz (по мониторингу)
   - RAM: **8**
   - SSD: **90** NVMe
   - OS: **Ubuntu 24.04.3 LTS**
   - IP: **1** публичный IPv4-адрес включён в тариф
   - Порт: **2 Gbps** интернет-канала (заявлено)
   - Порт: в среднем около **200 Mbit** (фактическое ограничение канала от поставщика в Казахстане, на которое не может повлиять хостинг)
   - Трафик: **безлимитный** (заявлено)
   - Трафик: **232 TB** ежемесячно на всех серверах (по FUP - Fair Use Policy)
   - Ограничения: единственный лимит, если сервер будет создавать нагрузку свыше 85% более 6 часов подряд.
   - Обзоры:
     - [Обзор UFO Hosting (VDS)](https://telecomlife.ru/obzor-ufo_hosting-vds)
     - [Обзор UFO Hosting (Hi-CPU)](https://telecomlife.ru/obzor-ufo_hosting-hi-cpu)

## Документация

### Установка сервера
- [Required Ports for Steam](https://help.steampowered.com/en/faqs/view/2EA8-4D75-DA21-31EB)
- [Source Dedicated Server](https://developer.valvesoftware.com/wiki/Source_Dedicated_Server)
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
   - [Invalid platform SteamCMD errors for L4D2](https://github.com/ValveSoftware/steam-for-linux/issues/11522)
   - `force_install_dir`
   - `login anonymous`
   - `app_update 222860 validate`
   - `quit`
- [Command line options](https://developer.valvesoftware.com/wiki/Command_line_options)
- [servercfgfile](https://developer.valvesoftware.com/wiki/Servercfgfile)
- [Host Dedicated Steam Game Servers with Linux - Palworld, CS2, SteamCMD!](https://www.youtube.com/watch?v=frp-bNoqjzc)
- [Left 4 Dead 2 Dedicated Server Guide (Detailed)](https://steamcommunity.com/sharedfiles/filedetails/?id=276173458)
- ```
  [S_API] SteamAPI_Init(): SteamAPI_IsSteamRunning() did not locate a running instance of Steam.
  dlopen failed trying to load:
  /home/steam/.steam/sdk32/steamclient.so
  with error:
  /home/steam/.steam/sdk32/steamclient.so: cannot open shared object file: No such file or directory
  [S_API] SteamAPI_Init(): Sys_LoadModule failed to load: /home/steam/.steam/sdk32/steamclient.so
  ```
  - [steamclient.so [РЕШЕНО]](https://c-s.net.ua/forum/topic87157.html)
  - ['steamclient.so' No such file or directory](https://forums.alliedmods.net/showthread.php?t=344121)
  - [steamclient.so: cannot open shared object file: No such file or directory](https://github.com/CM2Walki/steamcmd/issues/16)
  - [How to fix 'steamclient.so not found' error](https://www.youtube.com/live/frp-bNoqjzc?t=895s)
  - Эта ошибка на линуксе исправляется симлинками:
    - `ln -sfn "$HOME/.local/share/Steam/steamcmd/linux32" "$HOME/.steam/sdk32"`
    - `ln -sfn "$HOME/.local/share/Steam/steamcmd/linux64" "$HOME/.steam/sdk64"`
    - Для L4D2 достаточно будет первой, потому что она 32-битная
- [Steam Web API Key](https://steamcommunity.com/dev/apikey)
- Управление в Linux-утилите **screen**:
  - Отсоединение от screen-сессии: `Ctrl` + `A`, `D`
  - Скроллинг консоли: `Ctrl` + `A`, `Esc`
  - Выход из скроллинга консоли: `Q` или `Esc`
- `status`
- `exit`

### Конфигурация
- [Всё о sv_steamgroup и видимости сервера в меню игры [L4D2]](https://forum.myarena.ru/index.php?/topic/45110-vse-o-sv-steamgroup-i-vidimosti-servera-v-meniu-igry-l4d2)
- ```
  Unknown command ","
  Unknown command "."
  ```
   - В конфигах нельзя писать комментарии на кириллице
- `Unknown command "mat_bloom_scalefactor_scalar"`
   - Закомментировать команду в `left4dead2/cfg/modsettings.cfg`
- Настройками ботов управляет V-скрипт **Left 4 Bots 2**, поэтому если он установлен, то не рекомендуется трогать квары ниже! 
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
- ```
  Disconnected

  Server is enforcing consistency for this file:
  addons\2891062323.vpk
  ```
   - `sv_consistency 0`

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
   - [SourceMod Configuration](https://wiki.alliedmods.net/SourceMod_Configuration)
   - Порядок исполнения конфигов:
     1. Один раз во время запуска сервера исполняется `autoexec.cfg`, **ДО** загрузки **SourceMod** и его плагинов.
     2. На каждой смене карты (`mapchange`) исполняется `server.cfg`, **ПОСЛЕ** загрузки **SourceMod**, но **ДО** исполнения конфигов SourceMod-плагинов.
     3. На каждой смене карты исполняются конфиги SourceMod-плагинов, **ПОСЛЕ** исполнения `server.cfg`. 
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
   - Решение проблемы с расширением Accelerator на линуксе: [Unable to load extension "accelerator.ext": bin/libstdc++.so.6: version `GLIBCXX_3.4.21' not found](https://forums.alliedmods.net/showpost.php?p=2636287&postcount=306)
     1. Удалить `libstdc++.so.6` в директории сервера: `bin`
     2. ``Failed to open dedicated_srv.so (bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /lib/i386-linux-gnu/libstdc++.so.6))``
        - Если появится эта ошибка, то удалить в той же директории: `libgcc_s.so.1`
     3. Установить свежую либу:
        ```
        sudo dpkg --add-architecture i386
        sudo apt install libstdc++6:i386
        ```
     4. Подгрузить новую либу в баш-скрипте, который запускает сервер, пример:
        - `export LD_PRELOAD="/usr/lib/i386-linux-gnu/libstdc++.so.6.0.33"`
2. [SteamWorks Extension (1.2.4) by Kyle Sanderson](https://github.com/hexa-core-eu/SteamWorks)
   - Требуется для следующих плагинов:
     - **Steam Works Group Manager**
     - **Discord API**
     - **Discord Utilities**
3. [Actions (3.9.2) by BHaType](https://forums.alliedmods.net/showthread.php?t=336374)
   - Требуется для плагинов:
     - **Shove Direction Fix**
     - **Bot Healing Values**
     - **AFK and Join Team Commands Improved**
4. [Source Scramble (0.8.1): Tools for working with memory](https://forums.alliedmods.net/showthread.php?t=317175)
   - Требуется для следующих плагинов:
     - **Bot Healing Values**
     - **Charger Collision Patch**
5. [SMJansson (2.6.0/1): JSON parser/writer](https://github.com/davenonymous/SMJansson)
   - Требуется для следующих плагинов:
     - **Discord API**
     - **Discord Utilities**
6. [NEO cURL Extension (2.0.1)](https://forums.alliedmods.net/showthread.php?t=343355)
   - Позволяет SourceMod-плагинам делать запросы в интернет

### SourceMod плагины
[Поиск SourceMod-плагинов для L4D](https://www.sourcemod.net/plugins.php?cat=0&mod=6&title=&author=&description=&search=1)

`sm plugins list`
1. [[L4D2] Custom admin commands (1.3.9e) by honorcode23, Shadowysn (improvements)](https://forums.alliedmods.net/showpost.php?p=2704580&postcount=483)
   - Добавляет в админку дополнительные команды, например: неуязвимость, телепорт, инкап и тому подобные.
2. [[L4D] Map Changer (3.8) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?t=311161)
   - Мультикомбайн: автоматическое добавление новых карт в меню, рейтинг карт, настройка смены кампании после финала и так далее.
   - `sm_maps`
> [!CAUTION]
> Баг: голосование за возврат в лобби загружает следующую карту, поэтому временно используется фикс от **3ipka\***
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
    - Зависимости:
      - Скрипты **Multi Colors** для компиляции плагина
      - База геоданных **GeoIP2 GeoLite2**
    - `sm_geolist`
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
    - Требуется для следующих плагинов:
      - **Drop Secondary**
      - **AFK and Join Team Commands Improved**
      - **VS Auto-spectate on AFK**
      - **L4L: Car Alarm Spawn Tank**
15. [L4D1/2 Drop Secondary (2.7-2025/11/8) by HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/drop_secondary)
    - Дроп второстепенного оружия после смерти: все пистолеты и милишки, включая бензопилу.
    - Зависимость: **Left 4 DHooks Direct**
16. [[L4D1/2] Weapon Drop (1.13-2024/2/15) by Machine, dcx2, Electr000999 /z, Senip, Shao, NoroHime, HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_drop)
    - Дроп текущего оружия/предмета командой `sm_drop` или `sm_g`
    - Пока нет форка: стоит блокировка на дроп всего второстепенного оружия
> [!IMPORTANT]
> Надо форкать, потому что плагин позволяет выкидывать все предметы, оставляя игрока в А-позе, либо блокирует возможность выбрасывать всё второстепенное оружие.

> [!WARNING]
> Временно используется форк со старого L4L
17. [Server namer (3.2) by sheo](https://forums.alliedmods.net/showthread.php?p=2030557)
    - Динамически меняет имя сервера в зависимости от условий:
      1. Если сервер пустой, то в его имени выводится название, номер и сборка: `Vanilla`, `Legacy`, `LMBX`, `Test`, `Dev`.
      2. Если на сервере запущена игра, то в его имени выводится: название, номер, сборка, режим игры и сложность (если режим поддерживает разные уровни сложности).
18. [[ANY] Vote server restart (1.2) by Dragokas](https://forums.alliedmods.net/showthread.php?t=328812)
    - Голосование за рестарт сервера
    - Зависимость: база геоданных **GeoIP2 GeoLite2**
    - `sm_restart`
19. [[L4D & L4D2] Survivor Shove (1.17) by SilverShot](https://forums.alliedmods.net/showthread.php?t=318694)
    - Даёт возможность прикладить выживших и настраивать права на это действие
    - `Shove + Use`
20. [[L4D2] UpgradePack Gives Ammo (1.0) by NoroHime](https://forums.alliedmods.net/showthread.php?p=2805168)
    - Апгрейды патронов полностью восполняют амуницию оружия (1 раз)
21. [[L4D1 & L4D2] SM Respawn Improved (3.9) by AtomicStryker & Ivailosp (Modified by Crasher, SilverShot), fork by Dragokas](https://forums.alliedmods.net/showthread.php?t=323220)
    - Добавляет в админку респавн персонажей по прицелу
> [!CAUTION]
> Если в коопе зареспавнить себя за сторону заразы, то сервер крашится, по крайней мере локальный на винде
22. [[L4D2] Shove Direction Fix by BHaType](https://forums.alliedmods.net/showthread.php?t=319988)
    - Кидает зомби в сторону удара прикладом
    - Зависимость: расширение **Actions**
23. [Warp survivor bots to current player survivor 1.2](https://forums.alliedmods.net/showthread.php?p=2834929)
    - Телепортирует всех ботов разом к игроку
    - `sm_warpbots`
24. [[L4D1/2] Admin Force Pause (1.7-2025/9/11) by pvtschlag, Harry](https://github.com/fbef0102/L4D1_2-Plugins/tree/12dd7560433bf4a097826c98770e0c5e3685e354/l4d2pause)
    - Позволяет админу ставить онлайн-игру на паузу
    - Зависимость: **Multi Colors**
    - `sm_forcepause`
25. [[L4D & L4D2] Bot Healing Values (2.3) by SilverShot](https://forums.alliedmods.net/showthread.php?t=338889)
    - Контролирует использование медикаментов ботами
    - Зависимости:
      - Рекомендуемо: расширение **Source Scramble**
      - Опционально: расширение **Actions**
26. [[L4D(2)] AFK and Join Team Commands Improved (5.5-2025/1/3) by MasterMe & HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_afk_commands)
    - Мультикомбайн: всё (и не только), что связано с АФК, сменой команды и абьюзом бездействия.
    - Зависимости:
      - Расширение **Actions**
      - Плагин **Left 4 DHooks Direct**
      - Плагин **Multi Colors**
    - Рекомендуется для плагина **VS Auto-spectate on AFK**
    - Основные команды:
      - `sm_afk`
      - `sm_join`
      - `sm_zs`
        - Суицид выжившего, например: если он где-то застрянет в безвыходной ситуации.
27. [[L4D1/2] VS Auto-spectate on AFK (2.6-2025/2/12) by djromero (SkyDavid, David Romero) & Harry](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/L4DVSAutoSpectateOnAFK)
    - Закидывает в наблюдателей игрока, который бездействует, а затем кикает его по истечению установленного времени.
    - Зависимости:
      - Плагин **Left 4 DHooks Direct**
      - Плагин **Multi Colors**
      - Плагин **AFK and Join Team Commands Improved**, потому что без него будет закидывать в наблюдателей без возможности вернуться в игру, командой **sm_join**.
28. [[L4D & L4D2] Witch fixes [Left 4 Fix]](https://forums.alliedmods.net/showthread.php?p=2647014)
    - Набор фиксов ведьмы в одном комплекте, примеры: не теряет случайно цель, не теряет цель в убежище, не триггерится дважды и так далее.
29. [Witch Pipebomb exploit fix & Death Optmizer (1.0) by Lux](https://forums.alliedmods.net/showthread.php?t=342000)
    - Фикс бага, когда ведьма исчезает от взрыва пайпы в толпе обычных заражённых.
30. [l4d witch realism door fix (1.0) by HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_witch_realism_door_fix)
    - Фикс бага, когда ведьма не может разбить дверь
31. [[L4D2] Charger_Collision_Patch (2.0.1) by Lux](https://forums.alliedmods.net/showthread.php?t=315482)
    - Фикс бага, когда гром не может пробиться сквозь толпу выживших и останавливается из-за этого
    - Зависимость: расширение **Source Scramble**
32. [[L4D/2] Minigun fix (1.2.2) by SMAC, Kyle Sanderson, Dosergen](https://github.com/Dosergen/Stuff/blob/main/minigun_fix.sp)
    - Фикс бага, когда игрок с огромной скоростью улетает, отпуская миниган под определённым углом.
33. [Simple Anti-Bunnyhop (0.5.1) by CanadaRox, ProdigySim, blodia, CircleSquared, robex, A1m`](https://github.com/SirPlease/L4D2-Competitive-Rework/blob/master/addons/sourcemod/scripting/l4d2_nobhaps.sp)
34. [Discord API (0.1.107) by Deathknife](https://github.com/Cruze03/sourcemod-discord)
    - Зависимости:
      - Расширение **SMJansson**
      - Расширение **SteamWorks**
    - Требуется для плагина **Discord Utilities**
35. [Discord Utilities (2.9.4-BETA) by Cruze](https://forums.alliedmods.net/showthread.php?t=326713)
    - Документация:
      - [Installation](https://github.com/Cruze03/discord-utilities/wiki/Installation)
      - [Collect Required Things](https://github.com/Cruze03/discord-utilities/wiki/Collect-Required-Things)
      - [Setting Up a BOT Account](https://github.com/Cruze03/discord-utilities/wiki/Setting-Up-a-BOT-Account)
      - [Troubleshoot](https://github.com/Cruze03/discord-utilities/wiki/Troubleshoot)
      - [Документация (с картинками) оригинального, неактуального плагина](https://github.com/Deathknife/sourcemod-discord/wiki/Setting-up-a-Bot-Account)
    - Зависимости:
      - Плагин **Discord API**
      - Расширение **SMJansson**
      - Расширение **SteamWorks**
    - Опционально: **SourceBans++**
    - `sm_viewid`
36. [SourceBans++ Main Plugin (1.8.5) by SourceBans Development Team, SourceBans++ Dev Team](https://sbpp.github.io)
    - [Quickstart](https://sbpp.github.io/docs/quickstart)
    - `[sbpp_main.smx] Verify Insert Query Failed: Column 'sid' cannot be null`
      - Прописать в конфиг сервера его ID из [веб-панели SourceBans++](https://bans.l4l.su)
    - ```
      <FAILED> file "dbi.mysql.ext.so": libz.so.1: cannot open shared object file: No such file or directory

      sbpp_checker.smx (SourceBans++: Bans Checker): Failed to connect to SourceBans DB, Could not find driver "mysql"
      ```
      - Эти ошибки на Linux решаются установкой пакета: `apt-get install lib32z1`
    - ```
      [sbpp_main.smx] plugins/basebans.smx was unloaded and moved to plugins/disabled/basebans.smx
      [SM] Plugin Basic Ban Commands unloaded successfully.
      ```
      - После установки **SourceBans++** можно удалить стандартный SourceMod-плагин **Basic Ban Commands** за его ненадобностью, но нельзя удалять его текстовые файлы с переводами, иначе **SourceBans++** будет падать с ошибкой:
        - `Fatal error encountered parsing translation file "basebans.phrases.txt"`
    - Опционально: плагин **SourceBans++ Discord Plugin** (заменён плагином **Discord Utilities**)
37. [[L4D] Vote difficulty (no black screen) (1.17) by Dragokas](https://forums.alliedmods.net/showthread.php?t=317257)
    - Голосование за смену сложности с возможностью добавления кастомных сложностей
    - Зависимость: база геоданных **GeoIP2 GeoLite2**
    - `sm_vd`
38. [[L4D] Votekick (Coop & Versus) (5.1) by alliedfront](https://forums.alliedmods.net/showthread.php?t=349341)
    - Менеджер киков с оповещением админа, которого пытаются кикнуть.
    - Зависимость: база геоданных **GeoIP2 GeoLite2**
    - `sm_vk`
39. [Bot Takeover (4.5) by little_froy](https://forums.alliedmods.net/showthread.php?t=346636)
    - Позволяет после смерти взять свободного бота, нажатием кнопки действия: `E`
40. [[ANY] Command and ConVar - Buffer Overflow Fixer (2.9) by SilverShot and Peace-Maker](https://forums.alliedmods.net/showthread.php?t=309656)
    - Фиксит ошибку `Cbuf_AddText: buffer overflow`, из-за которой сбрасываются установленные значения квар.

#### Зависимости
1. [Multi Colors 2.1.2](https://github.com/Bara/Multi-Colors)
   - Общая зависимость для плагинов, которые используют цветные сообщения в игровом чате
   - Требуется для следующих плагинов:
     - **Connect Announce**
     - **Admin Force Pause**
     - **AFK and Join Team Commands Improved**
     - **VS Auto-spectate on AFK**
2. [GeoIP2 GeoLite2](https://github.com/P3TERX/GeoLite.mmdb)
   - База геоданных для определения страны, региона, города и тому подобного.
   - В свежих версиях SourceMod поставляется в комплекте
   - Обслуживание:
     - `Your database is older than 90 days. You should consider downloading a newer version from e.g. https://dev.maxmind.com/geoip/geolite2-free-geolocation-data`
     - Надо обновлять минимум раз в 90 дней, иначе будет сыпать предупреждение в консоль сервера.
   - Требуется для следующих плагинов:
     - **Connect Announce**
     - **Vote server restart**
     - **Vote difficulty**
     - **Votekick**

#### Плагины L4L
0. SDK
   - Пакет зависимостей для сборки и компиляции всех плагинов L4L из этого списка
1. Exec Server Config
   - Исполняет специфический для сервера конфиг в зависимости от квары
   - Если ранее была выбрана кастомная сложность **Impossible+**, то исполняет соответствующий ей конфиг: `server_expert+.cfg`.
   - Если установлена кастомная сложность, то выводит её название в имени сервера
2. Survivor Bots Fire Damage
   - Перезаписывает урон от огня по выжившим ботам, в соответствии с установленным значением в кваре.
3. Survivor Incap Spawn SI
   - Инкап спавнит особых
   - `l4l_spawn_si`
4. Car Alarm Spawn Tank
   - Сигналка может заспавнить танка
   - Зависимость: плагин **Left 4 DHooks Direct**
   - `l4l_spawn_tank`
5. Witch Scream Spawn Mob
   - Крик ведьмы спавнит орду
6. Survivor Death Spawn Mob
   - Смерть выжившего спавнит орду
7. Director Spawn SI Limit
   - Контролирует лимит особых, которых спавнит режиссёр. 
   - `l4l_si_limit`
8. Hide Kill Feed

#### Плагины для разработки и тестирования
1. [[ANY] Dev Cmds (1.52) by SilverShot](https://forums.alliedmods.net/showthread.php?t=187566)
   - Набор отладочных команд, например: перезагрузка всех плагинов, управление ботами, рестарт раунда и многое другое.
2. [[DEV] Autoreload plugins (1.16) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?p=2686825)
   - Горячая перезагрузка плагина при его добавлении/компиляции/удалении

#### Сезонное
- **Рождество** (<ins>ориентировочно</ins> с 1 декабря по 1 февраля)
  1. [[L4D & L4D2] Christmas Tree (1.9) by SilverShot](https://forums.alliedmods.net/showthread.php?t=319552)
  2. [[L4D & L4D2] xMas (1.6) by raziEiL [disawar1], gratters by Electr000999](https://forums.alliedmods.net/showpost.php?p=2678402&postcount=31)
     - `/xmas Sefo "Merry Xmas"`

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
- [HayaseYuukaSAMA / L4D2-MSF-Server-Plugins](https://github.com/HayaseYuukaSAMA/L4D2-MSF-Server-Plugins)
- [Dreasye791 / my-multi-Infected-plugins](https://github.com/Dreasye791/my-multi-Infected-plugins)
- [rikka0w0 / rikkal4d2](https://github.com/rikka0w0/rikkal4d2)
- [devilesk / rl4d2l-plugins](https://github.com/devilesk/rl4d2l-plugins)
- [LuxLuma / Left-4-fix](https://github.com/LuxLuma/Left-4-fix)
  - Репозиторий с набором фиксов от сообщества

### V-скрипты
[Мастерская Left 4 Dead 2](https://steamcommunity.com/app/550/workshop)

[Коллекция серверных V-скриптов в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3608129891)

1. [Carryable placer](https://steamcommunity.com/sharedfiles/filedetails/?id=3208147246)
2. [Unreachable item spawns fixes (100+)](https://steamcommunity.com/sharedfiles/filedetails/?id=2493132849)
3. [[VSCRIPT] No Friendly Fire on Charger Carry](https://steamcommunity.com/sharedfiles/filedetails/?id=3432580793)
4. [Wandering Witch Shove Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3359130948)
5. [No Camera Shake When Bots Shoot You [VScript]](https://steamcommunity.com/sharedfiles/filedetails/?id=3233665119)
6. [Full Clip On Mag Insert VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3339719078)
7. [C1M3 Instant Horde Remover](https://steamcommunity.com/sharedfiles/filedetails/?id=3356940910)
8. [Automatic Guns/Autofire VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=2949667423)
> [!CAUTION]
> Проверить: не работает в соревновательных режимах?
>
> Проверить: клипается ли звук выстрелов с дефолтных пистолетов?
9. [No Active Camera Damage VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3323149700)
10. [Left 4 Bots 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3022416274)
    - [L4B2 commands](https://github.com/smilz0/Left4Bots/blob/main/COMMANDS.md)
    - [Настройки конфига](https://github.com/smilz0/Left4Bots/blob/main/root/scripts/vscripts/left4bots_settings.nut)
    - [Addon customization](https://steamcommunity.com/workshop/filedetails/discussion/3022416274/3825299103410056029)
    - Зависимости:
      - **Left 4 Lib**
      - **NavFixes**
11. [Left 4 Lib](https://steamcommunity.com/workshop/filedetails/?id=2634208272)
    - Требуется для **Left 4 Bots 2**
12. [NavFixes](https://steamcommunity.com/workshop/filedetails/?id=3226661388)
    - Требуется для **Left 4 Bots 2**
13. [Zero's Behavior Patches](https://steamcommunity.com/sharedfiles/filedetails/?id=3417724055)
14. [Worker Infected Boomer Bile Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3347447993)
15. [Explosive Ammo Deals Double Damage to Tank [Commission]](https://steamcommunity.com/sharedfiles/filedetails/?id=3575571984)
16. [Item giver](https://steamcommunity.com/sharedfiles/filedetails/?id=3237016899)
17. [Leg shot stumble](https://steamcommunity.com/sharedfiles/filedetails/?id=3413451176)
18. [Lethal Chainsaw Shoves](https://steamcommunity.com/sharedfiles/filedetails/?id=3570114485)
19. [Common Infected Gib on Shove Kill](https://steamcommunity.com/sharedfiles/filedetails/?id=3368655362)
20. [Common Infected Goomba Stomp Feedback](https://steamcommunity.com/sharedfiles/filedetails/?id=3362814416)
21. [[Improved] Headshot Feedback Effect](https://steamcommunity.com/sharedfiles/filedetails/?id=2582265366)
    - Зависимость: **Manacat Common Library** 
22. [Manacat Common Library](https://steamcommunity.com/workshop/filedetails/?id=213445426)
    - Требуется для **[Improved] Headshot Feedback Effect**
    - Опционально: аддон **Disable Manacat Weapon Skin RNG**
23. [Incendiary Ammo Triggers Car Alarm](https://steamcommunity.com/sharedfiles/filedetails/?id=3161832134)
24. [Pipe Bomb Car Alarm Bug Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3620048167)
25. [Disable Manacat Weapon Skin RNG](https://steamcommunity.com/sharedfiles/filedetails/?id=3512270023)
    - Отключает рандомные TLS-скины, зашитые в **Manacat Common Library**
    - Зависимость: аддон **Manacat Common Library**
26. [[V-Script] Smoker Antic Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3238400366)
    - Фиксит отсутствие анимации притягивания у смокера на высоком уровне сложности, из-за разницы в таймингах.

#### Неактуально
- Заменён плагином **Votekick**
  - [[L4D2] Vote Blocker v1.3.4](https://forums.alliedmods.net/showthread.php?t=232928)
    - Блокирует голосование за кик админа, оповещая об этом в чате.
    - Опционально: расширение **NEO cURL** (для самообновления?)
    - [Предпоследний форк от valedar](https://forums.alliedmods.net/showpost.php?p=2779227&postcount=135)
    - [Последний форк от alasfourom](https://forums.alliedmods.net/showpost.php?p=2790340&postcount=137)
> [!IMPORTANT]
> Надо форкать форки, потому что на старом L4L сыпались ошибки и автор захардкодил себе иммунитет в плагине, а ещё добавил автоматическое обновление, которое перезаписывает изменения.

> [!WARNING]
> Временно используется форк со старого L4L
- Заменён плагином **Discord Utilities**
  - [SourceBans++ Discord Plugin (1.1.0) by RumbleFrog, SourceBans++ Dev Team](https://sbpp.github.io/docs/discord_forward_setup)
    - Отправляет в **Discord** уведомления о банах и жалобах (можно в 2 разных канала)
    - Зависимости:
      - Расширение **SMJansson**
      - Расширение **SteamWorks**
- Заменены V-скриптом **Zero's Behavior Patches**
  - [Smoker insta-grab fix](https://steamcommunity.com/sharedfiles/filedetails/?id=2945656229)
  - [No Fall Stagger Cancel VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3313875830)

### Карты
[Коллекция всех карт в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3608021337)

#### Основные
[Коллекция в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3622048772)

1. [Dead South](https://steamcommunity.com/sharedfiles/filedetails/?id=3378140391)
2. [Diescraper Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=121116980)
   - Конфликтует с **Day Break**
     > Rectus [author] 8 Nov, 2024 @ 11:41pm

     > Yeah, from with I remember it conflicts with Daybreak. Diescraper has support for my custom weapons and will enable them if the melee scripts for them are avilalble, and Daybreak has the flamethrower weapon included as an easter egg. Unfortunately it will only load the script and not the model from other campaigns.
3. [Questionable Ethics: Combined](https://steamcommunity.com/sharedfiles/filedetails/?id=2758492786)
4. [Questionable Ethics](https://steamcommunity.com/sharedfiles/filedetails/?id=2783476025)
5. [Questionable Ethics: Alpha test](https://steamcommunity.com/sharedfiles/filedetails/?id=2783484731)
6. [Dark Wood (Extended)](https://steamcommunity.com/workshop/filedetails/?id=575682109)

#### Второстепенные
[Коллекция в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3622048321)

1. [Day Break (Campaign)](https://steamcommunity.com/sharedfiles/filedetails/?id=180925247)
   - Конфликтует с **Diescraper Redux**

#### Зимние
[Коллекция в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3622046591)

1. [Snow Den 2.0, Holiday release (definitive version)](https://steamcommunity.com/sharedfiles/filedetails/?id=3396441138)
2. [Winter Carnival](https://steamcommunity.com/sharedfiles/filedetails/?id=2891062323)
3. [Winter Harvest Train](https://steamcommunity.com/sharedfiles/filedetails/?id=3427138500)
4. [Death Toll Winter](https://steamcommunity.com/sharedfiles/filedetails/?id=2884330969)
5. [Whispers of Winter](https://steamcommunity.com/sharedfiles/filedetails/?id=1643520526)
    - Рекомендуется: **Informal Skyboxes**
> [!CAUTION]
> Проверить: в комментариях жалуются на частые краши, особенно после **Deluxe Update**.
6. [Cold Front](https://steamcommunity.com/workshop/filedetails/?id=3135470026)

#### Новогодние
[Коллекция в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3622045205)

1. [A Christmas Bridge](https://steamcommunity.com/sharedfiles/filedetails/?id=3385079215)
2. [Dead Center: Christmas Edition (Part 1)](https://steamcommunity.com/sharedfiles/filedetails/?id=2668272749)
3. [No Mercy Christmas Edition (Part 2)](https://steamcommunity.com/sharedfiles/filedetails/?id=3101550309)
> [!CAUTION]
> Проверить: первая карта сильно лагала на старом L4L
4. [Deadly New Year](https://steamcommunity.com/sharedfiles/filedetails/?id=3404576339)

#### Тестовые
[Коллекция в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3622049670)

1. [Whitaker's Weapons Range by danfs0 [RE-UPLOAD]](https://steamcommunity.com/sharedfiles/filedetails/?id=3001153036)
2. [The Ultimate Mod Testing and Reviewing Area - Main Files](https://steamcommunity.com/sharedfiles/filedetails/?id=469986973)

### Краши
- [CUtlRBTree overflow!](https://crash.limetech.org/xqtbyrgkbhyy)
   - [[l4d2] dedicated server crash need help "CUtlRBTree overflow!"](https://forums.alliedmods.net/showthread.php?t=336626)
   - [CUtlRBTree fix](https://github.com/fdxx/cutlrbtreefix)

### Отладка
- [Debugging under Linux](https://developer.valvesoftware.com/wiki/Debugging_under_Linux)
- [New commands for server debugging](https://forums.alliedmods.net/showthread.php?t=327850)

### Dev-сборка
- После рестарта пустого сервера загружается случайная официальная кампания со второй карты

### Обслуживание
- [Краш репорты](https://crash.limetech.org/dashboard)
- Логи: `left4dead2/addons/sm_basepath/logs`
- [Мониторинг железа](https://glances.nodzimo.ru)
- Если изменился порядок серверов, то нужно менять в конфигах их ID для [SourceBans++](https://bans.l4l.su) и **Discord Utilities**.
- Если вышло обновление L4D2, то нужно обновлять сервера через **SteamCMD**, не забывая после этого редактировать автоматически загруженные файлы, например:
  - Удалить:
    - `bin/libstdc++.so.6`
    - `bin/libgcc_s.so.1`
  - Перезаписать: `left4dead2/cfg/modsettings.cfg`
- Минимум раз в 90 дней обновлять базу геоданных [GeoIP2 GeoLite2](https://github.com/P3TERX/GeoLite.mmdb)
- Обновлять кастомные карты и аддоны на серверах, если вышли обновления в мастерской.
- Репортить ошибки плагинов и аддонов их авторам

### Консольные команды
- [List of Left 4 Dead 2 console commands and variables](https://developer.valvesoftware.com/wiki/List_of_Left_4_Dead_2_console_commands_and_variables)

### Онлайн-инструменты
- [Steam ID Finder](https://steamid.pro)
- [STEAMID I/O - lookup and convert your steamID, steamID3, steamID64, customURL and community id](https://steamid.io)
- [GitHub Repository Downloader](https://sauravhathi.github.io/github-repository-downloader)
- [Spider - SourcePawn Compiler](https://spider.limetech.io)
- [Lysis Decompiler](https://headlinedev.xyz/lysis)

### Клиент
- [Left 4 Dead 2 Complete Launch Options](https://steamcommunity.com/sharedfiles/filedetails/?id=3543870520)
- [Ultimate L4D2 Config](https://github.com/theletterjwithadot/Ultimate-Config-for-L4D2)

#### Мастерская
[Коллекция клиентских V-скриптов в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3610995671)

1. [Rayman1103's Mutation Mod](https://steamcommunity.com/sharedfiles/filedetails/?id=121070254)
   - Для корректного переключения мутаций во время игры через плагин **Vote Mode**
2. [Informal Skyboxes](https://steamcommunity.com/workshop/filedetails/?id=121090376)
   - Рекомендуется к следующим картам:
     - **Whispers of Winter**

[Коллекция клиентских V-скриптов для разработки и отладки](https://steamcommunity.com/sharedfiles/filedetails/?id=3615308395)

- [Director Intensity Graph Enabler (Default HUD)](https://steamcommunity.com/sharedfiles/filedetails/?id=3145769266)
   - Работает на выделенном сервере

#### Программы
- [Source Admin Tool (HLSW Alternative)](https://forums.alliedmods.net/showthread.php?t=289370)
   - Мониторинг серверов с чатом и RCON

### Репозиторий
- `git rm --cached -r`
   - Удалить файл из репозитория, если он уже туда попал, но оставить его локально на тачке
   - После этой команды нужно закоммитить и запушить изменения в репозиторий, пример:
      ```
      git rm --cached -r "Platform/Windows/SteamCMD"
      git commit -m "Stop tracking SteamCMD runtime files"
      ```
- `git revert --no-commit ID`
  - Вернуть изменённые файлы из коммита в состояние **Staged Changes** без коммита, не затрагивая все предыдущие и последующие коммиты в Git-истории.
- Максимальный размер коммита для GitHub репозитория: **150 мегабайт** (но это не точно)
- [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
- [Organizing information with tables](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/organizing-information-with-tables)

### Steam
- `An error occurred while attempting to download a file from the UGC server!`
   - Временная проблема на стороне Steam, обычно исправляют в течение нескольких дней
   - Некоторым помогают стандартные процедуры: чистка кэша загрузок в Steam, инвалидация/переустановка игры, сброс облачной синхронизации файлов игры и тому подобное.
   - Также может помочь переключение Steam клиента с бета версии на стабильную, потому что эта ошибка обычно прилетает с обновлениями, которые сначала раскатывают на бета версию, а затем на стабильную. Словив ошибку на бета версии, можно переключиться на стабильную, на которой обновления с ошибкой ещё нет.  
- [Как передать управление группой](https://steamcommunity.com/discussions/forum/26/1291817837640449310)
- **Branding image** в Steam-коллекции поддерживает следующие форматы: **JPEG**, **GIF**, **PNG**.