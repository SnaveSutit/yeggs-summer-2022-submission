import ./log.mcm

function load {
	scoreboard objectives add pollen dummy
	scoreboard objectives add target dummy
	scoreboard objectives add path_timer dummy
}

function summon {
	summon bee ~ ~ ~ {Tags:['drone','new'], PersistenceRequired:1b,NoAI:false,Health:20f,Attributes:[{Name:generic.max_health,Base:20}]}
	execute as @e[type=bee,tag=new,distance=..1,limit=1] at @s run {
		execute store result score @s id run scoreboard players add last.id i 1
		scoreboard players set @s pollen 0
		scoreboard players set @s target -1
		tag @s remove new
	}
}

function tick {
	execute as @e[type=bee,tag=drone] at @s run {
		execute (if score @s target matches -1) {
			function math:this/get/motion
			scoreboard players operation #this.motion.x v /= 2 v
			scoreboard players operation #this.motion.y v /= 2 v
			scoreboard players operation #this.motion.z v /= 2 v
			function math:this/set/motion
		} else {
			# Get the position of the target
			tag @s add this.drone
			scoreboard players operation #target v = @s target
			execute as @e[type=marker,tag=drone_target,distance=1..] if score @s id = #target v run {
				tag @s add this.target
				execute as @e[type=bee,tag=this.drone,limit=1] run tp @s ~ ~ ~ facing entity @e[type=marker,tag=this.target,limit=1] feet
				tag @s remove this.target
				function math:other/get/pos
				scoreboard players set #target v -1
			}
			# Remove the target if it is not valid anymore
			title @a actionbar ["x:",{"score":{"name":"#target","objective":"v"}}]
			execute unless score #target v matches -1 run scoreboard players set @s target -1
			function math:this/get/pos
			# Get the direction to the target
			function math:get/direction_this_to_other

			scoreboard players operation #this.motion.x v = #direction.x v
			scoreboard players operation #this.motion.y v = #direction.y v
			scoreboard players operation #this.motion.z v = #direction.z v
			scoreboard players operation #this.motion.x v /= 10 v
			scoreboard players operation #this.motion.y v /= 10 v
			scoreboard players operation #this.motion.z v /= 10 v
			# title @a actionbar ["","x:",{"score":{"name":"#this.motion.x","objective":"v"}}," y:",{"score":{"name":"#this.motion.y","objective":"v"}}," z:",{"score":{"name":"#this.motion.z","objective":"v"}}]
			# log info score #this.motion.x v
			# log info score #this.motion.y v
			# log info score #this.motion.z v
			function math:this/set/motion
			tag @s remove this.drone
		}
	}
}



