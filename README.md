# w_inventory

Server-authoritative slot-and-metadata inventory, weapons, stashes, crafting, and built-in shops for **Wraith Framework RedM**.

## Key Features

- **Slots & Metadata:** Full item metadata, durability, weight limits, stacking, drops, and bilingual item definitions (`data/items.lua`).
- **Weapons & Ammo:** Weapon serialization, attachments/components, ammo tracking, and native RedM weapon wheel integration.
- **Stashes & Hooks:** Persistent database stashes, temporary stashes, and `registerHook` interception for custom validation.
- **Built-In Shops:** Static shops (`data/shops.lua`), dynamic runtime shops (`exports.w_inventory:RegisterShop`), Police Armory, Medical Supplies, and optional built-in General Stores across major RDR2 towns.
- **Compatibility:** Provides drop-in bridges for `rsg-inventory`, `vorp_inventory`, and `qbr-inventory`.

## Installation

1. Ensure `oxmysql`, `w_lib`, and `w_core` start before `w_inventory`.
2. Add `ensure w_inventory` to `server.cfg`.
3. Optional — enable the built-in General Stores in `server.cfg`:
   ```cfg
   setr w_inventory:defaultShops 1
   ```

## Server Exports Example

```lua
if exports.w_inventory:CanCarryItem(source, 'bandage', 2) then
    exports.w_inventory:AddItem(source, 'bandage', 2)
end

exports.w_inventory:RegisterShop('custom_shop', {
    name = 'Frontier Supplies',
    inventory = {
        { name = 'rdr_water_flask', price = 2 },
        { name = 'consumable_bread_roll', price = 2 },
    },
})
```

## Documentation & Links

- **Developer Docs:** https://wraith-core.github.io/docs/#/core/w_inventory
- **txAdmin Recipe:** https://github.com/Wraith-Core/txAdminRecipe
