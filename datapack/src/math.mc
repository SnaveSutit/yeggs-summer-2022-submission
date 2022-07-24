import sqrt.mcm
import log.mcm

function load {
	<%%if (!config.storage) config.storage = {}%%>
	<%%config.storage.precision = 1000%%>
}

dir get {
	function direction_this_to_other {
		scoreboard players operation #direction.x v = #other.pos.x v
		scoreboard players operation #direction.y v = #other.pos.y v
		scoreboard players operation #direction.z v = #other.pos.z v
		scoreboard players operation #direction.x v -= #this.pos.x v
		scoreboard players operation #direction.y v -= #this.pos.y v
		scoreboard players operation #direction.z v -= #this.pos.z v
		# log info score #direction.x v
		# log info score #direction.y v
		# log info score #direction.z v
		function math:zzzinternal/direction
	}
	function direction_other_to_this {
		scoreboard players operation #direction.x v = #this.pos.x v
		scoreboard players operation #direction.y v = #this.pos.y v
		scoreboard players operation #direction.z v = #this.pos.z v
		scoreboard players operation #direction.x v -= #other.pos.x v
		scoreboard players operation #direction.y v -= #other.pos.y v
		scoreboard players operation #direction.z v -= #other.pos.z v
		function math:zzzinternal/direction
	}
}

dir zzzinternal {
	function direction {
		scoreboard players operation #sqr_dir.x v = #direction.x v
		scoreboard players operation #sqr_dir.y v = #direction.y v
		scoreboard players operation #sqr_dir.z v = #direction.z v

		scoreboard players operation #sqr_dir.x v /= 1000 v
		scoreboard players operation #sqr_dir.y v /= 1000 v
		scoreboard players operation #sqr_dir.z v /= 1000 v

		scoreboard players operation #sqr_dir.x v *= #sqr_dir.x v
		scoreboard players operation #sqr_dir.y v *= #sqr_dir.y v
		scoreboard players operation #sqr_dir.z v *= #sqr_dir.z v

		scoreboard players operation #sqrt v = #sqr_dir.x v
		scoreboard players operation #sqrt v += #sqr_dir.y v
		scoreboard players operation #sqrt v += #sqr_dir.z v
		function math:sqrt
		# title @a actionbar {"score":{"name":"#sqrt","objective":"v"}}

		# scoreboard players operation #direction.x v *= <%config.storage.precision%> v
		# scoreboard players operation #direction.y v *= <%config.storage.precision%> v
		# scoreboard players operation #direction.z v *= <%config.storage.precision%> v

		scoreboard players operation #direction.x v /= #sqrt v
		scoreboard players operation #direction.y v /= #sqrt v
		scoreboard players operation #direction.z v /= #sqrt v
	}
}

function sqrt {
	sqrt #sqrt v
}

LOOP(['this', 'other'], name) {
	dir <%name%> {
		dir scrub {
			function pos {
				scoreboard players set #<%name%>.pos.x v 0
				scoreboard players set #<%name%>.pos.y v 0
				scoreboard players set #<%name%>.pos.z v 0
			}
			function motion {
				scoreboard players set #<%name%>.motion.x v 0
				scoreboard players set #<%name%>.motion.y v 0
				scoreboard players set #<%name%>.motion.z v 0
			}
		}
		dir get {
			function pos_rounded {
				execute store result score #<%name%>.pos.x v run data get entity @s Pos[0]
				execute store result score #<%name%>.pos.y v run data get entity @s Pos[1]
				execute store result score #<%name%>.pos.z v run data get entity @s Pos[2]
			}
			function pos {
				execute store result score #<%name%>.pos.x v run data get entity @s Pos[0] <%config.storage.precision%>
				execute store result score #<%name%>.pos.y v run data get entity @s Pos[1] <%config.storage.precision%>
				execute store result score #<%name%>.pos.z v run data get entity @s Pos[2] <%config.storage.precision%>
			}
			function motion_rounded {
				execute store result score #<%name%>.motion.x v run data get entity @s Motion[0]
				execute store result score #<%name%>.motion.y v run data get entity @s Motion[1]
				execute store result score #<%name%>.motion.z v run data get entity @s Motion[2]
			}
			function motion {
				execute store result score #<%name%>.motion.x v run data get entity @s Motion[0] <%config.storage.precision%>
				execute store result score #<%name%>.motion.y v run data get entity @s Motion[1] <%config.storage.precision%>
				execute store result score #<%name%>.motion.z v run data get entity @s Motion[2] <%config.storage.precision%>
			}
		}
		dir set {
			function pos_rounded {
				execute store result entity @s Pos[0] double 1 run scoreboard players get #<%name%>.pos.x v
				execute store result entity @s Pos[1] double 1 run scoreboard players get #<%name%>.pos.y v
				execute store result entity @s Pos[2] double 1 run scoreboard players get #<%name%>.pos.z v
			}
			function pos {
				execute store result entity @s Pos[0] double <%1/config.storage.precision%> run scoreboard players get #<%name%>.pos.x v
				execute store result entity @s Pos[1] double <%1/config.storage.precision%> run scoreboard players get #<%name%>.pos.y v
				execute store result entity @s Pos[2] double <%1/config.storage.precision%> run scoreboard players get #<%name%>.pos.z v
			}
			function motion_rounded {
				execute store result entity @s Motion[0] double 1 run scoreboard players get #<%name%>.motion.x v
				execute store result entity @s Motion[1] double 1 run scoreboard players get #<%name%>.motion.y v
				execute store result entity @s Motion[2] double 1 run scoreboard players get #<%name%>.motion.z v
			}
			function motion {
				execute store result entity @s Motion[0] double <%1/config.storage.precision%> run scoreboard players get #<%name%>.motion.x v
				execute store result entity @s Motion[1] double <%1/config.storage.precision%> run scoreboard players get #<%name%>.motion.y v
				execute store result entity @s Motion[2] double <%1/config.storage.precision%> run scoreboard players get #<%name%>.motion.z v
			}
		}
	}
}
