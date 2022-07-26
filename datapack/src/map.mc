
function load {
	scoreboard objectives add i dummy
	scoreboard objectives add v dummy
	scoreboard objectives add id dummy
	scoreboard objectives add game_id dummy
	scoreboard objectives add cap dummy
	scoreboard objectives add timer dummy

	scoreboard objectives add honey dummy
	scoreboard objectives add wax dummy
	scoreboard objectives add drones dummy
	scoreboard objectives add soldiers dummy
	scoreboard objectives add health dummy
	scoreboard objectives add leave minecraft.custom:minecraft.leave_game
	scoreboard objectives add death deathCount

	scoreboard objectives add display_a dummy ["",{"text":"Team","color":"white"}," ",{"text":"Red","color":"red"}]
	scoreboard objectives add display_b dummy ["",{"text":"Team","color":"white"}," ",{"text":"Blue","color":"blue"}]
	LOOP(['a','b'],team){
		scoreboard players set [Honey] display_<%team%> 0
		scoreboard players set [Wax] display_<%team%> 0
		scoreboard players set [Drones] display_<%team%> 0
		scoreboard players set [Soldiers] display_<%team%> 0
	}

	scoreboard objectives add gen_timer dummy

	scoreboard objectives add state dummy
	scoreboard objectives add pollen dummy
	scoreboard objectives add target dummy
	scoreboard objectives add idle_timer dummy
	scoreboard objectives add path_timer dummy

	scoreboard objectives add motion.x dummy
	scoreboard objectives add motion.y dummy
	scoreboard objectives add motion.z dummy

	scoreboard players set 1 v 1
	scoreboard players set 2 v 2
	scoreboard players set 4 v 4
	scoreboard players set 10 v 10
	scoreboard players set 12 v 12
	scoreboard players set 15 v 15
	scoreboard players set 20 v 20
	scoreboard players set 30 v 30
	scoreboard players set 100 v 100
	scoreboard players set 1000 v 1000
	scoreboard players set -1 v -1

	scoreboard players set last.id v 0

	gamerule naturalRegeneration true
	gamerule fallDamage true
	gamerule drowningDamage false
	gamerule keepInventory true
	gamerule fireDamage true

	forceload add -82 -316 84 -115

	schedule function statues:animation_loop 10t replace
	schedule function haha_bee:animation_loop 10t replace
	# tellraw @a {"text":"Reloaded!"}
}

