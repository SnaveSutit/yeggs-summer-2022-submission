
clock 5t {
	execute as @e[type=item] if data entity @s {Item:{tag:{shop_item:1b}}} run kill @s
}
dir kits {
	function summon {
		execute align xyz positioned ~.5 ~.5 ~.5 run {
			summon marker ~ ~ ~ {Tags:['shop.kits']}
			summon area_effect_cloud ~ ~.5 ~ {Tags:['shop.upgrades'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"🗡 Kits 🏹","color":"gold"}',CustomNameVisible:1b}
			setblock ~ ~ ~ minecraft:dropper[facing=down]{CustomName:'{"text":"Kits Shop"}'}
		}
	}
	function kick_player {
		data modify block ~ ~ ~ Items set value []
		setblock ~ ~ ~ air
		setblock ~ ~ ~ minecraft:dropper[facing=down]{CustomName:'{"text":"Kits Shop"}'}
	}
	clock 3t {
		execute as @e[type=marker,tag=shop.kits] at @s run {
			# particle dust 0 1 0 1 ~ ~1 ~ 0 -10 0 1 0 force
			(
				data modify block ~ ~ ~ Items set value [
					{Slot:0b,Count:1b,id:"minecraft:player_head",tag:{shop_item:1b,kits_shop:1b,chambeeion_class:1b,display:{
						Name:'{"text":"Chambeeion","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Melee class","color":"light_purple","italic":false}',
							'{"text":"May your sword be deft and your feet be swift!","color":"gray"}',
							'{"text":"Swap cost: 0 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;-735900145,14437401,-1319116123,275528342],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjU5MDAxYTg1MWJiMWI5ZTljMDVkZTVkNWM2OGIxZWEwZGM4YmQ4NmJhYmYxODhlMGFkZWQ4ZjkxMmMwN2QwZCJ9fX0="}]}},HideFlags:127,Unbreakable:1b,Enchantments:[{id:"minecraft:binding_curse",lvl:1s}]}},
					{Slot:2b,Count:1b,id:"minecraft:player_head",tag:{shop_item:1b,kits_shop:1b,stinger_class:1b,display:{
						Name:'{"text":"Stinger","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Ranged class","color":"light_purple","italic":false}',
							'{"text":"Your enemies will fear your mighty sting!","color":"gray"}',
							'{"text":"Swap cost: 20 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;789233355,1073172373,-1074853238,-1157748363],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWYxNjZhNGNlMTJkMzg2MTFhY2UxMmM0ZjA2N2JlNWVkMDg4ZDhhYjkwYjYwZGJmOTNkMzFhNjg0ZmM3NGI5YiJ9fX0="}]}}}},
					{Slot:6b,Count:1b,id:"minecraft:player_head",tag:{shop_item:1b,kits_shop:1b,beefender_class:1b,display:{
						Name:'{"text":"Beefender","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Tank class","color":"light_purple","italic":false}',
							'{"text":"Defend the queen with your mighty shield!","color":"gray"}',
							'{"text":"Swap cost: 20 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;-589329274,40059932,-1869592779,2079190347],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWQ1N2RlODdlZjhhMTcxNmIwYWJiZTAxMzU5YTI3YWVhODUxMmZjNTdjMWFhZTcwZGVlNWUxNWY2ZDFmOWRmZCJ9fX0="}]}}}},
					{Slot:8b,Count:1b,id:"minecraft:player_head",tag:{shop_item:1b,kits_shop:1b,pollenator_class:1b,display:{
						Name:'{"text":"Pollenator","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Support class","color":"light_purple","italic":false}',
							'{"text":"Protect your allies and hinder your enemies!","color":"gray"}',
							'{"text":"Swap cost: 20 Honey","color":"gold","italic":false}'
							]
						},SkullOwner:{Id:[I;1180968631,-624473113,-1335985717,-1690048513],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYjY4NTdlOTg3NmEzNjQ0ZGViYmYxZmQ3MzQ1YTQ4Zjk5OTcwNWUwYTk5M2ExMzA0OTI4ZmQwNmMxYjNmMWY5NCJ9fX0="}]}}}}
				]
			)

			execute as @a[distance=..8] run {
				execute store success score #success v run clear @s #items:all{kits_shop:1b} 0
				execute if score #success v matches 1 run {
					execute store success score #chambeeion_class v run clear @s #items:all{chambeeion_class:1b} 0
					execute store success score #stinger_class v run clear @s #items:all{stinger_class:1b} 0
					execute store success score #beefender_class v run clear @s #items:all{beefender_class:1b} 0
					execute store success score #pollenator_class v run clear @s #items:all{pollenator_class:1b} 0
					LOOP(['a','b'],team){
						execute if entity @s[team=<%team%>] run {
							scoreboard players set #purchase_success v 0
							execute if score #chambeeion_class v matches 1 run {
								function kits:chambeeion
								scoreboard players set #purchase_success v 1
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},{"text":" swapped to the chambeeion class.","color":"green"}]
							}
							execute if score #stinger_class v matches 1 if score .team_<%team%> honey matches 20.. run {
								function kits:stinger
								scoreboard players remove .team_<%team%> honey 20
								scoreboard players set #purchase_success v 1
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},{"text":" swapped to the stinger class for 20 honey.","color":"green"}]
							}
							execute if score #beefender_class v matches 1 if score .team_<%team%> honey matches 20.. run {
								function kits:beefender
								scoreboard players remove .team_<%team%> honey 20
								scoreboard players set #purchase_success v 1
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},{"text":" swapped to the beefender class for 30 honey.","color":"green"}]
							}
							execute if score #pollenator_class v matches 1 if score .team_<%team%> honey matches 20.. run {
								function kits:pollenator
								scoreboard players remove .team_<%team%> honey 20
								scoreboard players set #purchase_success v 1
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},{"text":" swapped to the pollenator class for 20 honey.","color":"green"}]
							}
							execute if score #purchase_success v matches 0 run {
								tellraw @s [{"text":"You don't have enough honey to purchase this kit!","color":"red"}]
								playsound minecraft:entity.villager.no player @s ~ ~ ~ 1 1
							}
							execute if score #purchase_success v matches 1 run {
								function shops:kits/kick_player
								playsound minecraft:entity.villager.yes player @s ~ ~ ~ 1 1
							}
						}
					}
				}
				clear @s #items:all{kits_shop:1b}
			}
		}
	}
}


