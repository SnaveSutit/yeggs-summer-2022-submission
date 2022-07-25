
function reset {
	LOOP(['a','b'],team){
		scoreboard players set #<%team%>.pollen_gen.speed v 40
		scoreboard players set #<%team%>.pollen_gen.amount v 10
		scoreboard players set #<%team%>.wax_gen.speed v 40
		scoreboard players set #<%team%>.wax_gen.amount v 1
		scoreboard players set #<%team%>.hive.max_bees v 1
		scoreboard players set #<%team%>.hive.max_honey v 50
		scoreboard players set #<%team%>.hive.max_wax v 50
	}
}
