
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

	scoreboard objectives add display_a dummy ["",{"text":"Team","color":"white"}," ",{"text":"Red","color":"red"}]
	scoreboard objectives add display_b dummy ["",{"text":"Team","color":"white"}," ",{"text":"Blue","color":"blue"}]
	scoreboard objectives setdisplay sidebar.team.red display_a
	scoreboard objectives setdisplay sidebar.team.blue display_b
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

	tellraw @a {"text":"Reloaded!"}
}

function reset {
	kill @e[type=bee,tag=drone]
	kill @e[type=bee,tag=soldier]
	kill @e[type=marker,tag=hive]
	kill @e[type=marker,tag=drone_target]
	kill @e[type=marker,tag=gen.pollen]
	kill @e[type=armor_stand,tag=gen.pollen.ring]
	kill @e[type=marker,tag=gen.wax]
	kill @e[type=armor_stand,tag=gen.wax.ring]

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
}

function tick {
	LOOP(['a','b'],team){
		scoreboard players operation [Honey] display_<%team%> = .team_<%team%> honey
		scoreboard players operation [Wax] display_<%team%> = .team_<%team%> wax
		scoreboard players operation [Drones] display_<%team%> = .team_<%team%> drones
		scoreboard players operation [Soldiers] display_<%team%> = .team_<%team%> soldiers

		execute if score #<%team%>.attacking v matches 0 if score .team_<%team%> soldiers matches 20.. run {
			scoreboard players operation #target v = @e[type=marker,tag=drone_target,tag=hive,limit=1,tag=!team_<%team%>] id
			execute as @e[type=bee,tag=soldier,team=<%team%>] at @s run {
				scoreboard players operation @s target = #target v
				scoreboard players operation @s state = #soldier.ATTACK state
			}
			scoreboard players set #<%team%>.attacking v 1
		}
		execute if score #<%team%>.attacking v matches 1 if score .team_<%team%> soldiers matches ..0 run {
			scoreboard players set #<%team%>.attacking v 0
		}
	}
}

clock 1s {
	name update_scores
	LOOP(['a','b'],team){
		execute store result score .team_<%team%> drones if entity @e[type=bee,tag=drone,team=<%team%>]
		execute store result score .team_<%team%> soldiers if entity @e[type=bee,tag=soldier,team=<%team%>]
		execute store result bossbar minecraft:swarm_<%team%> value run scoreboard players get .team_<%team%> soldiers
	}
}

function start {
	scoreboard players set #running v 1
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
