
function chambeeion {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Chambeeion\"}"},SkullOwner:{Id:[I;-735900145,14437401,-1319116123,275528342],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjU5MDAxYTg1MWJiMWI5ZTljMDVkZTVkNWM2OGIxZWEwZGM4YmQ4NmJhYmYxODhlMGFkZWQ4ZjkxMmMwN2QwZCJ9fX0="}]}},HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}],display:{color:16772608},AttributeModifiers:[{AttributeName:"generic.movement_speed",Name:"generic.movement_speed",Amount:0.01,Operation:0,UUID:[I;271263282,1400652759,-1615410207,238669607]}]}
	item replace entity @s armor.legs with minecraft:iron_leggings{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.feet with minecraft:iron_boots{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}

	item replace entity @s hotbar.0 with minecraft:iron_sword{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s hotbar.8 with minecraft:cooked_beef 20
	item replace entity @s hotbar.6 with minecraft:splash_potion{id:"minecraft:splash_potion",Potion:"minecraft:healing"}
	item replace entity @s hotbar.7 with minecraft:splash_potion{id:"minecraft:splash_potion",Potion:"minecraft:healing"}

	tag @s add chambeeion
	tag @s remove stinger
	tag @s remove beefender
	tag @s remove pollenator
}

function stinger {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Stinger\"}"},SkullOwner:{Id:[I;789233355,1073172373,-1074853238,-1157748363],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWYxNjZhNGNlMTJkMzg2MTFhY2UxMmM0ZjA2N2JlNWVkMDg4ZDhhYjkwYjYwZGJmOTNkMzFhNjg0ZmM3NGI5YiJ9fX0="}]}}}
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}],display:{color:16772608},AttributeModifiers:[{AttributeName:"generic.movement_speed",Name:"generic.movement_speed",Amount:0.02,Operation:0,UUID:[I;271263282,1400652759,-1615410207,238669607]}]}
	item replace entity @s armor.legs with minecraft:chainmail_leggings{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.feet with minecraft:chainmail_boots{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}

	item replace entity @s hotbar.0 with minecraft:stone_sword{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s hotbar.1 with minecraft:bow{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:infinity",lvl:1s},{id:"minecraft:knockback",lvl:2s}]}
	item replace entity @s inventory.0 with minecraft:arrow 1
	item replace entity @s hotbar.8 with minecraft:cooked_beef 20

	tag @s add stinger
	tag @s remove chambeeion
	tag @s remove beefender
	tag @s remove pollenator
}

function beefender {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Beefender\"}"},SkullOwner:{Id:[I;-589329274,40059932,-1869592779,2079190347],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWQ1N2RlODdlZjhhMTcxNmIwYWJiZTAxMzU5YTI3YWVhODUxMmZjNTdjMWFhZTcwZGVlNWUxNWY2ZDFmOWRmZCJ9fX0="}]}}} 1
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}],display:{color:16772608},AttributeModifiers:[{AttributeName:"generic.knockback_resistance",Name:"generic.knockback_resistance",Amount:0.4,Operation:0,UUID:[I;-1236903513,-1861794081,-2043555930,131202994]},{AttributeName:"generic.movement_speed",Name:"generic.movement_speed",Amount:-0.02,Operation:0,UUID:[I;1300714477,962021073,-1281052269,-224552770]}]}
	item replace entity @s armor.legs with minecraft:diamond_leggings{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s armor.feet with minecraft:diamond_boots{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}

	item replace entity @s hotbar.0 with minecraft:stone_sword{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:sweeping",lvl:3s}]}
	item replace entity @s hotbar.1 with minecraft:shield{HideFlags:126,Unbreakable:1b}
	item replace entity @s hotbar.7 with minecraft:golden_apple 2
	item replace entity @s hotbar.8 with minecraft:cooked_beef 20

	tag @s add beefender
	tag @s remove chambeeion
	tag @s remove stinger
	tag @s remove pollenator
}

function pollenator {
	clear @s
	item replace entity @s armor.head with minecraft:player_head{display:{Name:"{\"text\":\"Pollenator\"}"},SkullOwner:{Id:[I;1180968631,-624473113,-1335985717,-1690048513],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjY4NTdlOTg3NmEzNjQ0ZGViYmYxZmQ3MzQ1YTQ4Zjk5OTcwNWUwYTk5M2ExMzA0OTI4ZmQwNmMxYjNmMWY5NCJ9fX0="}]}}} 1
	item replace entity @s armor.chest with minecraft:leather_chestplate{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}],display:{color:16772608}}
	item replace entity @s armor.legs with minecraft:leather_leggings{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}],display:{color:3022848}}
	item replace entity @s armor.feet with minecraft:leather_boots{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}],display:{color:16772608}}

	item replace entity @s hotbar.0 with minecraft:stone_axe{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}
	item replace entity @s hotbar.1 with minecraft:crossbow{HideFlags:126,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:piercing",lvl:1s},{id:"minecraft:quick_charge",lvl:1s}]}
	item replace entity @s inventory.0 with minecraft:tipped_arrow{Potion:"minecraft:slow_falling"} 4
	item replace entity @s inventory.1 with minecraft:spectral_arrow 4
	item replace entity @s inventory.2 with minecraft:tipped_arrow{Potion:"minecraft:weakness"} 8
	item replace entity @s inventory.3 with minecraft:arrow 8

	item replace entity @s hotbar.5 with minecraft:lingering_potion{Potion:"minecraft:turtle_master"} 1
	item replace entity @s hotbar.6 with minecraft:splash_potion{Potion:"minecraft:strong_regeneration"} 1
	item replace entity @s hotbar.7 with minecraft:splash_potion{Potion:"minecraft:strong_healing"} 1
	item replace entity @s hotbar.8 with minecraft:cooked_beef 20

	tag @s add pollenator
	tag @s remove chambeeion
	tag @s remove stinger
	tag @s remove beefender
}

function remove_tags {
	tag @s remove chambeeion
	tag @s remove stinger
	tag @s remove beefender
	tag @s remove pollenator
}