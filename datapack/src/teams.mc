
function load {
	team add a {"text":"Red","color":"red"}
	team modify a color red
	team add b {"text":"Blue","color":"blue"}
	team modify b color blue

	bossbar add swarm_a ["",{"text":"Red Swarm","color":"red"}]
	bossbar set minecraft:swarm_a color red
	bossbar add swarm_b ["",{"text":"Blue Swarm","color":"blue"}]
	bossbar set minecraft:swarm_b color blue

	LOOP(['a','b'],team) {
		bossbar set minecraft:swarm_<%team%> max 20

		team modify <%team%> friendlyFire false
		team modify <%team%> seeFriendlyInvisibles false
	}
}

LOOP(['a','b'],team) {
	dir <%team%> {
		function join {
			team join <%team%> @s
		}
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
		function debug_summon_drone {
			execute at @e[type=marker,tag=hive,tag=team_<%team%>] run {
				LOOP(50,i){
					function drones:summon
				}
				team join <%team%> @e[type=bee,tag=drone,distance=..2]
			}
		}
	}
}