dir upgrades {
	function summon {
		execute align xyz positioned ~.5 ~.5 ~.5 run {
			summon marker ~ ~ ~ {Tags:['shop.upgrades']}
			summon area_effect_cloud ~ ~.5 ~ {Tags:['shop.upgrades'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"↑ Upgrades 🧪","color":"green"}',CustomNameVisible:1b}
			setblock ~ ~ ~ minecraft:dropper[facing=down]{CustomName:'{"text":"Upgrade Shop"}'}
		}
	}
	function kick_player {
		data modify block ~ ~ ~ Items set value []
		setblock ~ ~ ~ air
		setblock ~ ~ ~ minecraft:dropper[facing=down]{CustomName:'{"text":"Upgrade Shop"}'}
	}
	clock 3t {
		execute as @e[type=marker,tag=shop.upgrades] at @s run {
			# particle dust 0 1 0 1 ~ ~1 ~ 0 -10 0 1 0 force
			(
				data modify block ~ ~ ~ Items set value [
					{Slot:0b,Count:1b,id:"minecraft:bucket",tag:{shop_item:1b,upgrades_shop:1b,capacity_upgrade:1b,display:{
						Name:'{"text":"Upgrade Resource Capacity","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Increases the resource","color":"gray"}',
							'{"text":"storage capacity of your hive","color":"gray"}',
							'""'
						]
					}}},
					{Slot:1b,Count:1b,id:"minecraft:redstone",tag:{shop_item:1b,upgrades_shop:1b,gen_speed_upgrade:1b,display:{
						Name:'{"text":"Upgrade Generator Speed","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Increases the speed at which your","color":"gray"}',
							'{"text":"captured generators produce resources","color":"gray"}',
							'""'
						]
					}}},
					{Slot:2b,Count:1b,id:"minecraft:beehive",tag:{shop_item:1b,upgrades_shop:1b,bee_capacity_upgrade:1b,display:{
						Name:'{"text":"Upgrade Bee Capacity","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Increases the maximum number of","color":"gray"}',
							'{"text":"Drones you can command","color":"gray"}',
							'""'
						]
					}}},
					{Slot:3b,Count:1b,id:"minecraft:diamond",tag:{shop_item:1b,upgrades_shop:1b,new_drone:1b,display:{
						Name:'{"text":"Build new Drone","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Spawns a new Drone to automatically","color":"gray"}',
							'{"text":"harvest resources for you!","color":"gray"}',
							'""'
						]
					}}},
					{Slot:4b,Count:1b,id:"minecraft:diamond",tag:{shop_item:1b,upgrades_shop:1b,new_soldier:1b,display:{
						Name:'{"text":"Build new Soldier","color":"yellow","italic":false}',
						Lore:[
							'{"text":"Adds a new Soldier to your swarm.","color":"gray"}',
							'{"text":"Build up a big enough swarm","color":"red"}',
							'{"text":"to attack the enemy hive!","color":"red"}',
							'""'
						]
					}}},
				]
			)
			LOOP(['a','b'],team){
				execute as @p[distance=..8] if entity @s[team=<%team%>] run {
					item modify block ~ ~ ~ container.0 shops:upgrades/capacity_upgrade_<%team%>
					item modify block ~ ~ ~ container.1 shops:upgrades/gen_speed_upgrade_<%team%>
					item modify block ~ ~ ~ container.2 shops:upgrades/bee_capacity_upgrade_<%team%>
					item modify block ~ ~ ~ container.3 shops:upgrades/new_drone_<%team%>
					item modify block ~ ~ ~ container.4 shops:upgrades/new_soldier_<%team%>
				}
			}

			execute as @a[distance=..8] run {
				execute store success score #success v run clear @s #items:all{upgrades_shop:1b} 0
				execute if score #success v matches 1 run {
					execute store success score #capacity_upgrade v run clear @s #items:all{capacity_upgrade:1b} 0
					execute store success score #gen_speed_upgrade v run clear @s #items:all{gen_speed_upgrade:1b} 0
					execute store success score #bee_capacity_upgrade v run clear @s #items:all{bee_capacity_upgrade:1b} 0
					execute store success score #new_drone v run clear @s #items:all{new_drone:1b} 0
					execute store success score #new_soldier v run clear @s #items:all{new_soldier:1b} 0
					LOOP(['a','b'],team){
						execute if entity @s[team=<%team%>] run {
							scoreboard players set #purchase_success v 0

							execute if score #capacity_upgrade v matches 1 if score .team_<%team%> honey >= #<%team%>.hive.max_resources.honey_cost v if score .team_<%team%> wax >= #<%team%>.hive.max_resources.wax_cost v run {
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},[{"text":" Purchased the ","color":"green"},{"text":"Resource Capacity Upgrade","color":"gold"}," for ",{"score": {"name": "#<%team%>.hive.max_resources.honey_cost","objective": "v"},"color":"yellow"},{"text":" Honey","color":"yellow"},{"text":" and "},{"score": {"name": "#<%team%>.hive.max_resources.wax_cost","objective": "v"},"color":"yellow"},{"text":" Wax","color":"yellow"}]]

								scoreboard players operation .team_<%team%> honey -= #<%team%>.hive.max_resources.honey_cost v
								scoreboard players operation .team_<%team%> wax -= #<%team%>.hive.max_resources.wax_cost v

								scoreboard players operation #<%team%>.hive.max_honey v *= #<%team%>.hive.max_resources.increase_multiplier v
								scoreboard players operation #<%team%>.hive.max_wax v *= #<%team%>.hive.max_resources.increase_multiplier v
								scoreboard players operation #<%team%>.hive.max_honey v /= 1000 v
								scoreboard players operation #<%team%>.hive.max_wax v /= 1000 v

								scoreboard players operation #<%team%>.hive.max_resources.honey_cost v *= #<%team%>.hive.max_resources.cost_multiplier v
								scoreboard players operation #<%team%>.hive.max_resources.wax_cost v *= #<%team%>.hive.max_resources.cost_multiplier v
								scoreboard players operation #<%team%>.hive.max_resources.honey_cost v /= 1000 v
								scoreboard players operation #<%team%>.hive.max_resources.wax_cost v /= 1000 v

								scoreboard players set #purchase_success v 1
							}

							execute if score #gen_speed_upgrade v matches 1 if score .team_<%team%> honey >= #<%team%>.gen_speed.honey_cost v if score .team_<%team%> wax >= #<%team%>.gen_speed.wax_cost v run {
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},[{"text":" Purchased the ","color":"green"},{"text":"Generator Speed Upgrade","color":"gold"}," for ",{"score": {"name": "#<%team%>.gen_speed.honey_cost","objective": "v"},"color":"yellow"},{"text":" Honey","color":"yellow"},{"text":" and "},{"score": {"name": "#<%team%>.gen_speed.wax_cost","objective": "v"},"color":"yellow"},{"text":" Wax","color":"yellow"}]]
								scoreboard players operation .team_<%team%> honey -= #<%team%>.gen_speed.honey_cost v
								scoreboard players operation .team_<%team%> wax -= #<%team%>.gen_speed.wax_cost v

								scoreboard players operation #<%team%>.pollen_gen.speed v *= #<%team%>.gen_speed.increase_multiplier v
								scoreboard players operation #<%team%>.wax_gen.speed v *= #<%team%>.gen_speed.increase_multiplier v
								scoreboard players operation #<%team%>.pollen_gen.speed v /= 1000 v
								scoreboard players operation #<%team%>.wax_gen.speed v /= 1000 v

								scoreboard players operation #<%team%>.gen_speed.honey_cost v *= #<%team%>.gen_speed.cost_multiplier v
								scoreboard players operation #<%team%>.gen_speed.wax_cost v *= #<%team%>.gen_speed.cost_multiplier v
								scoreboard players operation #<%team%>.gen_speed.honey_cost v /= 1000 v
								scoreboard players operation #<%team%>.gen_speed.wax_cost v /= 1000 v

								scoreboard players set #purchase_success v 1
							}

							execute if score #bee_capacity_upgrade v matches 1 if score .team_<%team%> honey >= #<%team%>.hive.max_bees.honey_cost v if score .team_<%team%> wax >= #<%team%>.hive.max_bees.wax_cost v run {
								tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},[{"text":" Purchased the ","color":"green"},{"text":"Bee Capacity Upgrade","color":"gold"}," for ",{"score": {"name": "#<%team%>.hive.max_bees.honey_cost","objective": "v"},"color":"yellow"},{"text":" Honey","color":"yellow"},{"text":" and "},{"score": {"name": "#<%team%>.hive.max_bees.wax_cost","objective": "v"},"color":"yellow"},{"text":" Wax","color":"yellow"}]]
								scoreboard players operation .team_<%team%> honey -= #<%team%>.hive.max_bees.honey_cost v
								scoreboard players operation .team_<%team%> wax -= #<%team%>.hive.max_bees.wax_cost v

								scoreboard players operation #<%team%>.hive.max_bees v *= #<%team%>.hive.max_bees.increase_multiplier v
								scoreboard players operation #<%team%>.hive.max_bees v /= 1000 v

								scoreboard players operation #<%team%>.hive.max_bees.honey_cost v *= #<%team%>.hive.max_bees.cost_multiplier v
								scoreboard players operation #<%team%>.hive.max_bees.wax_cost v *= #<%team%>.hive.max_bees.cost_multiplier v
								scoreboard players operation #<%team%>.hive.max_bees.honey_cost v /= 1000 v
								scoreboard players operation #<%team%>.hive.max_bees.wax_cost v /= 1000 v

								scoreboard players set #purchase_success v 1
							}

							execute if score #new_drone v matches 1 if score .team_<%team%> honey >= #<%team%>.new_drone.honey_cost v run {

								execute (if score .team_<%team%> drones >= #<%team%>.hive.max_bees v) {
									scoreboard players set #purchase_success v 3
								} else {
									tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},[{"text":" Purchased a ","color":"green"},{"text":"Drone","color":"gold"}," for ",{"score": {"name": "#<%team%>.new_drone.honey_cost","objective": "v"},"color":"yellow"},{"text":" Honey","color":"yellow"}]]
									scoreboard players operation .team_<%team%> honey -= #<%team%>.new_drone.honey_cost v
									function teams:<%team%>/summon_drone

									function map:update_scores
									scoreboard players set #purchase_success v 1
								}

							}

							execute if score #new_soldier v matches 1 if score .team_<%team%> honey >= #<%team%>.new_soldier.honey_cost v if score .team_<%team%> wax >= #<%team%>.new_soldier.wax_cost v run {
								execute (if score .team_<%team%> soldiers matches 20..) {
									scoreboard players set #purchase_success v 2
								} else {
									tellraw @a[team=<%team%>] ["",{"text":"["},{"selector":"@s"},{"text":"]"},[{"text":" Purchased a ","color":"green"},{"text":"Soldier","color":"gold"}," for ",{"score": {"name": "#<%team%>.new_soldier.honey_cost","objective": "v"},"color":"yellow"},{"text":" Honey","color":"yellow"},{"text":" and "},{"score": {"name": "#<%team%>.new_soldier.wax_cost","objective": "v"},"color":"yellow"},{"text":" Wax","color":"yellow"}]]
									scoreboard players operation .team_<%team%> honey -= #<%team%>.new_soldier.honey_cost v
									scoreboard players operation .team_<%team%> wax -= #<%team%>.new_soldier.wax_cost v
									function teams:<%team%>/summon_soldier

									function map:update_scores
									scoreboard players set #purchase_success v 1
								}
							}

							execute if score #purchase_success v matches 0 run {
								tellraw @s [{"text":"You don't have enough resources to purchase this!","color":"red"}]
								playsound minecraft:entity.villager.no player @s ~ ~ ~ 1 1
							}
							execute if score #purchase_success v matches 1 run {
								# function shops:upgrades/kick_player
								playsound minecraft:entity.villager.yes player @s ~ ~ ~ 1 1
							}
							execute if score #purchase_success v matches 2 run {
								tellraw @s [{"text":"You already have the maximum number of Soldiers in your swarm!","color":"red"}]
								playsound minecraft:entity.villager.no player @s ~ ~ ~ 1 1
							}
							execute if score #purchase_success v matches 3 run {
								tellraw @s [{"text":"You already have the maximum number of Drones! Upgrade your hive to get more.","color":"red"}]
								playsound minecraft:entity.villager.no player @s ~ ~ ~ 1 1
							}
						}
					}
				}
				clear @s #items:all{upgrades_shop:1b}
			}
		}
	}
	LOOP(['a','b'],team){
		modifier capacity_upgrade_<%team%> {
			"function": "minecraft:set_lore",
			"entity": "this",
			"lore": [
				[
					{"text":"","italic":false,"color":"aqua"},
					{"text":"Purchase for "},
					{"score": {"name": "#<%team%>.hive.max_resources.honey_cost","objective": "v"},"color":"yellow"},
					{"text":" Honey","color":"yellow"},
					{"text":" and "},
					{"score": {"name": "#<%team%>.hive.max_resources.wax_cost","objective": "v"},"color":"yellow"},
					{"text":" Wax","color":"yellow"}
				]
			]
		}
		modifier gen_speed_upgrade_<%team%> {
			"function": "minecraft:set_lore",
			"entity": "this",
			"lore": [
				[
					{"text":"","italic":false,"color":"aqua"},
					{"text":"Purchase for "},
					{"score": {"name": "#<%team%>.gen_speed.honey_cost","objective": "v"},"color":"yellow"},
					{"text":" Honey","color":"yellow"},
					{"text":" and "},
					{"score": {"name": "#<%team%>.gen_speed.wax_cost","objective": "v"},"color":"yellow"},
					{"text":" Wax","color":"yellow"}
				]
			]
		}
		modifier bee_capacity_upgrade_<%team%> {
			"function": "minecraft:set_lore",
			"entity": "this",
			"lore": [
				[
					{"text":"","italic":false,"color":"aqua"},
					{"text":"Purchase for "},
					{"score": {"name": "#<%team%>.hive.max_bees.honey_cost","objective": "v"},"color":"yellow"},
					{"text":" Honey","color":"yellow"},
					{"text":" and "},
					{"score": {"name": "#<%team%>.hive.max_bees.wax_cost","objective": "v"},"color":"yellow"},
					{"text":" Wax","color":"yellow"}
				]
			]
		}
		modifier new_drone_<%team%> {
			"function": "minecraft:set_lore",
			"entity": "this",
			"lore": [
				[
					{"text":"","italic":false,"color":"aqua"},
					{"text":"Purchase for "},
					{"score": {"name": "#<%team%>.new_drone.honey_cost","objective": "v"},"color":"yellow"},
					{"text":" Honey","color":"yellow"}
				]
			]
		}
		modifier new_soldier_<%team%> {
			"function": "minecraft:set_lore",
			"entity": "this",
			"lore": [
				[
					{"text":"","italic":false,"color":"aqua"},
					{"text":"Purchase for "},
					{"score": {"name": "#<%team%>.new_soldier.honey_cost","objective": "v"},"color":"yellow"},
					{"text":" Honey","color":"yellow"},
					{"text":" and "},
					{"score": {"name": "#<%team%>.new_soldier.wax_cost","objective": "v"},"color":"yellow"},
					{"text":" Wax","color":"yellow"}
				]
			]
		}
	}
}