function reset {
	kill @e[tag=shop.kits]
	kill @e[tag=shop.upgrades]
	kill @e[type=bee,tag=drone]
	kill @e[type=bee,tag=soldier]
	kill @e[type=marker,tag=hive]
	kill @e[type=marker,tag=drone_target]
	kill @e[type=marker,tag=gen.pollen]
	kill @e[type=marker,tag=gen.wax]
	kill @e[type=armor_stand,tag=gen.pollen.ring]
	kill @e[type=armor_stand,tag=gen.wax.ring]
	kill @e[type=area_effect_cloud,tag=gen.pollen.name]
	kill @e[type=area_effect_cloud,tag=gen.wax.name]
	kill @e[type=area_effect_cloud,tag=gen.pollen.biome]
	kill @e[type=area_effect_cloud,tag=gen.wax.biome]

	summon area_effect_cloud -68 46 -300 {Tags:['team_display'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"Red Team","color":"red"}',CustomNameVisible:1b}
	summon area_effect_cloud -64 46 -300 {Tags:['team_display'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"Blue Team","color":"blue"}',CustomNameVisible:1b}
	summon area_effect_cloud -74.0 46 -295.0 {Tags:['team_display'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"Spectators","color":"gray"}',CustomNameVisible:1b}

	function haha_bee:remove/all

	execute positioned -6 26 -288 rotated -90 0 run {
		function shops:kits/summon
		function haha_bee:summon/default
	}
	execute positioned 0 26 -162 rotated 90 0 run {
		function shops:kits/summon
		function haha_bee:summon/default
	}

	execute positioned -6 26 -286 rotated -90 0 run {
		function shops:upgrades/summon
		function haha_bee:summon/default
	}
	execute positioned 0 26 -164 rotated 90 0 run {
		function shops:upgrades/summon
		function haha_bee:summon/default
	}

	execute as @e[type=minecraft:marker,tag=aj.haha_bee.root] run function haha_bee:animations/idle/play

	function statues:remove/all
	execute positioned -67 45 -288 rotated 180 0 run function statues:summon/default
	execute as @e[type=marker,tag=aj.statues.root] run function statues:animations/idle/play

	execute positioned -3 28 -173 run {
		function targets:summon_hive
		tag @e[type=marker,tag=hive,distance=..1] add team_a
	}
	execute positioned -3 28 -277 run {
		function targets:summon_hive
		tag @e[type=marker,tag=hive,distance=..1] add team_b
	}

	execute positioned -36 29 -225 run {
		# Flower Forest
		function targets:summon_pollen
		function gen:pollen/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.pollen.biome] run {
			data modify entity @s CustomName set value '[{"text":"Flower Forest"}]'
		}
	}
	execute positioned 30 29 -225 run {
		# Tulip Thicket
		function targets:summon_pollen
		function gen:pollen/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.pollen.biome] run {
			data modify entity @s CustomName set value '[{"text":"Tulip Thicket"}]'
		}
	}
	execute positioned 31 21 -188 run {
		# Lilac Groves
		function targets:summon_pollen
		function gen:pollen/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.pollen.biome] run {
			data modify entity @s CustomName set value '[{"text":"Lilac Groves"}]'
		}
	}
	execute positioned -36 21 -262 run {
		# Orchid Orchard
		function targets:summon_pollen
		function gen:pollen/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.pollen.biome] run {
			data modify entity @s CustomName set value '[{"text":"Orchid Orchard"}]'
		}
	}

	execute positioned -43 29 -187 run {
		function targets:summon_wax
		function gen:wax/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.wax.biome] run {
			data modify entity @s CustomName set value '[{"text":"Wasp Nest"}]'
		}
	}
	execute positioned -3 26 -225 run {
		function targets:summon_wax
		function gen:wax/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.wax.biome] run {
			data modify entity @s CustomName set value '[{"text":"The Garden"}]'
		}
	}
	execute positioned 38 29 -263 run {
		function targets:summon_wax
		function gen:wax/summon
		execute as @e[type=area_effect_cloud,distance=..10,tag=gen.wax.biome] run {
			data modify entity @s CustomName set value '[{"text":"Beehive"}]'
		}
	}

	execute positioned 7 29 -174 run {
		function targets:summon_swarm
	}
	execute positioned -13 29 -276 run {
		function targets:summon_swarm
	}

	LOOP(['a','b'],team){
		bossbar set minecraft:hive_<%team%> players
		bossbar set minecraft:swarm_<%team%> players
		scoreboard players set .team_<%team%> health 60
		scoreboard players set .team_<%team%> honey 0
		scoreboard players set .team_<%team%> wax 0
		scoreboard players set .team_<%team%> drones 0
		scoreboard players set .team_<%team%> soldiers 0

		scoreboard players set #<%team%>.attacking v 0
	}

	scoreboard players set #running v 0
	function upgrades:reset
	setworldspawn -66 45 -294 0
	spawnpoint @a -66 45 -294 0

	scoreboard objectives setdisplay sidebar.team.red
	scoreboard objectives setdisplay sidebar.team.blue

	tp @a[tag=!Admin] -66 45 -294 0 0
	gamemode adventure @a[tag=!Admin]

	setblock -67 45 -292 minecraft:crimson_button
	setblock -65 45 -292 minecraft:crimson_button

	kill @e[type=area_effect_cloud,tag=start_button]
	summon area_effect_cloud -67 45 -291.1 {Tags:['start_button'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"Start map!"}',CustomNameVisible:1b}
	summon area_effect_cloud -65 45 -291.1 {Tags:['start_button'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"How to play"}',CustomNameVisible:1b}

	clear @a
	effect give @a minecraft:regeneration 1 255 true
	effect give @a minecraft:saturation 1 20 true

	scoreboard players set #endgame v 0

	# FIXME Remove this when the map is ready
	setblock 7 29 -174 air
	setblock -13 29 -276 air
	setblock -36 20 -262 air
	setblock -36 28 -225 air
	setblock 30 28 -225 air
	setblock 31 20 -188 air
}

function tick {
	LOOP(['a','b'],team){
		scoreboard players operation [Honey] display_<%team%> = .team_<%team%> honey
		scoreboard players operation [Wax] display_<%team%> = .team_<%team%> wax
		scoreboard players operation [Drones] display_<%team%> = .team_<%team%> drones
		scoreboard players operation [Soldiers] display_<%team%> = .team_<%team%> soldiers

		LOOP(['honey','wax'],resource) {
			scoreboard players add #<%team%>_<%resource%>_warning_cooldown v 0
			execute if score #<%team%>_<%resource%>_warning_cooldown v matches 1.. run scoreboard players remove #<%team%>_<%resource%>_warning_cooldown v 1
			execute if score #<%team%>_<%resource%>_warning_cooldown v matches 0 if score .team_<%team%> <%resource%> > #<%team%>.hive.max_<%resource%> v run {
				scoreboard players operation .team_<%team%> <%resource%> = #<%team%>.hive.max_<%resource%> v
				tellraw @a[team=<%team%>] {"text":"Your hive has reached its maximum <%resource.charAt(0).toUpperCase()+resource.slice(1)%> capacity! Spend some <%resource.charAt(0).toUpperCase()+resource.slice(1)%> or upgrade your hive to collect more!","color":"red"}
				playsound minecraft:block.note_block.pling block @a[team=<%team%>] ~ ~ ~ 10000 1
				scoreboard players set #<%team%>_<%resource%>_warning_cooldown v 600
			}
		}

		execute if score #running v matches 1 if score .team_<%team==='a'?'b':'a'%> health matches ..0 run {
			scoreboard players set #running v 0
			scoreboard players set #endgame v 400
			title @a times 20 360 20
			title @a title [{"text":"<%team==='a'?'Red':'Blue'%> Team wins!","color":"<%team==='a'?'red':'blue'%>"}]
			scoreboard players set #winning_team v <%team==='a'?1:2%>
		}
		execute if score #endgame v matches 1.. if score #winning_team v matches <%team==='a'?1:2%> run {
			scoreboard players remove #endgame v 1
			execute if score #endgame v matches 0 run function map:reset
		}

		execute if score #<%team%>.attacking v matches 0 if score .team_<%team%> soldiers matches 20.. run {
			scoreboard players operation #target v = @e[type=marker,tag=drone_target,tag=hive,limit=1,tag=!team_<%team%>] id
			execute as @e[type=bee,tag=soldier,team=<%team%>] at @s run {
				scoreboard players operation @s target = #target v
				scoreboard players operation @s state = #soldier.ATTACK state
			}
			title @a[team=<%team%>] times 10 40 10
			title @a[team=<%team%>] title ""
			title @a[team=<%team%>] subtitle ["",{"text":"Your swarm is attacking the enemy Hive!","color":"green"}]
			scoreboard players set #<%team%>.attacking v 1
		}
		execute if score #<%team%>.attacking v matches 1 if score .team_<%team%> soldiers matches ..0 run {
			scoreboard players set #<%team%>.attacking v 0
		}
	}

	execute as @e[type=player,scores={death=1..}] run {
		scoreboard players set @s death 0
		execute if entity @s[tag=chambeeion] run function kits:chambeeion
		execute if entity @s[tag=stinger] run function kits:stinger
		execute if entity @s[tag=beefender] run function kits:beefender
		execute if entity @s[tag=pollenator] run function kits:pollenator
	}

	execute if block -67 45 -292 minecraft:crimson_button[powered=true] run function map:check_start_condition
	execute if block -65 45 -292 minecraft:crimson_button[powered=true] run {
		tellraw @a [{"text":"","color":"yellow"},{"text":"--- HOW TO PLAY ---","color":"gold"},{"text":"\nCapture points to generate resources."},{"text":"\nYour Drones will automatically collect and transport the generated resources back to your base."},{"text":"\n"},{"text":"\nYou can purchase upgrades and bees in the Upgrades shop at your base."},{"text":"\n"},{"text":"\nCaptured generators overfull? Buy more drones for more resource thoughput."},{"text":"\nDrones overworked? Upgrade generators or capture more points to produce more resources."},{"text":"\n"},{"text":"\nYou cannot directly attack the enemy base. Instead; You must build up a swarm of 20 soldier bees."},{"text":"\nOnce you've built up 20 soldiers, the swarm will automatically attack the enemy base."},{"text":"\n"},{"text":"\nTired of using a sword? Purchase a different kit in the Kits shop at your base!"}]
		setblock -65 45 -292 air
		setblock -65 45 -292 minecraft:crimson_button
	}
}

