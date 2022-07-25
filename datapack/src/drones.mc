import ./log.mcm

function load {
	scoreboard players set #drone.IDLE state 0
	scoreboard players set #drone.CHOOSE_RESOURCE state 1
	scoreboard players set #drone.pollen.GET_TARGET state 2
	scoreboard players set #drone.pollen.GOTO_TARGET state 3
	scoreboard players set #drone.wax.GET_TARGET state 4
	scoreboard players set #drone.wax.GOTO_TARGET state 5
	scoreboard players set #drone.GET_HIVE state 6
	scoreboard players set #drone.GOTO_HIVE state 7
}

function summon {
	summon bee ~ ~ ~ {Tags:['drone','new'], PersistenceRequired:1b,NoAI:false,Health:20f,Attributes:[{Name:generic.max_health,Base:20}],CustomName:'{"text":"Drone"}',CustomNameVisible:true}
	execute as @e[type=bee,tag=new,distance=..1,limit=1] at @s run {
		execute store result score @s id run scoreboard players add last.id i 1
		scoreboard players set @s state 0
		scoreboard players set @s wax 0
		scoreboard players set @s pollen 0
		scoreboard players set @s target -1
		scoreboard players set @s idle_timer 20
		tag @s remove new
	}
}

clock 2s {
	execute as @e[type=bee,tag=drone] run {
		tag @s remove tick_a
		tag @s remove tick_b
	}
	execute store result score #count v if entity @e[type=bee,tag=drone]
	scoreboard players operation #half v = #count v
	scoreboard players operation #half v /= 2 v
	scoreboard players operation #loop v = #half v
	{
		execute as @e[type=bee,tag=drone,tag=!tick_a,tag=!tick_b,limit=1] run tag @s add tick_a
		scoreboard players remove #loop v 1
		execute if score #loop v matches 1.. run function $block
	}
	scoreboard players operation #loop v = #half v
	scoreboard players add #loop v 1
	{
		execute as @e[type=bee,tag=drone,tag=!tick_a,tag=!tick_b,limit=1] run tag @s add tick_b
		scoreboard players remove #loop v 1
		execute if score #loop v matches 1.. run function $block
	}
}

clock 2t {
	execute store success score #drone.tick_flipflop v if score #drone.tick_flipflop v matches 0
	execute if score #drone.tick_flipflop v matches 0 as @e[type=bee,tag=drone,tag=tick_a] at @s run function drones:state_tick
	execute if score #drone.tick_flipflop v matches 1 as @e[type=bee,tag=drone,tag=tick_b] at @s run function drones:state_tick
}

clock 2t {
	execute as @e[type=bee,tag=drone] at @s run {
		execute if score @s state = #drone.pollen.GOTO_TARGET state run function drones:update_rotation
		execute if score @s state = #drone.wax.GOTO_TARGET state run function drones:update_rotation
		execute if score @s state = #drone.GOTO_HIVE state run function drones:update_rotation
	}
}

clock 1t {
	execute as @e[type=bee,tag=drone] at @s run {
		execute if score @s state = #drone.pollen.GOTO_TARGET state run function drones:apply_motion
		execute if score @s state = #drone.wax.GOTO_TARGET state run function drones:apply_motion
		execute if score @s state = #drone.GOTO_HIVE state run function drones:apply_motion
	}
}

