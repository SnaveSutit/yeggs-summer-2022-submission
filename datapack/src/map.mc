
function load {
	scoreboard objectives add i dummy
	scoreboard objectives add v dummy
	scoreboard objectives add id dummy
	scoreboard objectives add cap dummy

	scoreboard players set 1 v 1
	scoreboard players set 2 v 2
	scoreboard players set 4 v 4
	scoreboard players set 10 v 10
	scoreboard players set 12 v 12
	scoreboard players set 20 v 20
	scoreboard players set 100 v 100
	scoreboard players set 1000 v 1000
	scoreboard players set -1 v -1

	tellraw @a {"text":"Reloaded!"}
}

function reset {
	kill @e[type=marker,tag=hive]
	kill @e[type=marker,tag=drone_target]
	kill @e[type=marker,tag=gen.pollen]
	kill @e[type=marker,tag=gen.wax]
	execute positioned -2 26 -172 run {
		function targets:summon_hive
		team join a @e[type=marker,tag=hive,distance=..1,team=]
	}
	execute positioned -4 26 -278 run {
		function targets:summon_hive
		team join b @e[type=marker,tag=hive,distance=..1,team=]
	}

	execute positioned -36 29 -225 run {
		function targets:summon_pollen
		function pollen_gen:summon
	}
	execute positioned 30 29 -225 run {
		function targets:summon_pollen
		function pollen_gen:summon
	}
	execute positioned 33 21 -188 run {
		function targets:summon_pollen
		function pollen_gen:summon
	}
	execute positioned -37 21 -262 run {
		function targets:summon_pollen
		function pollen_gen:summon
	}

	execute positioned -44 29 -187 run function targets:summon_wax
	execute positioned -3 26 -224 run function targets:summon_wax
	execute positioned 40 29 -263 run function targets:summon_wax
}