clock 10t {
	execute as @a[x=-69,y=48,z=-300, dx=2,dy=-3,dz=-2,team=!a] run {
		team join a @s
		title @s times 10 20 10
		title @s title [{"text":"Joined Red Team!","color":"red"}]
		scoreboard players set #confirm v 0
		playsound minecraft:block.respawn_anchor.charge player @s ~ ~ ~ 100 2
	}
	execute as @a[x=-66,y=48,z=-300, dx=3,dy=-3,dz=-2,team=!b] run {
		team join b @s
		title @s times 10 20 10
		title @s title [{"text":"Joined Blue Team!","color":"blue"}]
		scoreboard players set #confirm v 0
		playsound minecraft:block.respawn_anchor.charge player @s ~ ~ ~ 100 2
	}
	execute as @a[x=-74,y=48,z=-294, dx=-3,dy=-3,dz=-3,team=!spectator] run {
		team join spectator @s
		title @s times 10 20 10
		title @s title [{"text":"Joined Spectators!","color":"gray"}]
		scoreboard players set #confirm v 0
		playsound minecraft:block.respawn_anchor.charge player @s ~ ~ ~ 100 2
	}

	execute if score #running v matches 1 as @a run {
		execute if score @s leave matches 1.. unless score @s game_id = #game id run {
			tellraw @s {"text":"Welcome back! Please wait until the current game is over to join in!","color":"green"}
			team join spectator @s
			gamemode spectator @s
			function kits:remove_tags
			tp @s -3 28 -225
			scoreboard players set @s leave 0
		}
		execute as @a[team=] run {
			tellraw @s {"text":"Welcome! Please wait until the current gane is over to join in!","color":"green"}
			team join spectator @s
			gamemode spectator @s
			function kits:remove_tags
			tp @s -3 28 -225
		}
	}
	execute if score #running v matches 0 as @a run {
		execute if score @s leave matches 1.. run {
			# tellraw @s {"text":"Welcome back!","color":"green"}
			gamemode adventure @s
			tp @a[tag=!Admin] -66 45 -294 0 0
			function kits:remove_tags
			scoreboard players set @s leave 0
		}
	}
}

