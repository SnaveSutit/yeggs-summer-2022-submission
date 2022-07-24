
LOOP(['basic','hive','pollen'],name) {
	function summon_<%name%> {
		execute align xyz positioned ~.5 ~ ~.5 run summon marker ~ ~ ~ {Tags:['drone_target','<%name%>','new']}
		execute as @e[type=marker,tag=drone_target,tag=new,distance=..1,limit=1] at @s run {
			execute store result score @s id run scoreboard players add last.id i 1
			tag @s remove new
		}
	}
}

