
function load {
	scoreboard objectives add i dummy
	scoreboard objectives add v dummy
	scoreboard objectives add id dummy
	scoreboard objectives add cap dummy

	scoreboard objectives add gen_timer dummy

	scoreboard objectives add state dummy
	scoreboard objectives add wax dummy
	scoreboard objectives add pollen dummy
	scoreboard objectives add target dummy
	scoreboard objectives add target_cooldown dummy
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
