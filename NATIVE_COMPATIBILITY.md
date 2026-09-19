# Native framework inventory compatibility

W keeps its existing UI. Framework detection and shared utilities continue to run through w_lib.

## Authoritative data

* VORP: item definitions from items; item instances from character_inventories/items_crafted; weapons from loadout; gunbelt ammunition from characters.ammo. The W table stores layout, not a duplicate player inventory.
* RSG: definitions from rsg-core Shared.Items/Shared.Weapons. Player persistence uses players.inventory with name/amount/info/type/slot. Stashes use inventories.identifier/items.
* Currency is read from the current character/core. Its inventory representation is not serialized as an ordinary native item.
* RSG uses rsg-weapons for equip, unequip, GUIDs, weapon quality and weapon components. Keep its normal ammo/component dependencies enabled.
* VORP item callbacks, native IDs, clip ammo maps and component categories are translated by the compatibility API. W's weapon implementation remains the client engine for VORP.
* Confiscation/return commit the native player and custody store together. Returning merges with items acquired since confiscation; core cash and gunbelt accounts stay with the character.
* VORP horse storage, evidence, drops and temporary containers retain native instance IDs across transfers.
* Existing W-only JSON inventories are not automatically merged into native storage. The requested native tables are authoritative; no import command or resource restart is needed to build the item catalog.

## Activation

Keep exactly one inventory provider enabled.

VORP order: oxmysql, vorp_core, w_lib, w_inventory, then consumers such as w_wheel.
Replace the vorp_inventory ensure with w_inventory. Do not run both bags.
RSG order: oxmysql, rsg-core, w_lib, w_inventory, then rsg-weapons and its configured native dependencies/consumers.
Do not disable rsg-weapons when replacing rsg-inventory.

The inventory:framework default is auto. w_lib is queried first. Explicit framework overrides remain available for installations with multiple cores.

The w_lib core/framework/server.lua change belongs with this update. Its offline operations now use the inventory's native persistence API. Offline writes refuse a character that is online/loading and release their lock on errors.

## Settings and reference versions

When the original VORP resource is available, its weapon definitions, gunbelt limits and gameplay capacity settings are read. Bundled weapon/ammo fallbacks come from the locally installed VORP resource. This does not load its UI.
RSG adapters were checked against official Rexshack-RedM sources:
- rsg-core 828fffa88bff950f41aa2065ebef47b08ddb4e55
- rsg-inventory 15887771626ed3dcb98107f073c3a7028693a188
- rsg-weapons 4046511c6ac43fe1c7544c875135d671edabefa2

## Validation and limits

Automated tests cover native catalog replacement, metadata round trips, gunbelt/clip persistence, instance IDs, split/move/drop/pickup, rollback, concurrent slot replacement, character cash initialization, RSG twin GUID selection, Use/Unuse and offline edits. Tests use SQLite in memory and mocked RedM boundaries; they do not connect to a live server database.

The installed oxmysql startTransaction/query result contract was inspected. Lua parsing uses normalization for Cfx extensions before Lua 5.4 parsing.

Live RedM testing is still required on VORP and RSG: character selection/spawn, reconnect, item consumption, gunbelt refill, two identical pistols, reload/fire/unuse, stash transfer, and return to the original native bag. No claim of parity with every third-party extension or other framework is made by these isolated tests.

This file deployment does not change server.cfg, restart resources, run SQL against the live database, or modify the web/UI assets.