function state_tick {
	execute if score @s state = #drone.IDLE state run {
		scoreboard players remove @s idle_timer 1
		execute if score @s idle_timer matches ..0 run scoreboard players operation @s state = #drone.CHOOSE_RESOURCE state
	}

	execute if score @s state = #drone.CHOOSE_RESOURCE state run {
		execute (if entity @e[type=marker,tag=gen.wax,scores={wax=1..}]) {
			scoreboard players operation @s state = #drone.wax.GET_TARGET state
			# say Collecting wax

		} else execute (if entity @e[type=marker,tag=gen.pollen,scores={pollen=10..}]) {
			scoreboard players operation @s state = #drone.pollen.GET_TARGET state
			# say Collecting pollen

		} else {
			# If there is no pollen or wax currently in stock, and this bee has cargo, return to the hive.
			execute if score @s wax matches 1.. run scoreboard players operation @s state = #drone.GET_HIVE state
			execute if score @s pollen matches 1.. run scoreboard players operation @s state = #drone.GET_HIVE state
			# Else, wander around a bit
			execute if score @s wax matches 0 if score @s pollen matches 0 run {
				scoreboard players set @s idle_timer 20
				scoreboard players operation @s state = #drone.IDLE state
			}
		}
	}

	LOOP(['pollen', 'wax'],resource) {
		execute if score @s state = #drone.<%resource%>.GET_TARGET state run {
			LOOP(['a','b'],team){
				execute if entity @s[team=<%team%>] run {
					execute (if entity @e[type=marker,tag=gen.<%resource%>,scores={<%resource%>=<%resource.length*2%>..},tag=captured_by_<%team%>]) {
						execute as @e[type=marker,tag=gen.<%resource%>,sort=random,scores={<%resource%>=<%resource.length*2%>..},tag=captured_by_<%team%>] at @s run {
							scoreboard players operation #target v = @e[type=marker,tag=drone_target,tag=<%resource%>,distance=..1,limit=1] id
						}
						scoreboard players operation @s target = #target v
						scoreboard players operation @s state = #drone.<%resource%>.GOTO_TARGET state
						# say <%team%> <%resource%> found
						# tellraw @a {"score":{"name":"@s","objective":"state"}}
					} else {
						# say <%team%> <%resource%> not found
						# If no target was found, then return to choose resource state
						scoreboard players operation @s state = #drone.CHOOSE_RESOURCE state
					}
				}
			}
		}

		execute if score @s state = #drone.<%resource%>.GOTO_TARGET state run {
			execute if entity @e[type=marker,tag=gen.<%resource%>,distance=..1] run {
				tag @s add this.drone
				scoreboard players set #collected v 0
				scoreboard players set #space v <%resource.length*2%>
				scoreboard players operation #space v -= @s <%resource%>
				execute as @e[type=marker,tag=gen.<%resource%>,distance=..1,limit=1] run {
					execute if score @s <%resource%> >= #space v run {
						scoreboard players operation @s <%resource%> -= #space v
						# say Collected <%resource%>!
						scoreboard players set #collected v 1
					}
				}
				# If no resources were collected, find another resource node.
				execute if score #collected v matches 0 run scoreboard players operation @s state = #drone.CHOOSE_RESOURCE state
				execute if score #collected v matches 1 run {
					scoreboard players operation @s state = #drone.GET_HIVE state
					scoreboard players operation @s <%resource%> += #space v
					data modify entity @s HasNectar set value true
				}
				tag @s remove this.drone
			}
			function drones:set_motion
		}
	}

	execute if score @s state = #drone.GET_HIVE state run {
		execute (if entity @e[type=marker,tag=hive]) {
			LOOP(['a','b'], team) {
				execute if entity @s[team=<%team%>] run {
					execute as @e[type=marker,tag=hive,tag=team_<%team%>] at @s run {
						scoreboard players operation #target v = @e[type=marker,tag=drone_target,tag=hive,distance=..1,limit=1] id
					}
					scoreboard players operation @s target = #target v
					scoreboard players operation @s state = #drone.GOTO_HIVE state
				}
			}
			# say Returning to hive!
		} else {
			# If no target was found, then yell about it
			say No hive found!
		}
	}

	execute if score @s state = #drone.GOTO_HIVE state run {
		scoreboard players set #deposited v 0
		execute if entity @e[type=marker,tag=hive,distance=..1] run {
			# say Deposited resources!
			scoreboard players set #deposited v 1
		}
		execute if score #deposited v matches 1 run {
			scoreboard players set @s wax 0
			scoreboard players set @s pollen 0
			scoreboard players set @s idle_timer 20
			scoreboard players operation @s state = #drone.IDLE state
			data modify entity @s HasNectar set value false
			LOOP(['a','b'],team){
				execute if entity @s[team=<%team%>] run scoreboard players add .team_<%team%> honey 1
			}
		}
		function drones:set_motion
	}
}

function update_rotation {
	scoreboard players operation # v = @s target
	tag @s add this.drone
	execute as @e[type=marker,tag=drone_target] if score @s id = # v run {
		tag @s add this.target
		# tp @e[type=bee,tag=this.drone,distance=..1,limit=1] ~ ~ ~ facing entity @s feet
		execute as @e[type=bee,tag=this.drone,distance=..1,limit=1] at @s anchored eyes facing entity @e[type=marker,tag=this.target] feet positioned ^ ^ ^0.5 rotated as @s positioned ^ ^ ^1 facing entity @s eyes facing ^ ^ ^-1 positioned as @s rotated ~ 0 run tp @s ~ ~ ~ ~1 ~
		tag @s remove this.target
	}
	tag @s remove this.drone
}

