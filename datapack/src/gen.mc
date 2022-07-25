import log.mcm

LOOP(['pollen','wax'],resource){
	dir <%resource%> {
		function summon {
			execute align xyz positioned ~.5 ~.5 ~.5 run summon marker ~ ~ ~ {Tags:['gen.<%resource%>','new']}
			execute as @e[type=marker,tag=gen.<%resource%>,limit=1,distance=..2,tag=new] at @s run {
				execute store result score @s id run scoreboard players add last.id v 1
				!IF(resource === 'pollen') {
					summon armor_stand ~ ~-1.5 ~ {Tags:['gen.<%resource%>.ring','new'],Invisible:1b,Marker:true,NoGravity:1b,Invulnerable:1b,ArmorItems:[{},{},{},{id:"minecraft:leather_horse_armor",Count:1b,tag:{display:{color:16777215}}}]}
				}
				!IF(resource === 'wax'){
					summon armor_stand ~ ~-1.5 ~ {Tags:['gen.<%resource%>.ring','new'],Invisible:1b,Marker:true,NoGravity:1b,Invulnerable:1b,ArmorItems:[{},{},{},{id:"minecraft:leather_horse_armor",Count:1b,tag:{CustomModelData:1,display:{color:16777215}}}]}
				}

				# summon area_effect_cloud ~ ~ ~ {Tags:['gen.<%resource%>.name'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b,CustomName:'[{"text":"[","color":"white"},{"text":"0","color":"yellow"},{"text":" <%resource.charAt(0).toUpperCase()+resource.slice(1)%>","color":"yellow"},"]"]'}
				summon area_effect_cloud ~3 ~-1 ~ {Tags:['gen.<%resource%>.name'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b,CustomName:'[{"text":"[","color":"white"},{"text":"0","color":"yellow"},{"text":" <%resource.charAt(0).toUpperCase()+resource.slice(1)%>","color":"yellow"},"]"]'}
				summon area_effect_cloud ~-3 ~-1 ~ {Tags:['gen.<%resource%>.name'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b,CustomName:'[{"text":"[","color":"white"},{"text":"0","color":"yellow"},{"text":" <%resource.charAt(0).toUpperCase()+resource.slice(1)%>","color":"yellow"},"]"]'}
				summon area_effect_cloud ~ ~-1 ~3 {Tags:['gen.<%resource%>.name'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b,CustomName:'[{"text":"[","color":"white"},{"text":"0","color":"yellow"},{"text":" <%resource.charAt(0).toUpperCase()+resource.slice(1)%>","color":"yellow"},"]"]'}
				summon area_effect_cloud ~ ~-1 ~-3 {Tags:['gen.<%resource%>.name'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomNameVisible:1b,CustomName:'[{"text":"[","color":"white"},{"text":"0","color":"yellow"},{"text":" <%resource.charAt(0).toUpperCase()+resource.slice(1)%>","color":"yellow"},"]"]'}

				scoreboard players set @s cap 0
				scoreboard players set @s <%resource%> 0
				scoreboard players set @s gen_timer 0

				!IF(resource === 'wax'){
					fill ~2 ~-2 ~2 ~-2 ~-2 ~-2 minecraft:white_stained_glass
					fill ~2 ~-3 ~2 ~-2 ~-3 ~-2 minecraft:white_wool replace minecraft:red_wool
					fill ~2 ~-3 ~2 ~-2 ~-3 ~-2 minecraft:white_wool replace minecraft:blue_wool
				}

				tag @s remove new
			}
		}

		clock 1t {
			<%%if (!config.storage) config.storage = {}%%>
			<%%config.storage.cap_time = 60%%>
			execute as @e[type=armor_stand,tag=gen.<%resource%>.ring] at @s run {
				LOOP(config.storage.cap_time*2,i) {
					execute if score @s cap matches <%i-config.storage.cap_time%> run tp @s ~ ~ ~ ~<%(i-config.storage.cap_time)/4%> ~
				}
			}
		}

		clock 5t {
			execute as @e[type=marker,tag=gen.<%resource%>] at @s positioned ~ ~-1.5 ~ run {
				tag @s add this.gen
				scoreboard players operation #old_cap v = @s cap
				execute if entity @s[tag=!captured_by_a] as @a[distance=..5,team=a] run function gen:<%resource%>/cap_a
				execute if entity @s[tag=!captured_by_b] as @a[distance=..5,team=b] run function gen:<%resource%>/cap_b

				execute (if score #old_cap v = @s cap) {
					execute if score @s cap matches 1.. run scoreboard players remove @s cap 1
					execute if score @s cap matches ..-1 run scoreboard players add @s cap 1
					execute unless score @s cap = #old_cap v run function gen:<%resource%>/layered_charging_audio
					# particle dust 0 1 0 1 ~ ~.5 ~
				} else {
					function gen:<%resource%>/layered_charging_audio
				}

				scoreboard players operation #cap v = @s cap
				execute as @e[type=armor_stand,tag=gen.<%resource%>.ring,distance=..3,limit=1] run scoreboard players operation @s cap = #cap v

				execute if score @s cap matches <%config.storage.cap_time%>.. run function gen:<%resource%>/captured_by_a
				execute if score @s cap matches ..-<%config.storage.cap_time%> run function gen:<%resource%>/captured_by_b

				LOOP(['a','b'], team) {
					execute if entity @s[tag=captured_by_<%team%>, scores={<%resource%>=..50}] run {
						scoreboard players add @s gen_timer 1
						execute if score @s gen_timer > #<%team%>.<%resource%>_gen.speed v run {
							playsound minecraft:block.big_dripleaf.tilt_up block @a ~ ~ ~ 1 1
							particle minecraft:falling_nectar ~ ~2 ~ 2 0.5 2 0 20 force @a
							scoreboard players set @s gen_timer 0
							scoreboard players operation @s <%resource%> += #<%team%>.<%resource%>_gen.amount v
						}
						function gen:<%resource%>/update_name
					}
				}
				tag @s remove this.gen
			}
		}

		# function pulse {
		# 	<%%config.storage.r = 5%%>
		# 	<%%config.storage.points = 100%%>
		# 	LOOP(config.storage.points, i) {
		# 		<%%
		# 			let theta = (2 * Math.PI) / config.storage.points
		# 			let angle = (theta * i)
		# 			let x = Math.round(config.storage.r*Math.cos(angle) * 1000)/1000
		# 			let z = Math.round(config.storage.r*Math.sin(angle) * 1000)/1000
		# 			emit(`particle minecraft:end_rod ~ ~-1.3 ~ ${x/10} ${((Math.sin(i)*0.1))/10} ${z/10} 1 0 force`)
		# 		%%>
		# 	}
		# }

		function update_name {
			tag @s add this.gen
			setblock 0 10 0 air
			setblock 0 10 0 oak_sign{Text1:'[{"text":"[","color":"white"},{"score":{"name":"@e[type=marker,tag=this.gen]","objective":"<%resource%>"},"color":"yellow"},{"text":" <%resource.charAt(0).toUpperCase()+resource.slice(1)%>","color":"yellow"},"]"]'}
			execute as @e[type=area_effect_cloud,distance=..10,tag=gen.<%resource%>.name] run data modify entity @s CustomName set from block 0 10 0 Text1
			tag @s remove this.gen
		}

		function captured_by_a {
			tag @s add captured_by_a
			tag @s remove captured_by_b
			function gen:<%resource%>/capture_effects
			scoreboard players set @s cap 0
			!IF(resource === 'wax'){
				fill ~2 ~-1 ~2 ~-2 ~-1 ~-2 minecraft:red_stained_glass
				fill ~2 ~-2 ~2 ~-2 ~-2 ~-2 minecraft:red_wool replace minecraft:white_wool
				fill ~2 ~-2 ~2 ~-2 ~-2 ~-2 minecraft:red_wool replace minecraft:blue_wool
			}
			execute as @e[type=armor_stand,tag=gen.<%resource%>.ring,distance=..3,limit=1] run data modify entity @s ArmorItems[-1].tag.display.color set value 11141120
		}
		function captured_by_b {
			tag @s add captured_by_b
			tag @s remove captured_by_a
			function gen:<%resource%>/capture_effects
			scoreboard players set @s cap 0
			!IF(resource === 'wax'){
				fill ~2 ~-1 ~2 ~-2 ~-1 ~-2 minecraft:blue_stained_glass
				fill ~2 ~-2 ~2 ~-2 ~-2 ~-2 minecraft:blue_wool replace minecraft:white_wool
				fill ~2 ~-2 ~2 ~-2 ~-2 ~-2 minecraft:blue_wool replace minecraft:red_wool
			}
			execute as @e[type=armor_stand,tag=gen.<%resource%>.ring,distance=..3,limit=1] run data modify entity @s ArmorItems[-1].tag.display.color set value 170
		}
		function capture_effects {
			playsound minecraft:item.bottle.fill_dragonbreath player @a ~ ~ ~ 1 1
			stopsound @a[distance=..10] player minecraft:block.beacon.ambient
		}
		function layered_charging_audio {
			scoreboard players operation # v = @s cap
			execute if score # v matches ..-1 run scoreboard players operation # v *= -1 v
			LOOP(config.storage.cap_time,i){
				execute if score # v matches <%i+1%> run playsound minecraft:block.beacon.ambient player @a ~ ~ ~ 2 <%0.5+(i * (1.5 / config.storage.cap_time))%>
			}
		}
		function cap_a {
			scoreboard players add @e[type=marker,tag=gen.<%resource%>,limit=1,sort=nearest] cap 1
			# particle dust 0 0 1 1 ~ ~.5 ~
		}
		function cap_b {
			scoreboard players remove @e[type=marker,tag=gen.<%resource%>,limit=1,sort=nearest] cap 1
			# particle dust 1 0 0 1 ~ ~.5 ~
		}
	}
}
