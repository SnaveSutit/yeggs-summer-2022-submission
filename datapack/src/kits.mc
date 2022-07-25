
function pollenator {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Pollenator\"}"},SkullOwner:{Id:[I;-735900145,14437401,-1319116123,275528342],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjU5MDAxYTg1MWJiMWI5ZTljMDVkZTVkNWM2OGIxZWEwZGM4YmQ4NmJhYmYxODhlMGFkZWQ4ZjkxMmMwN2QwZCJ9fX0="}]}},HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.legs with minecraft:iron_leggings{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.feet with minecraft:iron_boots{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}

	item replace entity @s hotbar.0 with minecraft:iron_sword{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s hotbar.1 with minecraft:cooked_beef 20
	item replace entity @s hotbar.7 with minecraft:splash_potion{id:"minecraft:splash_potion",Potion:"minecraft:healing"}
	item replace entity @s hotbar.8 with minecraft:splash_potion{id:"minecraft:splash_potion",Potion:"minecraft:healing"}
}

function stinger {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Stinger\"}"},SkullOwner:{Id:[I;-735900145,14437401,-1319116123,275528342],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjU5MDAxYTg1MWJiMWI5ZTljMDVkZTVkNWM2OGIxZWEwZGM4YmQ4NmJhYmYxODhlMGFkZWQ4ZjkxMmMwN2QwZCJ9fX0="}]}},HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.legs with minecraft:chainmail_leggings{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.feet with minecraft:chainmail_boots{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}

	item replace entity @s hotbar.0 with minecraft:stone_sword{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s hotbar.1 with minecraft:bow{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:infinity",lvl:1s},{id:"minecraft:knockback",lvl:1s}]}
	item replace entity @s inventory.0 with minecraft:arrow 1
	item replace entity @s hotbar.8 with minecraft:cooked_beef 20
}

function beefy {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Beefy\"}"},SkullOwner:{Id:[I;-735900145,14437401,-1319116123,275528342],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjU5MDAxYTg1MWJiMWI5ZTljMDVkZTVkNWM2OGIxZWEwZGM4YmQ4NmJhYmYxODhlMGFkZWQ4ZjkxMmMwN2QwZCJ9fX0="}]}},HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.legs with minecraft:chainmail_leggings{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.feet with minecraft:chainmail_boots{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}

	item replace entity @s hotbar.0 with minecraft:stone_sword{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s hotbar.1 with minecraft:bow{HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:infinity",lvl:1s},{id:"minecraft:knockback",lvl:1s}]}
	item replace entity @s inventory.0 with minecraft:arrow 1
	item replace entity @s hotbar.8 with minecraft:cooked_beef 20
}
