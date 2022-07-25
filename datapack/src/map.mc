
function load {
	scoreboard objectives add i dummy
	scoreboard objectives add v dummy
	scoreboard objectives add id dummy
	scoreboard objectives add cap dummy
	scoreboard objectives add timer dummy

	scoreboard objectives add honey dummy

	scoreboard objectives add display_a dummy ["",{"text":"Team","color":"white"}," ",{"text":"Red","color":"red"}]
	scoreboard objectives add display_b dummy ["",{"text":"Team","color":"white"}," ",{"text":"Blue","color":"blue"}]
	scoreboard objectives setdisplay sidebar.team.red display_a
	scoreboard objectives setdisplay sidebar.team.blue display_b
	scoreboard players set [Honey] display_a 0
	scoreboard players set [Wax] display_a 0
	scoreboard players set [Honey] display_b 0
	scoreboard players set [Wax] display_b 0

	scoreboard objectives add gen_timer dummy

	scoreboard objectives add state dummy
	scoreboard objectives add wax dummy
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

	tellraw @a {"text":"Reloaded!"}
}

function reset {
	kill @e[type=bee,tag=drone]
	kill @e[type=bee,tag=attacker]
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
	execute positioned -37 21 -262 run {
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

	LOOP(['a','b'],team){
		scoreboard players set .team_<%team%> honey 0
	}
}

function tick {
	LOOP(['a','b'],team){
		scoreboard players operation [Honey] display_<%team%> = .team_<%team%> honey
	}
}
