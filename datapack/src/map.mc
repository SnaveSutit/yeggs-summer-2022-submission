
function load {
	scoreboard objectives add i dummy
	scoreboard objectives add v dummy
	scoreboard objectives add id dummy
	scoreboard objectives add cap dummy
	scoreboard objectives add timer dummy

	scoreboard objectives add honey dummy
	scoreboard objectives add wax dummy
	scoreboard objectives add drones dummy
	scoreboard objectives add soldiers dummy
	scoreboard objectives add health dummy

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

	tellraw @a {"text":"Reloaded!"}
}

function reset {
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

	execute positioned -2 26 -172 run {
		function targets:summon_hive
		tag @e[type=marker,tag=hive,distance=..1] add team_a
	}
	execute positioned -4 26 -278 run {
		function targets:summon_hive
		tag @e[type=marker,tag=hive,distance=..1] add team_b
	}

	execute positioned -36 29 -225 run {
		function targets:summon_pollen
		function gen:pollen/summon
	}
	execute positioned 30 29 -225 run {
		function targets:summon_pollen
		function gen:pollen/summon
	}
	execute positioned 31 21 -188 run {
		function targets:summon_pollen
		function gen:pollen/summon
	}
	execute positioned -36 21 -262 run {
		function targets:summon_pollen
		function gen:pollen/summon
	}

	execute positioned -43 29 -187 run {
		function targets:summon_wax
		function gen:wax/summon
	}
	execute positioned -3 26 -225 run {
		function targets:summon_wax
		function gen:wax/summon
	}
	execute positioned 38 29 -263 run {
		function targets:summon_wax
		function gen:wax/summon
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

	kill @e[tag=shop.kits]
	kill @e[tag=shop.upgrades]

	execute positioned -3 25 -165 run {
		function shops:kits/summon
	}
	execute positioned -3 25 -285 run {
		function shops:kits/summon
	}

	execute positioned -1 25 -165 run {
		function shops:upgrades/summon
	}
	execute positioned -5 25 -285 run {
		function shops:upgrades/summon
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

	kill @e[type=area_effect_cloud,tag=start_button]
	summon area_effect_cloud -67 45 -291.1 {Tags:['start_button'],Age:-2147483648,Duration:-1,WaitTime:-2147483648,CustomName:'{"text":"Start map!"}',CustomNameVisible:1b}

	clear @a
	effect give @a minecraft:regeneration 1 255 true
	effect give @a minecraft:saturation 1 20 true

	scoreboard players set #endgame v 0
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
}

clock 10t {
	execute as @a[x=-69,y=48,z=-300, dx=2,dy=-3,dz=-2,team=!a] run {
		team join a @s
		title @s times 10 20 10
		title @s title [{"text":"Joined Red Team!","color":"red"}]
		playsound minecraft:block.respawn_anchor.charge player @s ~ ~ ~ 100 2
	}
	execute as @a[x=-66,y=48,z=-300, dx=3,dy=-3,dz=-2,team=!b] run {
		team join b @s
		title @s times 10 20 10
		title @s title [{"text":"Joined Blue Team!","color":"blue"}]
		playsound minecraft:block.respawn_anchor.charge player @s ~ ~ ~ 100 2
	}
	execute as @a[x=-74,y=48,z=-294, dx=-3,dy=-3,dz=-3,team=!spectator] run {
		team join spectator @s
		title @s times 10 20 10
		title @s title [{"text":"Joined Spectators!","color":"gray"}]
		playsound minecraft:block.respawn_anchor.charge player @s ~ ~ ~ 100 2
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
	spawnpoint @a[team=a] -2 26 -172 0
	tp @a[team=a] -2 26 -172 0 0
	spawnpoint @a[team=b] -4 26 -278 0
	tp @a[team=b] -4 26 -278 0 0
	tp @a[team=spectator] -3 28 -225

	scoreboard objectives setdisplay sidebar.team.red display_a
	scoreboard objectives setdisplay sidebar.team.blue display_b

	kill @e[type=area_effect_cloud,tag=start_button]
	setblock -67 45 -292 air
	execute as @a run function kits:chambeeion

	effect give @a minecraft:regeneration 1 255 true
	effect give @a minecraft:saturation 1 20 true

	LOOP(2,i){
		function teams:a/summon_drone
		function teams:b/summon_drone
	}
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
