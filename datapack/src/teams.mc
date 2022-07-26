
function load {
	team add a {"text":"Red","color":"red"}
	team modify a color red
	team add b {"text":"Blue","color":"blue"}
	team modify b color blue
	team add spectator {"text":"Spectator","color":"dark_gray"}
	team modify spectator color dark_gray

	bossbar add swarm_a ["",{"text":"Red Swarm","color":"red"}]
	bossbar set minecraft:swarm_a color red
	bossbar add swarm_b ["",{"text":"Blue Swarm","color":"blue"}]
	bossbar set minecraft:swarm_b color blue

	bossbar add hive_a ["",{"text":"Red Hive","color":"red"}]
	bossbar set minecraft:hive_a color red
	bossbar add hive_b ["",{"text":"Blue Hive","color":"blue"}]
	bossbar set minecraft:hive_b color blue

	LOOP(['a','b'],team) {
		bossbar set minecraft:swarm_<%team%> max 20
		bossbar set minecraft:hive_<%team%> max 60
		bossbar set minecraft:swarm_<%team%> style notched_20

		team modify <%team%> friendlyFire false
		team modify <%team%> seeFriendlyInvisibles false
	}
}

LOOP(['a','b'],team) {
	dir <%team%> {
		function summon_drone {
			execute at @e[type=marker,tag=hive,tag=team_<%team%>] run {
				function drones:summon
				team join <%team%> @e[type=bee,tag=drone,distance=..2]
			}
		}
		function summon_soldier {
			execute at @e[type=marker,tag=hive,tag=team_<%team%>] run {
				function soldiers:summon
				team join <%team%> @e[type=bee,tag=soldier,distance=..2]
			}
		}
		# function debug_summon_drone {
		# 	execute at @e[type=marker,tag=hive,tag=team_<%team%>] run {
		# 		LOOP(50,i){
		# 			function drones:summon
		# 		}
		# 		team join <%team%> @e[type=bee,tag=drone,distance=..2]
		# 	}
		# }
	}
}
