
function reset {
	LOOP(['a','b'],team){
		scoreboard players set #<%team%>.pollen_gen.speed v 70
		scoreboard players set #<%team%>.pollen_gen.amount v 10
		scoreboard players set #<%team%>.wax_gen.speed v 70
		scoreboard players set #<%team%>.wax_gen.amount v 6
		scoreboard players set #<%team%>.gen_speed.honey_cost v 8
		scoreboard players set #<%team%>.gen_speed.wax_cost v 5
		scoreboard players set #<%team%>.gen_speed.increase_multiplier v 850
		scoreboard players set #<%team%>.gen_speed.cost_multiplier v 1250

		scoreboard players set #<%team%>.hive.max_bees v 10
		scoreboard players set #<%team%>.hive.max_bees.honey_cost v 30
		scoreboard players set #<%team%>.hive.max_bees.wax_cost v 10
		scoreboard players set #<%team%>.hive.max_bees.increase_multiplier v 2000
		scoreboard players set #<%team%>.hive.max_bees.cost_multiplier v 1500

		scoreboard players set #<%team%>.new_drone.honey_cost v 3
		scoreboard players set #<%team%>.new_drone.cost_multiplier v 1000

		scoreboard players set #<%team%>.new_soldier.honey_cost v 6
		scoreboard players set #<%team%>.new_soldier.wax_cost v 1
		scoreboard players set #<%team%>.new_soldier.cost_multiplier v 1000

		scoreboard players set #<%team%>.hive.max_honey v 50
		scoreboard players set #<%team%>.hive.max_wax v 20
		scoreboard players set #<%team%>.hive.max_resources.honey_cost v 10
		scoreboard players set #<%team%>.hive.max_resources.wax_cost v 5
		scoreboard players set #<%team%>.hive.max_resources.increase_multiplier v 2000
		scoreboard players set #<%team%>.hive.max_resources.cost_multiplier v 2000
	}
}
