function reset_animation_flags {
	scoreboard players set .aj.animation aj.haha_bee.animating 0
	scoreboard players set .aj.anim_loop aj.haha_bee.animating 0
	scoreboard players set .noScripts aj.i 0
}
function assert_animation_flags {
	scoreboard players add .aj.animation aj.haha_bee.animating 0
	scoreboard players add .aj.anim_loop aj.haha_bee.animating 0
	scoreboard players add .noScripts aj.i 0
}
function install {
	scoreboard objectives add aj.i dummy
	scoreboard objectives add aj.id dummy
	scoreboard objectives add aj.frame dummy
	scoreboard objectives add aj.haha_bee.animating dummy
	scoreboard objectives add aj.haha_bee.idle.loopMode dummy
	function haha_bee:reset_animation_flags
	scoreboard players set #uninstall aj.i 0
	scoreboard players set .aj.haha_bee.framerate aj.i 1
	tellraw @a [{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"aqua"},{"text":" → ","color":"gray"},{"text":"Install ⊻","color":"green"},{"text":" ]","color":"dark_gray"},"\n",{"text":"Installed ","color":"gray"},{"text":"armor_stand","color":"gold"},{"text":" rig.","color":"gray"},"\n",{"text":"◘ ","color":"gray"},{"text":"Included Scoreboard Objectives:","color":"green"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.i","color":"aqua"},{"text":" (Internal)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.id","color":"aqua"},{"text":" (ID)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.frame","color":"aqua"},{"text":" (Frame)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.haha_bee.animating","color":"aqua"},{"text":" (Animation Flag)","color":"dark_gray"},[["\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.haha_bee.idle.loopMode","color":"aqua"},{"text":" (Loop Mode)","color":"dark_gray"}]]]
}
function uninstall {
	scoreboard objectives remove aj.haha_bee.animating
	scoreboard objectives remove aj.haha_bee.idle.loopMode
	scoreboard players set #uninstall aj.i 1
	tellraw @a [{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"aqua"},{"text":" → ","color":"gray"},{"text":"Uninstall ⊽","color":"red"},{"text":" ]","color":"dark_gray"},"\n",{"text":"Uninstalled ","color":"gray"},{"text":"armor_stand","color":"gold"},{"text":" rig specific scoreboards","color":"gray"},"\n",{"text":"◘ ","color":"gray"},{"text":"Included Scoreboard Objectives:","color":"green"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.haha_bee.animating","color":"aqua"},{"text":" (Animation Flag)","color":"dark_gray"},[["\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.haha_bee.idle.loopMode","color":"aqua"},{"text":" (Loop Mode)","color":"dark_gray"}]],"\n","\n",{"text":"◘ ","color":"gray"},{"text":"Do you wish to uninstall all AJ related scoreboard objectives added by this rig?","color":"green"},"\n",{"text":"[Yes]","color":"green","clickEvent":{"action":"run_command","value":"/function haha_bee:uninstall/remove_aj_related"}},{"text":" [No]","color":"red","clickEvent":{"action":"run_command","value":"/function haha_bee:uninstall/keep_aj_related"}}]
}
dir uninstall {
	function keep_aj_related {
		execute if score #uninstall aj.i matches 0 run tellraw @a [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"Uninstall not in-progress. Please run","color":"gray"},"\n",{"text":" function haha_bee:uninstall","color":"red"},"\n",{"text":" to start the uninstallation process.","color":"gray"}]
		execute if score #uninstall aj.i matches 1 run {
			scoreboard players set #uninstall aj.i 0
			tellraw @a [{"text":"Keeping AJ specific scoreboard objectives.","color":"green"}]
		}
	}
	function remove_aj_related {
		execute if score #uninstall aj.i matches 0 run tellraw @a [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"Uninstall not in-progress. Please run","color":"gray"},"\n",{"text":" function haha_bee:uninstall","color":"red"},"\n",{"text":" to start the uninstallation process.","color":"gray"}]
		execute if score #uninstall aj.i matches 1 run {
			scoreboard players set #uninstall aj.i 0
			scoreboard objectives remove aj.i
			scoreboard objectives remove aj.id
			scoreboard objectives remove aj.frame
			tellraw @a [{"text":"Removed AJ specific scoreboard objectives:","color":"green"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.i","color":"aqua"},{"text":" (Internal)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.id","color":"aqua"},{"text":" (ID)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.frame","color":"aqua"},{"text":" (Frame)","color":"dark_gray"}]
		}
	}
}
entities bone_entities {
	minecraft:area_effect_cloud
	minecraft:armor_stand
}
dir remove {
	function all {
		kill @e[type=minecraft:marker,tag=aj.haha_bee]
		kill @e[type=#haha_bee:bone_entities,tag=aj.haha_bee]
	}
	function this {
		execute (if entity @s[tag=aj.haha_bee.root] at @s) {
			scoreboard players operation # aj.id = @s aj.id
			execute as @e[type=#haha_bee:bone_entities,tag=aj.haha_bee,distance=..5.629] if score @s aj.id = # aj.id run kill @s
			kill @s
		} else {
			tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:remove/this ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
		}
	}
}
dir summon {
	function default {
		# Summon Root Entity
		summon minecraft:marker ~ ~ ~ {Tags:['new','aj.haha_bee','aj.haha_bee.root']}
		# Execute as summoned root
		execute as @e[type=minecraft:marker,tag=aj.haha_bee.root,tag=new,distance=..1,limit=1] rotated ~ 0 run {
			# Copy the execution position and rotation onto the root
			tp @s ~ ~ ~ ~ ~
			# Get an ID for this rig
			execute store result score @s aj.id run scoreboard players add .aj.last_id aj.i 1
			# Execute at updated location
			execute at @s run {
				# Summon all bone entities
				summon minecraft:area_effect_cloud ^0 ^-1.788 ^0 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.haha_bee','aj.haha_bee.bone','aj.haha_bee.bone.body'],Passengers:[{id:'minecraft:armor_stand',Fire:32767,Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.haha_bee','aj.haha_bee.bone','aj.haha_bee.bone.body','aj.haha_bee.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:yellow_dye',Count:1b,tag:{CustomModelData:1}}],Pose:{Head:[0f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^-0.09375 ^-1.3505 ^0.1875 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.haha_bee','aj.haha_bee.bone','aj.haha_bee.bone.rightwing_bone'],Passengers:[{id:'minecraft:armor_stand',Fire:32767,Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.haha_bee','aj.haha_bee.bone','aj.haha_bee.bone.rightwing_bone','aj.haha_bee.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:yellow_dye',Count:1b,tag:{CustomModelData:2}}],Pose:{Head:[0f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^0.09375 ^-1.3505 ^0.1875 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.haha_bee','aj.haha_bee.bone','aj.haha_bee.bone.leftwing_bone'],Passengers:[{id:'minecraft:armor_stand',Fire:32767,Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.haha_bee','aj.haha_bee.bone','aj.haha_bee.bone.leftwing_bone','aj.haha_bee.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:yellow_dye',Count:1b,tag:{CustomModelData:3}}],Pose:{Head:[0f,0f,0f]}}]}
				# Update rotation and ID of bone entities to match the root entity
				execute as @e[type=#haha_bee:bone_entities,tag=aj.haha_bee,tag=new,distance=..5.629] positioned as @s run {
					scoreboard players operation @s aj.id = .aj.last_id aj.i
					tp @s ~ ~ ~ ~ ~
					tag @s remove new
				}
			}
			tag @s remove new
			# Set all animation modes to configured default
			scoreboard players set @s aj.haha_bee.idle.loopMode 2
			scoreboard players set @s aj.frame 0
			scoreboard players set @s aj.haha_bee.animating 0
		}
		# Assert animation flags
		function haha_bee:assert_animation_flags
	}
}
# Resets the model to it's initial summon position/rotation and stops all active animations
function reset {
	# Make sure this function has been ran as the root entity
	execute(if entity @s[tag=aj.haha_bee.root] at @s rotated ~ 0) {
		# Remove all animation tags
		tag @s remove aj.haha_bee.anim.idle
		# Reset animation time
		scoreboard players set @s aj.frame 0
		scoreboard players operation .this aj.id = @s aj.id
		execute as @e[type=minecraft:area_effect_cloud,tag=aj.haha_bee.bone,distance=..5.629] if score @s aj.id = .this aj.id run {
			tp @s[tag=aj.haha_bee.bone.body] ^0 ^-1.788 ^0
			tp @s[tag=aj.haha_bee.bone.rightwing_bone] ^-0.094 ^-1.35 ^0.188
			tp @s[tag=aj.haha_bee.bone.leftwing_bone] ^0.094 ^-1.35 ^0.188
			execute store result score .calc aj.i run data get entity @s Air
			execute store result entity @s Air short 1 run scoreboard players add .calc aj.i 2
		}
		execute as @e[type=minecraft:armor_stand,tag=aj.haha_bee.bone,distance=..5.629] if score @s aj.id = .this aj.id run {
			data modify entity @s[tag=aj.haha_bee.bone.body] Pose.Head set value [0f,0f,0f]
			data modify entity @s[tag=aj.haha_bee.bone.rightwing_bone] Pose.Head set value [0f,0f,0f]
			data modify entity @s[tag=aj.haha_bee.bone.leftwing_bone] Pose.Head set value [0f,0f,0f]
			tp @s ~ ~ ~ ~ ~
		}
		# If this entity is not the root
	} else {
		tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:reset ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
	}
}
function move {
	# Make sure this function has been ran as the root entity
	execute(if entity @s[tag=aj.haha_bee.root] rotated ~ 0) {
		tp @s ~ ~ ~ ~ ~
		scoreboard players operation .this aj.id = @s aj.id
		scoreboard players operation .this aj.frame = @s aj.frame
		# Split based on animation name
		scoreboard players set # aj.i 0
		execute if entity @s[tag=aj.haha_bee.anim.idle] run {
			scoreboard players set # aj.i 1
			# Select bone entities
			execute at @s as @e[type=#haha_bee:bone_entities,tag=aj.haha_bee.bone] if score @s aj.id = .this aj.id run {
				# Split based on bone entity type
				execute if entity @s[type=minecraft:area_effect_cloud] run {
					# Run root animation frame tree
					function haha_bee:animations/idle/tree/root_bone_name
					execute store result score .calc aj.i run data get entity @s Air
					execute store result entity @s Air short 1 run scoreboard players add .calc aj.i 2
				}
				execute if entity @s[type=minecraft:armor_stand] run tp @s ~ ~ ~ ~ ~
			}
		}
		execute if score # aj.i matches 0 run {
			execute at @s as @e[type=minecraft:area_effect_cloud,tag=aj.haha_bee.bone] if score @s aj.id = .this aj.id run tp @s ~ ~ ~
			function haha_bee:reset
		}
		# If this entity is not the root
	} else {
		tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:move ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
	}
}
function animation_loop {
	# Schedule clock
	schedule function haha_bee:animation_loop 1t
	# Set anim_loop active flag to true
	scoreboard players set .aj.anim_loop aj.haha_bee.animating 1
	# Reset animating flag (Used internally to check if any animations have ticked during this tick)
	scoreboard players set .aj.animation aj.haha_bee.animating 0
	# Run animations that are active on the entity
	execute as @e[type=minecraft:marker,tag=aj.haha_bee.root] run{
		execute if entity @s[tag=aj.haha_bee.anim.idle] at @s run function haha_bee:animations/idle/next_frame
		scoreboard players operation @s aj.haha_bee.animating = .aj.animation aj.haha_bee.animating
	}
	# Stop the anim_loop clock if no models are animating
	execute if score .aj.animation aj.haha_bee.animating matches 0 run {
		# Stop anim_loop shedule clock
		schedule clear haha_bee:animation_loop
		# Set anim_loop active flag to false
		scoreboard players set .aj.anim_loop aj.haha_bee.animating 0
	}
}
dir animations {
	dir idle {
		# Starts the animation from the first frame
		function play {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.haha_bee.root] at @s) {
				# Add animation tag
				tag @s add aj.haha_bee.anim.idle
				# Reset animation time
				execute if score .aj.haha_bee.framerate aj.i matches ..-1 run scoreboard players set @s aj.frame 57
				execute if score .aj.haha_bee.framerate aj.i matches 1.. run scoreboard players set @s aj.frame 0
				# Assert that .noScripts is tracked properly
				scoreboard players add .noScripts aj.i 0
				# Start the animation loop if not running
				execute if score .aj.anim_loop aj.haha_bee.animating matches 0 run function haha_bee:animation_loop
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:animations/idle/play ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
			}
		}
		# Stops the animation and resets to first frame
		function stop {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.haha_bee.root] at @s) {
				# Add animation tag
				tag @s remove aj.haha_bee.anim.idle
				# Reset animation time
				scoreboard players set @s aj.frame 0
				# load initial animation frame without running scripts
				scoreboard players operation .oldValue aj.i = .noScripts aj.i
				scoreboard players set .noScripts aj.i 1
				function haha_bee:animations/idle/next_frame
				scoreboard players operation .noScripts aj.i = .oldValue aj.i
				# Reset animation time
				scoreboard players set @s aj.frame 0
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:animations/idle/stop ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
			}
		}
		# Pauses the animation on the current frame
		function pause {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.haha_bee.root] at @s) {
				# Remove animation tag
				tag @s remove aj.haha_bee.anim.idle
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:animations/idle/pause ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
			}
		}
		# Resumes the animation from the current frame
		function resume {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.haha_bee.root]) {
				# Remove animation tag
				tag @s add aj.haha_bee.anim.idle
				# Start the animation loop
				execute if score .aj.anim_loop aj.haha_bee.animating matches 0 run function haha_bee:animation_loop
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"haha_bee:animations/idle/resume ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.haha_bee.root]","color":"light_purple"}]
			}
		}
		# Plays the next frame in the animation
		function next_frame {
			scoreboard players operation .this aj.id = @s aj.id
			scoreboard players operation .this aj.frame = @s aj.frame
			execute rotated ~ 0 as @e[type=#haha_bee:bone_entities,tag=aj.haha_bee.bone,distance=..3.8160000000000003] if score @s aj.id = .this aj.id run {
				name tree/trunk
				# Bone Roots
				execute if entity @s[type=minecraft:area_effect_cloud] run {
					name tree/root_bone_name
					execute if entity @s[tag=aj.haha_bee.bone.body] run {
						name tree/body_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/body_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/body_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^0 ^-1.788 ^0 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^0 ^-1.774 ^0 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^0 ^-1.76 ^0 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^0 ^-1.747 ^0 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^0 ^-1.734 ^0 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^0 ^-1.722 ^0 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^0 ^-1.71 ^0 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^0 ^-1.7 ^0 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/body_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^0 ^-1.691 ^0 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^0 ^-1.682 ^0 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^0 ^-1.676 ^0 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^0 ^-1.67 ^0 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^0 ^-1.666 ^0 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^0 ^-1.664 ^0 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^0 ^-1.663 ^0 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^0 ^-1.664 ^0 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/body_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^0 ^-1.666 ^0 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^0 ^-1.67 ^0 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^0 ^-1.675 ^0 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^0 ^-1.682 ^0 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^0 ^-1.689 ^0 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^0 ^-1.699 ^0 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^0 ^-1.709 ^0 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^0 ^-1.72 ^0 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/body_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^0 ^-1.732 ^0 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^0 ^-1.745 ^0 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^0 ^-1.759 ^0 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^0 ^-1.772 ^0 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^0 ^-1.786 ^0 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^0 ^-1.8 ^0 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^0 ^-1.814 ^0 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^0 ^-1.827 ^0 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/body_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^0 ^-1.84 ^0 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^0 ^-1.853 ^0 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^0 ^-1.864 ^0 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^0 ^-1.875 ^0 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^0 ^-1.884 ^0 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^0 ^-1.893 ^0 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^0 ^-1.9 ^0 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^0 ^-1.905 ^0 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/body_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^0 ^-1.909 ^0 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^0 ^-1.912 ^0 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^0 ^-1.913 ^0 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^0 ^-1.912 ^0 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^0 ^-1.91 ^0 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^0 ^-1.907 ^0 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^0 ^-1.902 ^0 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^0 ^-1.895 ^0 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/body_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^0 ^-1.888 ^0 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^0 ^-1.879 ^0 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^0 ^-1.868 ^0 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^0 ^-1.857 ^0 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^0 ^-1.845 ^0 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^0 ^-1.832 ^0 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^0 ^-1.819 ^0 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^0 ^-1.805 ^0 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^0 ^-1.791 ^0 ~ ~
						}
					}
					execute if entity @s[tag=aj.haha_bee.bone.rightwing_bone] run {
						name tree/rightwing_bone_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/rightwing_bone_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/rightwing_bone_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^-0.094 ^-1.357 ^0.203 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^-0.094 ^-1.342 ^0.199 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^-0.094 ^-1.327 ^0.197 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^-0.094 ^-1.313 ^0.195 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^-0.094 ^-1.3 ^0.195 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^-0.094 ^-1.288 ^0.197 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^-0.094 ^-1.278 ^0.199 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^-0.094 ^-1.269 ^0.203 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/rightwing_bone_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^-0.094 ^-1.261 ^0.206 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^-0.094 ^-1.255 ^0.208 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^-0.094 ^-1.248 ^0.21 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^-0.094 ^-1.243 ^0.21 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^-0.094 ^-1.238 ^0.209 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^-0.094 ^-1.235 ^0.206 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^-0.094 ^-1.232 ^0.203 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^-0.094 ^-1.232 ^0.2 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/rightwing_bone_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^-0.094 ^-1.233 ^0.197 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^-0.094 ^-1.236 ^0.195 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^-0.094 ^-1.241 ^0.195 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^-0.094 ^-1.248 ^0.197 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^-0.094 ^-1.257 ^0.199 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^-0.094 ^-1.268 ^0.202 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^-0.094 ^-1.28 ^0.206 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^-0.094 ^-1.292 ^0.208 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/rightwing_bone_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^-0.094 ^-1.305 ^0.21 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^-0.094 ^-1.318 ^0.21 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^-0.094 ^-1.331 ^0.209 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^-0.094 ^-1.343 ^0.206 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^-0.094 ^-1.356 ^0.203 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^-0.094 ^-1.368 ^0.2 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^-0.094 ^-1.381 ^0.197 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^-0.094 ^-1.393 ^0.195 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/rightwing_bone_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^-0.094 ^-1.406 ^0.195 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^-0.094 ^-1.419 ^0.196 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^-0.094 ^-1.432 ^0.199 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^-0.094 ^-1.444 ^0.202 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^-0.094 ^-1.455 ^0.205 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^-0.094 ^-1.465 ^0.208 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^-0.094 ^-1.472 ^0.21 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^-0.094 ^-1.478 ^0.21 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/rightwing_bone_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^-0.094 ^-1.482 ^0.209 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^-0.094 ^-1.483 ^0.206 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^-0.094 ^-1.483 ^0.203 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^-0.094 ^-1.481 ^0.2 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^-0.094 ^-1.477 ^0.197 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^-0.094 ^-1.473 ^0.195 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^-0.094 ^-1.468 ^0.195 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^-0.094 ^-1.462 ^0.196 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/rightwing_bone_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^-0.094 ^-1.455 ^0.199 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^-0.094 ^-1.447 ^0.202 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^-0.094 ^-1.439 ^0.205 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^-0.094 ^-1.429 ^0.208 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^-0.094 ^-1.418 ^0.21 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^-0.094 ^-1.405 ^0.21 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^-0.094 ^-1.391 ^0.209 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^-0.094 ^-1.377 ^0.207 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^-0.094 ^-1.361 ^0.203 ~ ~
						}
					}
					execute if entity @s[tag=aj.haha_bee.bone.leftwing_bone] run {
						name tree/leftwing_bone_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/leftwing_bone_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/leftwing_bone_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^0.094 ^-1.357 ^0.203 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^0.094 ^-1.342 ^0.199 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^0.094 ^-1.327 ^0.197 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^0.094 ^-1.313 ^0.195 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^0.094 ^-1.3 ^0.195 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^0.094 ^-1.288 ^0.197 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^0.094 ^-1.278 ^0.199 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^0.094 ^-1.269 ^0.203 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/leftwing_bone_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^0.094 ^-1.261 ^0.206 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^0.094 ^-1.255 ^0.208 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^0.094 ^-1.248 ^0.21 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^0.094 ^-1.243 ^0.21 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^0.094 ^-1.238 ^0.209 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^0.094 ^-1.235 ^0.206 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^0.094 ^-1.232 ^0.203 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^0.094 ^-1.232 ^0.2 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/leftwing_bone_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^0.094 ^-1.233 ^0.197 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^0.094 ^-1.236 ^0.195 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^0.094 ^-1.241 ^0.195 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^0.094 ^-1.248 ^0.197 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^0.094 ^-1.257 ^0.199 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^0.094 ^-1.268 ^0.202 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^0.094 ^-1.28 ^0.206 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^0.094 ^-1.292 ^0.208 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/leftwing_bone_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^0.094 ^-1.305 ^0.21 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^0.094 ^-1.318 ^0.21 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^0.094 ^-1.331 ^0.209 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^0.094 ^-1.343 ^0.206 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^0.094 ^-1.356 ^0.203 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^0.094 ^-1.368 ^0.2 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^0.094 ^-1.381 ^0.197 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^0.094 ^-1.393 ^0.195 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/leftwing_bone_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^0.094 ^-1.406 ^0.195 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^0.094 ^-1.419 ^0.196 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^0.094 ^-1.432 ^0.199 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^0.094 ^-1.444 ^0.202 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^0.094 ^-1.455 ^0.205 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^0.094 ^-1.465 ^0.208 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^0.094 ^-1.472 ^0.21 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^0.094 ^-1.478 ^0.21 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/leftwing_bone_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^0.094 ^-1.482 ^0.209 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^0.094 ^-1.483 ^0.206 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^0.094 ^-1.483 ^0.203 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^0.094 ^-1.481 ^0.2 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^0.094 ^-1.477 ^0.197 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^0.094 ^-1.473 ^0.195 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^0.094 ^-1.468 ^0.195 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^0.094 ^-1.462 ^0.196 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/leftwing_bone_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^0.094 ^-1.455 ^0.199 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^0.094 ^-1.447 ^0.202 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^0.094 ^-1.439 ^0.205 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^0.094 ^-1.429 ^0.208 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^0.094 ^-1.418 ^0.21 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^0.094 ^-1.405 ^0.21 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^0.094 ^-1.391 ^0.209 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^0.094 ^-1.377 ^0.207 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^0.094 ^-1.361 ^0.203 ~ ~
						}
					}
					execute store result entity @s Air short 1 run scoreboard players get .this aj.frame
				}
				# Bone Displays
				execute if entity @s[type=minecraft:armor_stand] run {
					name tree/display_bone_name
					execute if entity @s[tag=aj.haha_bee.bone.body] run {
						name tree/body_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/body_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/body_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [2f,0f,0f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [1.5679f,0f,0f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [1.2207f,0f,0f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [1.0264f,0f,0f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [1.0233f,0f,0f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [1.212f,0f,0f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [1.5554f,0f,0f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [1.986f,0f,0f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/body_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [2.4195f,0f,0f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [2.7705f,0f,0f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [2.9703f,0f,0f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [2.9796f,0f,0f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [2.7965f,0f,0f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [2.4571f,0f,0f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [2.0279f,0f,0f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [1.5933f,0f,0f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/body_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [1.2385f,0f,0f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [1.0332f,0f,0f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [1.0177f,0f,0f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [1.1951f,0f,0f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [1.5305f,0f,0f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [1.9581f,0f,0f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [2.3939f,0f,0f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [2.7524f,0f,0f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/body_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [2.9632f,0f,0f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [2.9848f,0f,0f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [2.8131f,0f,0f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [2.4818f,0f,0f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [2.0558f,0f,0f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [1.6189f,0f,0f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [1.2569f,0f,0f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [1.0407f,0f,0f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/body_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [1.0129f,0f,0f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [1.1789f,0f,0f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [1.5061f,0f,0f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [1.9302f,0f,0f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [2.3681f,0f,0f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [2.7337f,0f,0f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [2.9553f,0f,0f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [2.9893f,0f,0f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/body_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [2.829f,0f,0f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [2.506f,0f,0f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [2.0837f,0f,0f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [1.6449f,0f,0f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [1.2758f,0f,0f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [1.0489f,0f,0f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [1.0088f,0f,0f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [1.1632f,0f,0f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/body_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [1.482f,0f,0f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [1.9024f,0f,0f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [2.342f,0f,0f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [2.7145f,0f,0f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [2.9466f,0f,0f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [2.993f,0f,0f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [2.8443f,0f,0f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [2.5299f,0f,0f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [2.1115f,0f,0f]
						}
					}
					execute if entity @s[tag=aj.haha_bee.bone.rightwing_bone] run {
						name tree/rightwing_bone_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/rightwing_bone_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/rightwing_bone_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [1.8479f,-0.7652f,22.4877f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [1.562f,-0.1357f,4.963f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [1.2206f,-0.0112f,0.5248f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [1.0021f,-0.2221f,12.4938f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [0.8684f,-0.5413f,31.9336f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [0.867f,-0.8469f,44.3252f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [1.1842f,-1.0084f,40.4115f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [1.8265f,-0.78f,23.1158f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/rightwing_bone_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [2.4089f,-0.2262f,5.3606f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [2.7704f,-0.0193f,0.3981f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [2.9062f,-0.6141f,11.9213f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [2.5448f,-1.5503f,31.3293f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [2.0066f,-1.9482f,44.137f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [1.8606f,-1.6051f,40.7687f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [1.8562f,-0.8168f,23.7428f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [1.5852f,-0.1604f,5.777f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/rightwing_bone_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [1.2384f,-0.0063f,0.2894f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [1.0128f,-0.204f,11.3845f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [0.8744f,-0.5208f,30.7788f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [0.8598f,-0.8301f,43.9875f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [1.1525f,-1.0071f,41.1432f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [1.7836f,-0.8082f,24.3702f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [2.3799f,-0.2587f,6.2008f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [2.7524f,-0.0095f,0.1974f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/rightwing_bone_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [2.9103f,-0.5573f,10.8302f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [2.5804f,-1.5007f,30.1617f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [2.0312f,-1.9466f,43.7651f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [1.8593f,-1.6441f,41.4707f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [1.8632f,-0.8689f,24.9939f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [1.6081f,-0.1873f,6.6431f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [1.2569f,-0.0027f,0.1232f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [1.0239f,-0.1863f,10.3099f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/rightwing_bone_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [0.8807f,-0.5003f,29.5983f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [0.8539f,-0.8128f,43.5828f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [1.1224f,-1.0043f,41.8168f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [1.7404f,-0.8349f,25.6187f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [2.35f,-0.2925f,7.0917f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [2.7337f,-0.0032f,0.0662f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [2.9123f,-0.5022f,9.7755f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [2.615f,-1.4489f,28.9701f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/rightwing_bone_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [2.0576f,-1.942f,43.3268f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [1.8588f,-1.6811f,42.1135f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [1.8689f,-0.9215f,26.2373f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [1.6306f,-0.2164f,7.5586f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [1.2758f,-0.0006f,0.0269f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [1.0352f,-0.169f,9.2733f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [0.8874f,-0.4798f,28.3955f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [0.8492f,-0.795f,43.1123f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/rightwing_bone_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [1.0938f,-1f,42.43f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [1.6971f,-0.8597f,26.8575f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [2.319f,-0.3274f,8.0307f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [2.7145f,-0.0002f,0.0049f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [2.9122f,-0.4492f,8.7603f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [2.6483f,-1.395f,27.7585f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [2.0858f,-1.9343f,42.8234f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [1.8591f,-1.7161f,42.695f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [1.8733f,-0.9743f,27.4689f]
						}
					}
					execute if entity @s[tag=aj.haha_bee.bone.leftwing_bone] run {
						name tree/leftwing_bone_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/leftwing_bone_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/leftwing_bone_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [1.8479f,0.7652f,-22.4877f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [1.562f,0.1357f,-4.963f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [1.2206f,0.0112f,-0.5248f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [1.0021f,0.2221f,-12.4938f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [0.8684f,0.5413f,-31.9336f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [0.867f,0.8469f,-44.3252f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [1.1842f,1.0084f,-40.4115f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [1.8265f,0.78f,-23.1158f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/leftwing_bone_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [2.4089f,0.2262f,-5.3606f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [2.7704f,0.0193f,-0.3981f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [2.9062f,0.6141f,-11.9213f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [2.5448f,1.5503f,-31.3293f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [2.0066f,1.9482f,-44.137f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [1.8606f,1.6051f,-40.7687f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [1.8562f,0.8168f,-23.7428f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [1.5852f,0.1604f,-5.777f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/leftwing_bone_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [1.2384f,0.0063f,-0.2894f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [1.0128f,0.204f,-11.3845f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [0.8744f,0.5208f,-30.7788f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [0.8598f,0.8301f,-43.9875f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [1.1525f,1.0071f,-41.1432f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [1.7836f,0.8082f,-24.3702f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [2.3799f,0.2587f,-6.2008f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [2.7524f,0.0095f,-0.1974f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/leftwing_bone_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [2.9103f,0.5573f,-10.8302f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [2.5804f,1.5007f,-30.1617f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [2.0312f,1.9466f,-43.7651f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [1.8593f,1.6441f,-41.4707f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [1.8632f,0.8689f,-24.9939f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [1.6081f,0.1873f,-6.6431f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [1.2569f,0.0027f,-0.1232f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [1.0239f,0.1863f,-10.3099f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/leftwing_bone_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [0.8807f,0.5003f,-29.5983f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [0.8539f,0.8128f,-43.5828f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [1.1224f,1.0043f,-41.8168f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [1.7404f,0.8349f,-25.6187f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [2.35f,0.2925f,-7.0917f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [2.7337f,0.0032f,-0.0662f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [2.9123f,0.5022f,-9.7755f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [2.615f,1.4489f,-28.9701f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/leftwing_bone_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [2.0576f,1.942f,-43.3268f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [1.8588f,1.6811f,-42.1135f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [1.8689f,0.9215f,-26.2373f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [1.6306f,0.2164f,-7.5586f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [1.2758f,0.0006f,-0.0269f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [1.0352f,0.169f,-9.2733f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [0.8874f,0.4798f,-28.3955f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [0.8492f,0.795f,-43.1123f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/leftwing_bone_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [1.0938f,1f,-42.43f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [1.6971f,0.8597f,-26.8575f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [2.319f,0.3274f,-8.0307f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [2.7145f,0.0002f,-0.0049f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [2.9122f,0.4492f,-8.7603f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [2.6483f,1.395f,-27.7585f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [2.0858f,1.9343f,-42.8234f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [1.8591f,1.7161f,-42.695f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [1.8733f,0.9743f,-27.4689f]
						}
					}
					# Make sure rotation stays aligned with root entity
					execute positioned as @s run tp @s ~ ~ ~ ~ ~
				}
			}
			# Increment frame
			scoreboard players operation @s aj.frame += .aj.haha_bee.framerate aj.i
			# Let the anim_loop know we're still running
			scoreboard players set .aj.animation aj.haha_bee.animating 1
			# If (the next frame is the end of the animation) perform the necessary actions for the loop mode of the animation
			execute unless score @s aj.frame matches 0..57 run function haha_bee:animations/idle/edge
		}
		# Performs a loop mode action depending on what the animation's configured loop mode is
		function edge {
			# Play Once
			execute if score @s aj.haha_bee.idle.loopMode matches 0 run function haha_bee:animations/idle/stop
			# Hold on last frame
			execute if score @s aj.haha_bee.idle.loopMode matches 1 run function haha_bee:animations/idle/pause
			# loop
			execute if score @s aj.haha_bee.idle.loopMode matches 2 run {
				execute (if score @s aj.frame matches ..1) {
					scoreboard players set @s aj.frame 57
				} else {
					scoreboard players set @s aj.frame 0
				}
			}
		}
	}
}