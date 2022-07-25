

dir kits {
	function summon {
		execute align xyz positioned ~.5 ~.5 ~.5 run {
			summon marker ~ ~ ~ {Tags:['shop.kits']}
			setblock ~ ~ ~ minecraft:dropper[facing=down]{CustomName:'{"text":"Kits Shop"}'}
		}
	}
	clock 1t {
		execute as @e[type=marker,tag=shop.kits] at @s run {
			particle dust 0 1 0 1 ~ ~1 ~ 0 -10 0 1 0 force
			(
				data modify block ~ ~ ~ Items set value [
					{Slot:0b,Count:1b,id:"minecraft:player_head",tag:{display:{
						Name:'{"text":"Chambeeion","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Melee class","color":"light_purple","italic":false}',
							'{"text":"May your sword be deft and your feet be swift!","color":"gray"}',
							'{"text":"Swap cost: 10 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;-735900145,14437401,-1319116123,275528342],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjU5MDAxYTg1MWJiMWI5ZTljMDVkZTVkNWM2OGIxZWEwZGM4YmQ4NmJhYmYxODhlMGFkZWQ4ZjkxMmMwN2QwZCJ9fX0="}]}},HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}},
					{Slot:2b,Count:1b,id:"minecraft:player_head",tag:{display:{
						Name:'{"text":"Stinger","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Ranged class","color":"light_purple","italic":false}',
							'{"text":"Your enemies will fear your mighty sting!","color":"gray"}',
							'{"text":"Swap cost: 20 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;789233355,1073172373,-1074853238,-1157748363],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWYxNjZhNGNlMTJkMzg2MTFhY2UxMmM0ZjA2N2JlNWVkMDg4ZDhhYjkwYjYwZGJmOTNkMzFhNjg0ZmM3NGI5YiJ9fX0="}]}}}},
					{Slot:6b,Count:1b,id:"minecraft:player_head",tag:{display:{
						Name:'{"text":"Beefender","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Tank class.","color":"light_purple","italic":false}',
							'{"text":"Defend the queen with your mighty shield!","color":"gray"}',
							'{"text":"Swap cost: 30 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;-589329274,40059932,-1869592779,2079190347],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWQ1N2RlODdlZjhhMTcxNmIwYWJiZTAxMzU5YTI3YWVhODUxMmZjNTdjMWFhZTcwZGVlNWUxNWY2ZDFmOWRmZCJ9fX0="}]}}}},
					{Slot:8b,Count:1b,id:"minecraft:player_head",tag:{display:{
						Name:'{"text":"Pollenator","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Support class","color":"light_purple","italic":false}',
							'{"text":"Protect your allies and hinder your enemies!","color":"gray"}',
							'{"text":"Swap cost: 20 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;1180968631,-624473113,-1335985717,-1690048513],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjY4NTdlOTg3NmEzNjQ0ZGViYmYxZmQ3MzQ1YTQ4Zjk5OTcwNWUwYTk5M2ExMzA0OTI4ZmQwNmMxYjNmMWY5NCJ9fX0="}]}}}}
				]
			)
		}
	}
}