function set_motion {
	function math:this/get/pos
	scoreboard players operation # v = @s target
	tag @s add this.drone
	execute as @e[type=marker,tag=drone_target] if score @s id = # v run function math:other/get/pos
	tag @s remove this.drone
	function math:get/direction_this_to_other
	function math:this/get/motion
	scoreboard players operation #direction.x v /= 30 v
	scoreboard players operation #direction.y v /= 20 v
	scoreboard players operation #direction.z v /= 30 v
	scoreboard players operation #this.motion.x v += #direction.x v
	scoreboard players operation #this.motion.y v += #direction.y v
	scoreboard players operation #this.motion.z v += #direction.z v

	execute at @s rotated ~ 0 unless block ^ ^ ^10 air run scoreboard players add #this.motion.y v 10
	execute at @s rotated ~ 0 unless block ~ ~-2 ~ air run scoreboard players add #this.motion.y v 10

	scoreboard players operation @s motion.x = #this.motion.x v
	scoreboard players operation @s motion.y = #this.motion.y v
	scoreboard players operation @s motion.z = #this.motion.z v
	# title @a actionbar ["","x:",{"score":{"name":"#this.pos.x","objective":"v"}}," y:",{"score":{"name":"#this.pos.y","objective":"v"}}," z:",{"score":{"name":"#this.pos.z","objective":"v"}}]
	# title @a actionbar ["","x:",{"score":{"name":"#this.motion.x","objective":"v"}}," y:",{"score":{"name":"#this.motion.y","objective":"v"}}," z:",{"score":{"name":"#this.motion.z","objective":"v"}}]
}

function apply_motion {
	scoreboard players operation #this.motion.x v = @s motion.x
	scoreboard players operation #this.motion.y v = @s motion.y
	scoreboard players operation #this.motion.z v = @s motion.z
	function math:this/set/motion
}

# clock 2t {
# 	execute as @e[type=bee,tag=drone] at @s run {
# 		execute (if score @s target matches -1) {
# 			# function math:this/get/motion
# 			# scoreboard players operation #this.motion.x v /= 2 v
# 			# scoreboard players operation #this.motion.y v /= 2 v
# 			# scoreboard players operation #this.motion.z v /= 2 v
# 			# function math:this/set/motion

# 		execute if score @s pollen matches 10.. if entity @e[type=marker,tag=hive,dx=0,dy=0,dz=0] run {
# 			scoreboard players set @s pollen 0
# 			data modify entity @s HasNectar set value false
# 			tellraw @a {"text":"Deposited 10 pollen!"}
# 		}

# 		execute (if score @s target_cooldown matches 1..) {
# 			scoreboard players remove @s target_cooldown 1
# 		} else {
# 			execute if score @s pollen matches 10.. run {
# 				execute as @e[type=marker,tag=hive] run {
# 					scoreboard players operation #hive v = @s id
# 				}
# 				scoreboard players operation @s target = #hive v
# 			}
# 			execute if score @s pollen matches ..9 run {
# 				execute if entity @e[type=marker,tag=gen.pollen,scores={pollen=10..}] run {
# 					execute as @e[type=marker,tag=gen.pollen,sort=random,scores={pollen=10..},limit=1] at @s as @e[type=marker,tag=drone_target,distance=..1,limit=1] run {
# 						scoreboard players operation #pollen v = @s id
# 					}
# 					scoreboard players operation @s target = #pollen v
# 				}
# 			}
# 			scoreboard players set @s target_cooldown 60
# 		}

# 		} else {
# 			# Get the position of the target
# 			tag @s add this.drone
# 			scoreboard players operation #target v = @s target
# 			execute as @e[type=marker,tag=drone_target,distance=1..] if score @s id = #target v run {
# 				tag @s add this.target
# 				execute as @e[type=bee,tag=this.drone,limit=1] run tp @s ~ ~ ~ facing entity @e[type=marker,tag=this.target,limit=1] feet
# 				tag @s remove this.target
# 				function math:other/get/pos
# 				scoreboard players set #target v -1
# 			}
# 			# Remove the target if it is not valid anymore
# 			title @a actionbar [{"score":{"name":"#target","objective":"v"}}]
# 			execute unless score #target v matches -1 run scoreboard players set @s target -1
# 			function math:this/get/pos
# 			# Get the direction to the target
# 			function math:get/direction_this_to_other

# 			function math:this/get/motion
# 			scoreboard players operation #direction.x v /= 12 v
# 			scoreboard players operation #direction.y v /= 12 v
# 			scoreboard players operation #direction.z v /= 12 v
# 			scoreboard players operation #this.motion.x v += #direction.x v
# 			scoreboard players operation #this.motion.y v += #direction.y v
# 			scoreboard players operation #this.motion.z v += #direction.z v
# 			# title @a actionbar ["","x:",{"score":{"name":"#this.motion.x","objective":"v"}}," y:",{"score":{"name":"#this.motion.y","objective":"v"}}," z:",{"score":{"name":"#this.motion.z","objective":"v"}}]
# 			# log info score #this.motion.x v
# 			# log info score #this.motion.y v
# 			# log info score #this.motion.z v
# 			function math:this/set/motion
# 			tag @s remove this.drone
# 		}
# 	}
# }