clock 1s {
	name update_scores
	LOOP(['a','b'],team){
		execute store result score .team_<%team%> drones if entity @e[type=bee,tag=drone,team=<%team%>]
		execute store result score .team_<%team%> soldiers if entity @e[type=bee,tag=soldier,team=<%team%>]
		execute store result bossbar minecraft:hive_<%team%> value run scoreboard players get .team_<%team%> health
		execute store result bossbar minecraft:swarm_<%team%> value run scoreboard players get .team_<%team%> soldiers
		execute if score #running v matches 1 if score .team_<%team%> drones matches 0 run {
			function teams:<%team%>/summon_drone
		}
	}
}

function check_start_condition {
	setblock -67 45 -292 air

	execute store result score #team_a_count v if entity @a[team=a]
	execute store result score #team_b_count v if entity @a[team=b]

	scoreboard players add #confirm v 0
	execute (if score #team_a_count v matches 0) {
		tellraw @a {"text":"No players on Red team!","color":"red"}
		setblock -67 45 -292 minecraft:crimson_button
	} else execute (if score #team_b_count v matches 0) {
		tellraw @a {"text":"No players on Blue team!","color":"red"}
		setblock -67 45 -292 minecraft:crimson_button
	} else execute (if score #team_a_count v matches 1..2) {
		execute (if score #confirm v matches 1) {
			scoreboard players set #confirm v 0
			function map:start
		} else {
			tellraw @a ["",{"text":"Warning! ","color":"gold"},{"text":"Red team is below the recommended player count (3).","color":"red"}, {"text":"\nThe game is balanced for 3-8 players on each team.","color":"gold"},{"text":"\nTo confirm that you want to continue with this player count; press the start button.","color":"gold"}]
			scoreboard players set #confirm v 1
			setblock -67 45 -292 minecraft:crimson_button
		}
	} else execute (if score #team_b_count v matches 1..2) {
		execute (if score #confirm v matches 1) {
			scoreboard players set #confirm v 0
			function map:start
		} else {
			tellraw @a ["",{"text":"Warning! ","color":"gold"},{"text":"Blue team is below the recommended player count (3).","color":"red"}, {"text":"\nThe game is balanced for 3-8 players on each team.","color":"gold"},{"text":"\nTo confirm that you want to continue with this player count; press the start button.","color":"gold"}]
			scoreboard players set #confirm v 1
			setblock -67 45 -292 minecraft:crimson_button
		}
	} else {
		function map:start
	}
}

