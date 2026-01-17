# Left 4 Legend <sup>v2 release candidate</sub>
> [!WARNING]
> В работе!
>
> Кодовое название: **2.0 Rebuild**

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
| 8   | L4L Test       | [L4L.su:27021](steam://connect/L4L.su:27021) | second             | sourcemod_test     |
| 9   | L4L Dev        | localhost:27020                              |                    | sourcemod_dev      |

## Оглавление
- [Left 4 Legend v2 release candidate](#left-4-legend-v2-release-candidate)
  - [Оглавление](#оглавление)
  - [Дорожная карта](#дорожная-карта)
  - [Хостинг](#хостинг)
  - [Документация](#документация)
    - [Установка сервера](#установка-сервера)
    - [Карты](#карты)
      - [Основные](#основные)
      - [Второстепенные](#второстепенные)
      - [Зимние](#зимние)
      - [Новогодние](#новогодние)
      - [Тестовые](#тестовые)
    - [Краши](#краши)
    - [Баги](#баги)
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
  3. ~~Коллекции кастомных карт и автоматизация их установки на серверы~~
  4. Плагин на сброс кастомных кампаний на пустых серверах
- Q4 2025 - Q1 2026
  1. Перезапуск сайта: [L4L.su](https://l4l.su)
  2. Перезапуск Steam-группы: [Left 4 Legend](https://steamcommunity.com/groups/Left4Legend)
  3. Релиз ваниллы
  4. TeamSpeak сервер
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

### Управление
За управление серверами на линуксе отвечает [главный баш-скрипт](https://github.com/Nodzimo/L4L-Server/blob/main/Platform/Linux/home/steam/bin/l4l), который имеет следующие команды:
- `l4l`
  - Выводит краткую справку в терминал
  - Команда полезна, чтобы вспомнить как подключать наборы кастомных карт на разные сервера как в конструкторе.
- `l4l install`
  - Устанавливает через **SteamCMD** (в тихом режиме с автоматическим выходом по завершению) чистый сервер для указанной сборки
  - Пример: `l4l install vanilla`
  - Названия сборок, которые используются в большинстве команд из этого списка:
    - `vanilla` (в некоторых командах можно через пробел указать номер ванильного экземпляра сервера от 1 до 5)
    - `test`
    - `legacy`
    - `lmbx`
- `l4l run`
  - Запускает указанный сервер, примеры:
    - `l4l run vanilla` запустит **ВСЕ** (5) экземпляры серверов с ванильной сборкой
    - `l4l run vanilla 3` запустит 3-й экземпляр сервера с ванильной сборкой
- `l4l stop`
  - Останавливает (выключает) указанный сервер
- `l4l restart`
  - Перезагружает указанный сервер, если не указать сервер, то перезагрузит **ВСЕ**.
  - Пример: `l4l restart vanilla` перезагрузит **ВСЕ** ванильные сервера с 5-секундной задержкой
- `l4l status`
  - Выводит в терминал статус указанного сервера, если не указать сервер, то покажет все.
- `l4l screen`
  - Подключение к консоли указанного сервера, если не указать сервер, то покажет в терминале все сессии серверов, доступные для подключения.
  - Примеры:
    - `l4l screen vanilla 1`
    - `l4l screen test`
  - Подробности об управлении в утилите **screen** находятся в разделе [Установка сервера](https://github.com/Nodzimo/L4L-Server?tab=readme-ov-file#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B0)
- `l4l delete`
  - Удаляет указанный сервер
- `l4l maps`
  - Команда-конструктор для подключения (линкования) наборов кастомных карт на сервера
  - Примеры:
    - `l4l maps link main vanilla` залинкует основной набор карт на ванильные сервера
    - `l4l maps unlink main vanilla` отлинкует
    - `l4l maps list` выводит в терминал список всех наборов карт, которые находятся в `/home/steam/l4l/shared/maps/`.
    - `l4l maps` вывод краткой справки в терминал
  - Все расшаренные файлы (наборы карт и база геоданных), которые линкуются на сервера, находятся в `/home/steam/l4l/shared/`
  - Подробности о том, какие именно карты присутствуют в наборах, находятся в разделе [Карты](https://github.com/Nodzimo/L4L-Server?tab=readme-ov-file#%D0%BA%D0%B0%D1%80%D1%82%D1%8B).
- `l4l geo`
  - Устанавливает (линкует) базу геоданных **GeoIP2 GeoLite2** для указанного сервера, без которой **SourceMod** и часть плагинов **НЕ** будут корректно работать!
  - Пример: `l4l geo vanilla` залинкует базу данных на все ванильные экземпляры серверов
- `l4l clean`
  - Удаляет старые библиотеки из указанного сервера, из-за которых он даже **НЕ** запустится!
  - Пример: `l4l clean vanilla`
  - Библиотеки находятся в директории сервера: `bin`
    - `libstdc++.so.6`
    - `libgcc_s.so.1`
  - Эти библиотеки загружаются (через **SteamCMD**) каждый раз после установки сервера, поэтому команду нужно вводить каждый раз после свежей переустановки, обновления или валидации сервера.
  - Подробности о том, почему их надо удалять, находятся в разделе [Установка сервера](https://github.com/Nodzimo/L4L-Server?tab=readme-ov-file#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B0).

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
     - **AI: Hard SI**
     - **Dynamic Common Infected Jump**
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
7. [CUtlRBTree overflow fix (0.3.1): Fix CUtlRBTree overflow](https://github.com/fdxx/cutlrbtreefix)
   - Фиксит краш [engine_srv.so!Sys_Error_Internal(bool, char const*, char*) + 0x129](https://crash.limetech.org/xqtbyrgkbhyy) с ошибкой `CUtlRBTree overflow!`
   - [[l4d2] dedicated server crash need help "CUtlRBTree overflow!"](https://forums.alliedmods.net/showthread.php?t=336626)

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
7. [[L4D & L4D2] Vote Mode (2.2) by SilverShot](https://forums.alliedmods.net/showthread.php?t=179279)
   - Смена режима во время игры: мутации, кооперативные и соревновательные режимы, и многие другие.
   - Опционально: плагин **Mission and Weapons - Info Editor** для загрузки корректной карты при смене режимов Survival/Scavenge
   - Опционально: клиентский V-скрипт **Rayman1103's Mutation Mod** - кастомные мутации, чтобы можно было переключаться на них во время игры
   - `sm_votemode`
8. [[L4D & L4D2] Mission and Weapons - Info Editor (1.27) by SilverShot](https://forums.alliedmods.net/showthread.php?t=310586)
   - Опционально: для плагина **Vote Mode**
9. [[L4D/L4D2] Thirdpersonshoulder Shotgun Sound Fix (1.2) by MasterMind420, Lux, HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_shotgun_sound_fix)
    - Зависимость: плагин **ThirdPersonShoulder Detect**
10. [ThirdPersonShoulder_Detect (1.5.3) by MasterMind420 & Lux](https://forums.alliedmods.net/showpost.php?p=2830180&postcount=32)
    - Требуется для плагина **ThirdPersonShoulder Shotgun Sound Fix**
11. [Connect Announce (1.9) by Arg!](https://forums.alliedmods.net/showthread.php?t=77306)
    - Оповестительные сообщения в чате при входе/выходе игроков
    - Для рядовых игроков показывается краткая информация: страна и причина отключения
    - Для админов выводятся подробности: страна, регион, город, причина отключения, Steam ID, IP.
    - Зависимости:
      - Скрипты **Multi Colors** для компиляции плагина
      - База геоданных **GeoIP2 GeoLite2**
    - `sm_geolist`
12. [Steam Works Group Manager (1.9) by Someone](https://github.com/SomethingFromSomewhere/SWGM)
    - Библиотека с интеграцией **SteamWorks** для проверки подписки/прав игрока в Steam группе
    - Зависимость: расширение **SteamWorks**
    - `Failed to auto generate config for SWGM.smx, make sure the directory has write permission.`
         - Для автоматической генерации конфига нужно вручную создать для него конечную папку: `left4dead2/cfg/sourcemod/swgm`
         - Точный путь конфига можно узнать в исходнике: `AutoExecConfig(true, "swgm", "sourcemod/swgm");`
    - Форкнул: взял свежие исходники плагина из репозитория и скомпилировал их на базе последней версии **SteamWorks**
> [!IMPORTANT]
> Надо написать плагин с приветственными/информационными сообщениями для игроков, которые не подписаны на группу.
13. [[L4D & L4D2] Left 4 DHooks Direct (1.161) by SilverShot](https://forums.alliedmods.net/showthread.php?t=321696)
    - Главная зависимость для подавляющего большинства других плагинов и разработки своих. Иногда из-за обновлений игры (даже в пару килобайт) этот плагин ломается, а вместе с ним отваливается половина других плагинов и всё сообщество ждёт от автора фикса.
    - Требуется для следующих плагинов:
      - **Drop Secondary**
      - **AFK and Join Team Commands Improved**
      - **VS Auto-spectate on AFK**
      - **L4L: Car Alarm Spawn Tank**
      - **L4L: Common Infected Damage**
      - **L4L: Infected Drop Loot**
      - **AI: Hard SI**
      - **Explosive Cars**
      - **Incapped Weapons Patch**
      - **Tank Rock Bounces**
      - **All4Dead**
      - **Manual-Spawn Special Infected**
      - **WitchSit**
      - **Tank Rock Pops Explosives**
      - **Charging Charger Stagger**
14. [L4D1/2 Drop Secondary (2.7-2025/11/8) by HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/drop_secondary)
    - Дроп второстепенного оружия после смерти: все пистолеты и милишки, включая бензопилу.
    - Зависимость: плагин **Left 4 DHooks Direct**
15. [[L4D1/2] Weapon Drop (1.13-2024/2/15) by Machine, dcx2, Electr000999 /z, Senip, Shao, NoroHime, HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_drop)
    - Дроп текущего оружия/предмета командой `sm_drop` или `sm_g`
    - Пока нет форка: стоит блокировка на дроп всего второстепенного оружия
> [!IMPORTANT]
> Надо форкать, потому что плагин позволяет выкидывать все предметы, оставляя игрока в А-позе, либо блокирует возможность выбрасывать всё второстепенное оружие.

> [!WARNING]
> Временно используется форк со старого L4L
16. [Server namer (3.2) by sheo](https://forums.alliedmods.net/showthread.php?p=2030557)
    - Динамически меняет имя сервера в зависимости от условий:
      1. Если сервер пустой, то в его имени выводится название, номер и сборка: `Vanilla`, `Legacy`, `LMBX`, `Test`, `Dev`.
      2. Если на сервере запущена игра, то в его имени выводится: название, номер, сборка, режим игры и сложность (если режим поддерживает разные уровни сложности).
    - Опционален для плагина **L4L: Exec Server Config**
17. [[ANY] Vote server restart (1.2) by Dragokas](https://forums.alliedmods.net/showthread.php?t=328812)
    - Голосование за рестарт сервера
    - Зависимость: база геоданных **GeoIP2 GeoLite2**
    - `sm_restart`
18. [[L4D & L4D2] Survivor Shove (1.17) by SilverShot](https://forums.alliedmods.net/showthread.php?t=318694)
    - Даёт возможность прикладить выживших и настраивать права на это действие
    - `Shove + Use`
19. [[L4D2] UpgradePack Gives Ammo (1.0) by NoroHime](https://forums.alliedmods.net/showthread.php?p=2805168)
    - Апгрейды патронов полностью восполняют амуницию оружия (1 раз)
20. [[L4D1 & L4D2] SM Respawn Improved (3.9) by AtomicStryker & Ivailosp (Modified by Crasher, SilverShot), fork by Dragokas](https://forums.alliedmods.net/showthread.php?t=323220)
    - Добавляет в админку респавн персонажей по прицелу
> [!CAUTION]
> Если в коопе зареспавнить себя за сторону заразы, то сервер крашится, по крайней мере локальный на винде
21. [[L4D2] Shove Direction Fix by BHaType](https://forums.alliedmods.net/showthread.php?t=319988)
    - Кидает зомби в сторону удара прикладом
    - Зависимость: расширение **Actions**
22. [Warp survivor bots to current player survivor 1.2](https://forums.alliedmods.net/showthread.php?p=2834929)
    - Телепортирует всех ботов разом к игроку
    - `sm_warpbots`
23. [[L4D1/2] Admin Force Pause (1.7-2025/9/11) by pvtschlag, Harry](https://github.com/fbef0102/L4D1_2-Plugins/tree/12dd7560433bf4a097826c98770e0c5e3685e354/l4d2pause)
    - Позволяет админу ставить онлайн-игру на паузу
    - Зависимость: **Multi Colors**
    - `sm_forcepause`
24. [[L4D & L4D2] Bot Healing Values (2.3) by SilverShot](https://forums.alliedmods.net/showthread.php?t=338889)
    - Контролирует использование медикаментов ботами
    - Зависимости:
      - Рекомендуемо: расширение **Source Scramble**
      - Опционально: расширение **Actions**
25. [[L4D(2)] AFK and Join Team Commands Improved (5.5-2025/1/3) by MasterMe & HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_afk_commands)
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
26. [[L4D1/2] VS Auto-spectate on AFK (2.6-2025/2/12) by djromero (SkyDavid, David Romero) & Harry](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/L4DVSAutoSpectateOnAFK)
    - Закидывает в наблюдателей игрока, который бездействует, а затем кикает его по истечению установленного времени.
    - Зависимости:
      - Плагин **Left 4 DHooks Direct**
      - Плагин **Multi Colors**
      - Плагин **AFK and Join Team Commands Improved**, потому что без него будет закидывать в наблюдателей без возможности вернуться в игру, командой **sm_join**.
27. [[L4D & L4D2] Witch fixes [Left 4 Fix]](https://forums.alliedmods.net/showthread.php?p=2647014)
    - Набор фиксов ведьмы в одном комплекте, примеры: не теряет случайно цель, не теряет цель в убежище, не триггерится дважды и так далее.
28. [Witch Pipebomb exploit fix & Death Optmizer (1.0) by Lux](https://forums.alliedmods.net/showthread.php?t=342000)
    - Фикс бага, когда ведьма исчезает от взрыва пайпы в толпе обычных заражённых.
29. [l4d witch realism door fix (1.0) by HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_witch_realism_door_fix)
    - Фикс бага, когда ведьма не может разбить дверь
30. [[L4D2] Charger_Collision_Patch (2.0.1) by Lux](https://forums.alliedmods.net/showthread.php?t=315482)
    - Фикс бага, когда гром не может пробиться сквозь толпу выживших и останавливается из-за этого
    - Зависимость: расширение **Source Scramble**
31. [[L4D/2] Minigun fix (1.2.2) by SMAC, Kyle Sanderson, Dosergen](https://github.com/Dosergen/Stuff/blob/main/minigun_fix.sp)
    - Фикс бага, когда игрок с огромной скоростью улетает, отпуская миниган под определённым углом.
32. [Simple Anti-Bunnyhop (0.5.1) by CanadaRox, ProdigySim, blodia, CircleSquared, robex, A1m`](https://github.com/SirPlease/L4D2-Competitive-Rework/blob/master/addons/sourcemod/scripting/l4d2_nobhaps.sp)
33. [Discord API (0.1.107) by Deathknife](https://github.com/Cruze03/sourcemod-discord)
    - Зависимости:
      - Расширение **SMJansson**
      - Расширение **SteamWorks**
    - Требуется для плагина **Discord Utilities**
34. [Discord Utilities (2.9.4-BETA) by Cruze](https://forums.alliedmods.net/showthread.php?t=326713)
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
35. [SourceBans++ Main Plugin (1.8.5) by SourceBans Development Team, SourceBans++ Dev Team](https://sbpp.github.io)
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
36. [[L4D] Vote difficulty (no black screen) (1.17) by Dragokas](https://forums.alliedmods.net/showthread.php?t=317257)
    - Голосование за смену сложности с возможностью добавления кастомных сложностей
    - Зависимость: база геоданных **GeoIP2 GeoLite2**
    - Опционален для плагина **L4L: Exec Server Config**
    - `sm_vd`
> [!IMPORTANT]
> Используется мой форк, в котором исправлен сброс выбранной в меню кастомной сложности после смены карты, а нативное голосование открывает меню плагина, вместо запуска голосования.
>
> Также добавлены дополнительные команды для открытия меню: `sm_hard`, `sm_hardcore`
37. [[L4D] Votekick (Coop & Versus) (5.1) by alliedfront](https://forums.alliedmods.net/showthread.php?t=349341)
    - Менеджер киков с оповещением админа, которого пытаются кикнуть.
    - Зависимость: база геоданных **GeoIP2 GeoLite2**
    - `sm_vk`
38. [Bot Takeover (4.5) by little_froy](https://forums.alliedmods.net/showthread.php?t=346636)
    - Позволяет после смерти взять свободного бота, нажатием кнопки действия: `E`
39. [[ANY] Command and ConVar - Buffer Overflow Fixer (2.9) by SilverShot and Peace-Maker](https://forums.alliedmods.net/showthread.php?t=309656)
    - Фиксит ошибку `Cbuf_AddText: buffer overflow`, из-за которой сбрасываются установленные значения квар.
40. [L4D2 Black and White Notifier (2.0.2) by Lux](https://github.com/Hatsune-Imagine/l4d2-plugins/tree/main/l4d2_black_and_white_notifier)
    - Добавляет ауру ЧБ-выжившему, которая начинает пульсировать при критическом уровне здоровья.
41. [[ANY] ConVars Anomaly Fixer (1.14 beta) by Dragokas](https://forums.alliedmods.net/showthread.php?t=307804)
    - Фиксит баг на линукс-сервере с большим количеством конфигов, из-за которого переменные сбрасываются на свои дефолтные значения, не зависимо от установленных значений в конфигах.
    - Пример: у ванильного сервера одна установочная директория и много инстансов, которые ещё и на хардкорную сложность могут переключаться. Соответственно, в одной установочной директории появляется очень много конфигов, что *(на линуксе?)* приводит к *(рандомному?)* сбросу установленных значений кваров на их дефолт. Таким образом плагин **Restart Empty Server** игнорировал свой конфиг и моментально перезагружал пустой сервер, что в некоторых случаях заканчивалось крашем и некорректным сбросом карты.
    - Команды:
      - `sm_convar_anomaly_show`
      - `sm_convar_anomaly_fix`
42. [Advanced and silent CVAR change. (1.1.1) by Axel Juan Nieves](https://forums.alliedmods.net/showthread.php?p=2661102)
    - Добавляет команду `sm_acvar`, которую можно использовать вместо `sm_cvar`, чтобы скрыть изменение кваров в игровом чате для всех.
    - Используется в конфигах плагина **Vote difficulty** для *"тихой"* смены сложности
43. [Common Ragdoll Fast Extinguish (1.0) by little_froy](https://forums.alliedmods.net/showthread.php?p=2840822)
    - На зомби не отображается огонь от зажигалок, который перекрывает обзор.
44. [[L4D & L4D2] Gear Transfer (2.36) by SilverShot](https://forums.alliedmods.net/showthread.php?t=137616)
    - Опционально: плагин **Bot Healing Values**, чтобы боты передавали медикаменты только ЧБ-персонажам.
45. [Weapon Give No Auto Switch (1.13) by little_froy](https://forums.alliedmods.net/showthread.php?t=341173)
    - Второстепенная медицина не берётся автоматически в руки при передаче
46. [SendFile Exploit Fix (v3.3) (3.3) by backwards](https://forums.alliedmods.net/showthread.php?t=317120)
    - Фиксит краш [linux-gate.so!__kernel_vsyscall + 0x9](https://crash.limetech.org/jlmme6wwlhrb)
    - [Solved CSGO Server crash / linux-gate.so!__kernel_vsyscall + 0x9](https://forums.alliedmods.net/showthread.php?t=318745)
47. [[L4D & L4D2] Late Model Precacher (1.0) by Psyk0tik](https://forums.alliedmods.net/showthread.php?t=337273)
    - Фиксит краш [engine_srv.so!Sys_Error_Internal(bool, char const*, char*) + 0x129](https://crash.limetech.org/aupyujnkjow7) с ошибкой `1/ - player: UTIL_SetModel: not precached: models/survivors/survivor_gambler.mdl`
    - Связанное:
      - [Solved [L4D2] Crashes on L4D1 maps (UTIL_SetModel: not precached)](https://forums.alliedmods.net/showthread.php?t=336337)
      - [[L4D2] Model Precacher](https://forums.alliedmods.net/showthread.php?t=129990)
48. [[L4D2] Script Command Swap - Mem Leak Fix (1.0) by SilverShot (Timocop's idea)](https://forums.alliedmods.net/showthread.php?t=317128)
    - Фиксит утечки памяти из-за системы V-скриптов
49. [[L4D1 & L4D2] Weapon Prop Give Fix (1.0.3) by Mart](https://forums.alliedmods.net/showthread.php?t=331053)
    - Фиксит баг, когда взрывоопасные пропсы не детонируют от урона после их спавна.
50. [[L4D & L4D2] Engine Fix (1.1) by raziEiL [disawar1]](https://forums.alliedmods.net/showpost.php?p=2662888&postcount=35)
    - Фиксит баги:
      1. Ускоренное залезание по лестницам
      2. Отсутствие урона от падения при поднятии в полёте
      3. Буст здоровья с помощью лечения под водой
51. [[L4D/L4D2] Ladder Troll Prevention (1.3) by raziEiL [disawar1], Dosergen](https://forums.alliedmods.net/showpost.php?p=2682262&postcount=14)
    - Фиксит баг с блокированием особых на лестницах

#### Зависимости
1. [Multi Colors 2.1.2](https://github.com/Bara/Multi-Colors)
   - Общая зависимость для плагинов, которые используют цветные сообщения в игровом чате
   - Требуется для компиляции следующих плагинов:
     - **Connect Announce**
     - **Admin Force Pause**
     - **AFK and Join Team Commands Improved**
     - **VS Auto-spectate on AFK**
     - **L4L: Exec Server Config**
     - **L4L: Tools**
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
0. [SDK](https://github.com/Nodzimo/L4L-Server/tree/main/Source/L4L/left4dead2/addons/sourcemod/scripting/include/l4l)
   - Пакет зависимостей для сборки и компиляции всех плагинов L4L из этого списка
   - Содержит в себе следующие зависимости:
     1. [constants.inc](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/include/l4l/constants.inc)
     2. [lifecycle.inc](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/include/l4l/lifecycle.inc)
     3. [utils.inc](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/include/l4l/utils.inc)
1. [Exec Server Config](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_exec_server_config.sp)
   - Исполняет специфический для сервера конфиг в зависимости от квары
   - Если ранее была выбрана кастомная сложность **Impossible+**, то исполняет соответствующий ей конфиг: `server_expert+.cfg`.
   - Если установлена кастомная сложность, то выводит её название в имени сервера.
   - Если установлена кастомная сложность, то оповещает об этом игроков при подключении.
   - Зависимости:
     - Плагин **Server namer**
     - Плагин **Vote difficulty**
     - Скрипты **Multi Colors** для компиляции плагина
2. [Survivor Bots Fire Damage](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_survivor_bots_fire_damage.sp)
   - Перезаписывает урон от огня по выжившим ботам, в соответствии с установленным значением в кваре.
3. [Survivor Incap Spawn SI](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_survivor_incap_spawn_si.sp)
   - Инкап спавнит особых
   - `l4l_spawn_si`
4. [Car Alarm Spawn Tank](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_car_alarm_spawn_tank.sp)
   - Сигналка может заспавнить танка
   - Зависимость: плагин **Left 4 DHooks Direct**
   - `l4l_spawn_tank`
5. [Witch Scream Spawn Mob](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_witch_scream_spawn_mob.sp)
   - Крик ведьмы спавнит орду
6. [Survivor Death Spawn Mob](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_survivor_death_spawn_mob.sp)
   - Смерть выжившего спавнит орду и ведьму
7. [Director Spawn SI Limit](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_director_spawn_si_limit.sp)
   - Контролирует лимит особых, которых спавнит режиссёр.
   - `l4l_si_limit`
8. [Hide Kill Feed](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_hide_kill_feed.sp)
9. [Infected Drop Loot](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_infected_drop_loot.sp)
   - Танк и ведьма оставляют лут после смерти
   - Зависимость: плагин **Left 4 DHooks Direct**
10. [Upgrade Ammo Spawn Minigun](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_upgrade_ammo_spawn_minigun.sp)
    - Добавляет альтернативные режимы использования всех предметов четвёртого слота
    - Плагины-референсы:
      - **Weapon/Zombie Spawner**
      - [[L4D2] Upgrade Packs with Ammo](https://forums.alliedmods.net/showthread.php?t=322955)
11. [Tools](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_tools.sp)
    - Плагин общего назначения с набором полезных инструментов и команд
    - Референс: [[L4D2] Get mission (campaign) time and restart count stats](https://forums.alliedmods.net/showthread.php?t=351947)
    - Команды:
      - `l4l_stats`, `l4l_time`, `l4l_restarts`.
      - `l4l_crash`
      - `l4l_restart`, `l4l_wipe`, `l4l_slay`, `l4l_kill`.
    - Зависимость: скрипты **Multi Colors** для компиляции плагина

#### Хардкор
1. [L4D2 Detonation Force (1.6) by OIRV](https://forums.alliedmods.net/showthread.php?t=191247)
   - [Последний форк от BloodyBlade](https://forums.alliedmods.net/showpost.php?p=2836700&postcount=27) не компилируется и не работает, если принудительно его скомпилировать.
> [!WARNING]
> Временно используется фикс от **3ipka\***
2. [[L4D1 & L4D2] SI Doors Use (1.0.2) by Mart](https://forums.alliedmods.net/showthread.php?p=2774797)
3. [[L4D1/L4D2] AI: Hard SI (2.5-2025/8/31) by Breezy & HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/AI_HardSI)
   - Зависимости:
     - Плагин **Left 4 DHooks Direct**
     - Расширение **Actions**
4. [[L4D1/2] Explosive Cars (2.5-2024/11/11) by honorcode23, Fixed: kochiurun119, HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/l4d_explosive_cars)
   - Зависимость: плагин **Left 4 DHooks Direct**
> [!IMPORTANT]
> Используется мой форк, в котором удалено оповещение в чате о вызове орды.
5. [[L4D & L4D2] Tank Rock Bounces (1.1) by SilverShot](https://forums.alliedmods.net/showthread.php?t=343303)
   - Рикошет камней танка
   - Зависимость: плагин **Left 4 DHooks Direct**
6. **Tank rock staggering (1.5a) by 3ipka\***
7. [[L4D2] Common Infected Dynamic Jump (1.1) by BHaType](https://forums.alliedmods.net/showthread.php?t=343978)
   - Зомби прыгают как в **World War Z**
   - Зависимость: расширение **Actions**
8. [WitchSit (1.0) by pa4H](https://github.com/pa4H/L4D2-pa4H-Plugins/tree/main/L4D2-Plugins/WitchSit)
   - Ведьма успокаивается после убийства выжившего
   - Зависимость: плагин **Left 4 DHooks Direct**
> [!IMPORTANT]
> Используется мой форк, в котором добавлена квара включения плагина, чтобы использовать его на хардкорной сложности.
>
> Ведьма успокаивается не сразу, а через 15 секунд после убийства своего обидчика.
>
> Также в форке исправлены следующие краши:
>
> Винда: [engine.dll + 0x2106ad](https://crash.limetech.org/brhm6hflxzdy)
>
> Линукс: [engine_srv.so!CM_GetCollideableTriggerTestBox(ICollideable*, Vector*, Vector*, bool) + 0x90](https://crash.limetech.org/cnfnvs4w26wr)
9. [[L4D2] Stumble - Grenade Launcher (2.4) by SilverShot](https://forums.alliedmods.net/showthread.php?t=322063)
    - Граник станит заразу и выживших
10. [[L4D2] Charger Actions (1.15) by SilverShot](https://forums.alliedmods.net/showthread.php?t=309321)
    - Добавляет новые способности грому и расширяет существующие
> [!IMPORTANT]
> Используется мой форк, в котором исправлены ошибки из-за динамической смены сложности.
>
> Воспроизведение ошибок: сменить сложность на хардкор, а потом обратно на любую ванильную сложность. Или сменить сложность на хардкор, загрузить следующую карту, на новой карте сменить хардкор на любую ванильную сложность:
```
[SM] Exception reported: Game event "charger_pummel_start" has no active hook
[SM] Blaming: l4d2_charger_action.smx
[SM] Call stack trace:
[SM]   [0] UnhookEvent
[SM]   [1] Line 534, C:\Servers\L4D2\left4dead2\addons\sourcemod\scripting\l4d2_charger_action.sp::UnhookEvents
[SM]   [2] Line 401, C:\Servers\L4D2\left4dead2\addons\sourcemod\scripting\l4d2_charger_action.sp::IsAllowed
[SM]   [3] Line 356, C:\Servers\L4D2\left4dead2\addons\sourcemod\scripting\l4d2_charger_action.sp::ConVarChanged_Allow
[SM]   [5] ConVar.SetString
[SM]   [6] Line 156, /home/forums/content/files/2/5/4/6/8/0/208930.attach::changeConvar
[SM]   [7] Line 44, /home/forums/content/files/2/5/4/6/8/0/208930.attach::ACvar
[SM]   [9] ServerExecute
[SM]   [10] Line 644, Servers\dev\left4dead2\addons\sourcemod_dev\scripting\l4d_votedifficulty.sp::Handler_PostVoteAction
[SM]   [11] Line 497, Servers\dev\left4dead2\addons\sourcemod_dev\scripting\l4d_votedifficulty.sp::VoteDifficulty
[SM]   [12] Line 433, Servers\dev\left4dead2\addons\sourcemod_dev\scripting\l4d_votedifficulty.sp::MenuHandler_MenuDifficulty
```
11. [[L4D & L4D2] Tank Rock Pops Explosives (1.0) by SilverShot](https://forums.alliedmods.net/showthread.php?t=343302)
    - Взрывоопасные предметы детонируют при контакте с камнем танка
    - Зависимость: плагин **Left 4 DHooks Direct**
12. [[L4D2] Charging Charger Stagger (1.0.3) by Mart](https://forums.alliedmods.net/showthread.php?p=2763046)
    - Чарж грома оглушает рядом стоящих выживших
    - Зависимость: плагин **Left 4 DHooks Direct**
> [!IMPORTANT]
> Используется мой форк, в котором исправлены ошибки из-за динамической смены сложности.
>
> Ошибки, и их воспроизведение, такие же как в плагине **Charger Actions**:
```
[SM] Exception reported: Game event "player_bot_replace" has no active hook
[SM] Blaming: l4d2_charge_stagger.smx
[SM] Call stack trace:
[SM] [0] UnhookEvent
[SM] [1] Line 303, /home/forums/content/files/2/9/0/3/2/7/192255.attach::HookEvents
[SM] [2] Line 244, /home/forums/content/files/2/9/0/3/2/7/192255.attach::Event_ConVarChanged
```
#### Плагины для разработки, отладки и тестирования
1. [[ANY] Dev Cmds (1.52) by SilverShot](https://forums.alliedmods.net/showthread.php?t=187566)
   - Набор отладочных команд, например: перезагрузка всех плагинов, управление ботами, рестарт раунда и многое другое.
2. [[DEV] Autoreload plugins (1.16) by Alex Dragokas](https://forums.alliedmods.net/showthread.php?p=2686825)
   - Горячая перезагрузка плагина при его добавлении/компиляции/удалении
3. [All4Dead (3.9-2024/3/30) by James Richardson (grandwazir) & HarryPotter](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/all4dead2)
    - Добавляет в админку спавн оружия, предметов, зомби и запуск паник ивентов
    - Зависимости:
      - Плагин **Left 4 DHooks Direct**
      - Плагин **Manual-Spawn Special Infected**
      - Скрипты **Multi Colors** для компиляции плагина
    - Команды:
      - `!a4d_force_panic`
      - `!a4d_panic_forever`
4. [[L4D1/2] Manual-Spawn Special Infected (1.3h-2024/3/15) by Shadowysn, ProdigySim (Major Windows Fix), Harry](https://github.com/fbef0102/L4D1_2-Plugins/tree/master/spawn_infected_nolimit)
    - API для спавна особых без ограничений режиссёра
    - Зависимость: плагин **Left 4 DHooks Direct**
    - Требуется для плагина **All4Dead**
    - `!sm_mdzs`

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
  - Фиксы популярных плагинов
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
- [NanakaNeko / l4d2_plugins_coop](https://github.com/NanakaNeko/l4d2_plugins_coop)
- [pa4H / L4D2-pa4H-Plugins](https://github.com/pa4H/L4D2-pa4H-Plugins)
- [raziEiL / SourceMod](https://github.com/raziEiL/SourceMod)

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
9. [Left 4 Bots 2](https://steamcommunity.com/sharedfiles/filedetails/?id=3022416274)
    - [L4B2 commands](https://github.com/smilz0/Left4Bots/blob/main/COMMANDS.md)
    - [Настройки конфига](https://github.com/smilz0/Left4Bots/blob/main/root/scripts/vscripts/left4bots_settings.nut)
    - [Addon customization](https://steamcommunity.com/workshop/filedetails/discussion/3022416274/3825299103410056029)
    - Зависимости:
      - **Left 4 Lib**
      - **NavFixes**
10. [Left 4 Lib](https://steamcommunity.com/workshop/filedetails/?id=2634208272)
    - Требуется для **Left 4 Bots 2**
11. [NavFixes](https://steamcommunity.com/workshop/filedetails/?id=3226661388)
    - Требуется для **Left 4 Bots 2**
12. [Zero's Behavior Patches](https://steamcommunity.com/sharedfiles/filedetails/?id=3417724055)
13. [Worker Infected Boomer Bile Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3347447993)
14. [Explosive Ammo Deals Double Damage to Tank [Commission]](https://steamcommunity.com/sharedfiles/filedetails/?id=3575571984)
15. [Leg shot stumble](https://steamcommunity.com/sharedfiles/filedetails/?id=3413451176)
16. [Common Infected Gib on Shove Kill](https://steamcommunity.com/sharedfiles/filedetails/?id=3368655362)
17. [Common Infected Goomba Stomp Feedback](https://steamcommunity.com/sharedfiles/filedetails/?id=3362814416)
18. [[Improved] Headshot Feedback Effect](https://steamcommunity.com/sharedfiles/filedetails/?id=2582265366)
    - Зависимость: **Manacat Common Library** 
19. [Manacat Common Library](https://steamcommunity.com/workshop/filedetails/?id=213445426)
    - Требуется для следующих аддонов:
      - **Headshot Feedback Effect**
      - **Improved Acid Spread**
    - Опционально: аддон **Disable Manacat Weapon Skin RNG**
20. [Incendiary Ammo Triggers Car Alarm](https://steamcommunity.com/sharedfiles/filedetails/?id=3161832134)
21. [Pipe Bomb Car Alarm Bug Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3620048167)
22. [Disable Manacat Weapon Skin RNG](https://steamcommunity.com/sharedfiles/filedetails/?id=3512270023)
    - Отключает рандомные TLS-скины, зашитые в **Manacat Common Library**
    - Зависимость: аддон **Manacat Common Library**
23. [[V-Script] Smoker Antic Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3238400366)
    - Фиксит отсутствие анимации притягивания у смокера на высоком уровне сложности, из-за разницы в таймингах.
24. **Melee More Hitrays by Lombaxtard**
    - Увеличивает количество лучей у милишек
    - Включить показ лучей для теста: `sv_cheats 1; melee_show_swing 1`
25. [[Server Addon] Potential stutter fix on custom maps](https://steamcommunity.com/sharedfiles/filedetails/?id=2998356463)
    - Потенциально фиксит лаги, дёргающихся зомби и высокий пинг на некоторых кастомных картах.
> [!CAUTION]
> Проверить: кастомные карты, у которых есть соответствующее предупреждение о лагах.
26. [[Hard-Mode] Improved Acid Spread](https://steamcommunity.com/sharedfiles/filedetails/?id=3132874203)
    - Фиксит распространение кислоты на пропсах
    - Зависимость: аддон **Manacat Common Library**
27. [Revive Animation Interrupt Fix](https://steamcommunity.com/sharedfiles/filedetails/?id=3602546946)
  - Фиксит сброс анимации поднятия инкапнутого выжившего при смене оружия

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
- [Common Infected Damage](https://github.com/Nodzimo/L4L-Server/blob/main/Source/L4L/left4dead2/addons/sourcemod/scripting/l4l_common_infected_damage.sp)
   - Перезаписывает урон от ударов обычных заражённых в соответствии с установленным значением в кваре
   - Зависимость: плагин **Left 4 DHooks Direct**
> [!CAUTION]
> **Критический баг:** иногда удар зомби моментально убивает выжившего без ЧБ
>
> Точно [такой же баг происходит](https://forums.alliedmods.net/showthread.php?t=335442), если менять урон со спины нативной кварой.
- [Item giver](https://steamcommunity.com/sharedfiles/filedetails/?id=3237016899)
  - Крашит сервер: [KERNELBASE.dll!RaiseException + 0x64](https://crash.limetech.org/i23jvcx2jzb5)
  - Консоль: `CLagCompensationManager::StartLagCompensation with NULL CUserCmd!!!`
- [Lethal Chainsaw Shoves](https://steamcommunity.com/sharedfiles/filedetails/?id=3570114485)
  - **Выкидывает ошибки в рантайме!**
  - Достаточно взять пилу и отприкладить ей выжившего бота, что сразу приводит к ошибке в консоли сервера:
    ```
    AN ERROR HAS OCCURED [the index 'GetModelName' does not exist]

    CALLSTACK
    *FUNCTION [OnGameEvent_entity_shoved()] scripts/vscripts/lethal_chainsaw_shoves_geeb.nut line [9]
    *FUNCTION [__RunEventCallbacks()] unnamed line [211]
    *FUNCTION [__RunGameEventCallbacks()] unnamed line [218]

    LOCALS
    [infected] NULL
    [player] INSTANCE
    [event] TABLE
    [this] TABLE
    [funcName] "OnGameEvent_entity_shoved"
    [idx] 4
    [useTable] TABLE
    [bWarnIfMissing] true
    [globalTableName] "GameEventCallbacks"
    [prefix] "OnGameEvent_"
    [params] TABLE
    [event] "entity_shoved"
    [this] TABLE
    [params] TABLE
    [event] "entity_shoved"
    [this] TABLE
    ```
- [No Active Camera Damage VScript](https://steamcommunity.com/sharedfiles/filedetails/?id=3323149700)
   - **Выкидывает ошибки в рантайме!**
   - Пример воспроизведения: Dev-сервер, финал кампании Приход, Эксперт Реализм, инкапнуть всех ботов, спрыгнуть/улететь с моста в воду = ошибки в консоли сервера:
     ```
     AN ERROR HAS OCCURED [the index 'GetClassname' does not exist]

     CALLSTACK
     *FUNCTION [unknown()] d:/sef/l4l/l4l-server/platform/windows/servers/dev/left4dead2/addons/3323149700.vpk/scripts/vscripts/director_base_addon.nut line [23]
     *FUNCTION [__RunEventCallbacks()] unnamed line [211]
     *FUNCTION [__RunGameEventCallbacks()] unnamed line [218]
     
     LOCALS
     [p] INSTANCE
     [event] TABLE
     [this] TABLE
     [funcName] "OnGameEvent_player_hurt"
     [idx] 4
     [useTable] TABLE
     [bWarnIfMissing] true
     [globalTableName] "GameEventCallbacks"
     [prefix] "OnGameEvent_"
     [params] TABLE
     [event] "player_hurt"
     [this] TABLE
     [params] TABLE
     [event] "player_hurt"
     [this] TABLE
     ```
- [[L4D & L4D2] Incapped Weapons Patch (1.41) by SilverShot](https://forums.alliedmods.net/showthread.php?t=322859)
   - Позволяет использовать оружие и утилиты в инкапе
   - Зависимость: плагин **Left 4 DHooks Direct**
   - Рекомендуется: плагин [WeaponHandling API](https://forums.alliedmods.net/showthread.php?t=319947) для настройки скорострельности оружия в инкапе
   - `sm_incap`
> [!CAUTION]
> **Критический баг:** игрок *"застревает"* после поднятия инкапнутого, оставаясь с видом от третьего лица без возможности передвигаться.
>
> Также выбрасывает ошибки в рантайме:
```
[SM] Exception reported: Game event "revive_success" has no active hook
[SM] Blaming: l4d_incapped_weapons.smx
[SM] Call stack trace:
[SM]   [0] UnhookEvent
[SM]   [1] Line 918, C:\Servers\L4D2\left4dead2\addons\sourcemod\scripting\l4d_incapped_weapons.sp::UnhookEvents
[SM]   [2] Line 836, C:\Servers\L4D2\left4dead2\addons\sourcemod\scripting\l4d_incapped_weapons.sp::IsAllowed
[SM]   [3] Line 753, C:\Servers\L4D2\left4dead2\addons\sourcemod\scripting\l4d_incapped_weapons.sp::ConVarChanged_Allow
[SM]   [5] ConVar.SetString
[SM]   [6] Line 156, /home/forums/content/files/2/5/4/6/8/0/208930.attach::changeConvar
[SM]   [7] Line 44, /home/forums/content/files/2/5/4/6/8/0/208930.attach::ACvar
[SM]   [9] ServerExecute
[SM]   [10] Line 642, Servers\dev\left4dead2\addons\sourcemod_dev\scripting\l4d_votedifficulty.sp::Handler_PostVoteAction
[SM]   [11] Line 495, Servers\dev\left4dead2\addons\sourcemod_dev\scripting\l4d_votedifficulty.sp::VoteDifficulty
[SM]   [12] Line 431, Servers\dev\left4dead2\addons\sourcemod_dev\scripting\l4d_votedifficulty.sp::MenuHandler_MenuDifficulty
```

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
> [!CAUTION]
> Финал лагает: у игроков скачет пинг, зомби дёргаются
3. [No Mercy Christmas Edition (Part 2)](https://steamcommunity.com/sharedfiles/filedetails/?id=3101550309)
> [!CAUTION]
> Вторая карта лагает: у игроков скачет пинг, зомби дёргаются
4. [Deadly New Year](https://steamcommunity.com/sharedfiles/filedetails/?id=3404576339)
5. [Ice Canyon](https://steamcommunity.com/sharedfiles/filedetails/?id=3634176047)

#### Тестовые
[Коллекция в мастерской](https://steamcommunity.com/sharedfiles/filedetails/?id=3622049670)

1. [Whitaker's Weapons Range by danfs0 [RE-UPLOAD]](https://steamcommunity.com/sharedfiles/filedetails/?id=3001153036)
2. [The Ultimate Mod Testing and Reviewing Area - Main Files](https://steamcommunity.com/sharedfiles/filedetails/?id=469986973)

### Краши
- `ED_Alloc: no free edicts`
  - [Solved [Help] L4D2 Linux server always auto crashed](https://forums.alliedmods.net/showthread.php?t=332505)
- [server_srv.so!CTerrorWeaponInfo::Reload() + 0x44](https://crash.limetech.org/g2mocvxlgujt)
  - [[L4D & L4D2] Mission and Weapons - Info Editor (1.27) [04-Jan-2026]](https://forums.alliedmods.net/showthread.php?t=310586&page=7)

### Баги
- После рестарта все мертвы или появляются "под землёй"
  - Демонстрация бага и варианта как из него выбраться админу (YouTube):
    - [![Как выбраться из бага под землёй в Left 4 Dead 2](https://img.youtube.com/vi/EtwajuX5iLo/0.jpg)](https://www.youtube.com/watch?v=EtwajuX5iLo)
  - Связанное:
    - [[L4D2] Transition Info Fix](https://forums.alliedmods.net/showthread.php?t=335117)
    - [[L4D2] Proper Changelevel [Left 4 Fix] [17/11/2019]](https://forums.alliedmods.net/showthread.php?t=319156&page=3)
    - [[L4D2] Server Event/Trigger issues](https://forums.alliedmods.net/showthread.php?t=329838)
    - [[L4D1 & L4D2] Map changer with rating system](https://forums.alliedmods.net/showthread.php?t=311161&page=10)
    - [[L4D2] Level change causing spawning issues](https://forums.alliedmods.net/showthread.php?t=328881)
    - [Solved [L4D] How to force mission lost](https://forums.alliedmods.net/showthread.php?t=311472)

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