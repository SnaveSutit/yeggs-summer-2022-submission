
function load {
	team add a {"text":"Red","color":"red"}
	team modify a color red
	team add b {"text":"Blue","color":"blue"}
	team modify b color blue
	LOOP(['a','b'],team) {
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
	}
}