function start {
	scoreboard players set #running v 1
	team join spectator @a[team=]
	gamemode adventure @a[team=!spectator,tag=!Admin]
	gamemode spectator @a[team=spectator]
	spawnpoint @a[team=a] -4 25 -163 180
	tp @a[team=a] -4 25 -163 180 0
	spawnpoint @a[team=b] -2 25 -287 0
	tp @a[team=b] -2 25 -287 0 0
	tp @a[team=spectator] -3 28 -225

	scoreboard objectives setdisplay sidebar.team.red display_a
	scoreboard objectives setdisplay sidebar.team.blue display_b

	kill @e[type=area_effect_cloud,tag=start_button]
	setblock -67 45 -292 air
	execute as @a run {
		function kits:remove_tags
		function kits:chambeeion
	}

	effect give @a minecraft:regeneration 1 255 true
	effect give @a minecraft:saturation 1 20 true

	LOOP(4,i){
		function teams:a/summon_drone
		function teams:b/summon_drone
	}
	scoreboard players add #game id 1
	scoreboard players operation @a game_id = #game id

	execute as @e[type=minecraft:marker,tag=aj.statues.root] run function statues:animations/idle/stop
}

clock 6s {
	execute if score #running v matches 1 run {
		bossbar set minecraft:hive_a players @a
		bossbar set minecraft:swarm_a players @a
		bossbar set minecraft:hive_b players
		bossbar set minecraft:swarm_b players
		schedule 3s replace {
			execute if score #running v matches 1 run {
				bossbar set minecraft:hive_a players
				bossbar set minecraft:swarm_a players
				bossbar set minecraft:hive_b players @a
				bossbar set minecraft:swarm_b players @a
			}
		}
	}
}
