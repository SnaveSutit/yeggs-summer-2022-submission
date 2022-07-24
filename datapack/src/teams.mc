
function load {
	team add a {"text":"Wasps","color":"dark_gray"}
	team modify a color dark_gray
	team add b {"text":"Bees","color":"yellow"}
	team modify b color yellow
}

LOOP(['a','b'],team) {
	dir <%team%> {
		function join {
			team join <%team%> @s
		}
		function summon_drone {
			execute at @e[type=marker,tag=hive,tag=team_<%team%>] run {
				function drones:summon
				team join <%team%> @e[type=bee,tag=drone,limit=1,distance=..1]
			}
		}
	}
}
