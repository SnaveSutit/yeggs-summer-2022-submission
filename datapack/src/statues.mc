function reset_animation_flags {
	scoreboard players set .aj.animation aj.statues.animating 0
	scoreboard players set .aj.anim_loop aj.statues.animating 0
	scoreboard players set .noScripts aj.i 0
}
function assert_animation_flags {
	scoreboard players add .aj.animation aj.statues.animating 0
	scoreboard players add .aj.anim_loop aj.statues.animating 0
	scoreboard players add .noScripts aj.i 0
}
function install {
	scoreboard objectives add aj.i dummy
	scoreboard objectives add aj.id dummy
	scoreboard objectives add aj.frame dummy
	scoreboard objectives add aj.statues.animating dummy
	scoreboard objectives add aj.statues.idle.loopMode dummy
	function statues:reset_animation_flags
	scoreboard players set #uninstall aj.i 0
	scoreboard players set .aj.statues.framerate aj.i 1
	tellraw @a [{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"aqua"},{"text":" → ","color":"gray"},{"text":"Install ⊻","color":"green"},{"text":" ]","color":"dark_gray"},"\n",{"text":"Installed ","color":"gray"},{"text":"armor_stand","color":"gold"},{"text":" rig.","color":"gray"},"\n",{"text":"◘ ","color":"gray"},{"text":"Included Scoreboard Objectives:","color":"green"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.i","color":"aqua"},{"text":" (Internal)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.id","color":"aqua"},{"text":" (ID)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.frame","color":"aqua"},{"text":" (Frame)","color":"dark_gray"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.statues.animating","color":"aqua"},{"text":" (Animation Flag)","color":"dark_gray"},[["\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.statues.idle.loopMode","color":"aqua"},{"text":" (Loop Mode)","color":"dark_gray"}]]]
}
function uninstall {
	scoreboard objectives remove aj.statues.animating
	scoreboard objectives remove aj.statues.idle.loopMode
	scoreboard players set #uninstall aj.i 1
	tellraw @a [{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"aqua"},{"text":" → ","color":"gray"},{"text":"Uninstall ⊽","color":"red"},{"text":" ]","color":"dark_gray"},"\n",{"text":"Uninstalled ","color":"gray"},{"text":"armor_stand","color":"gold"},{"text":" rig specific scoreboards","color":"gray"},"\n",{"text":"◘ ","color":"gray"},{"text":"Included Scoreboard Objectives:","color":"green"},"\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.statues.animating","color":"aqua"},{"text":" (Animation Flag)","color":"dark_gray"},[["\n",{"text":"   ◘ ","color":"gray"},{"text":"aj.statues.idle.loopMode","color":"aqua"},{"text":" (Loop Mode)","color":"dark_gray"}]],"\n","\n",{"text":"◘ ","color":"gray"},{"text":"Do you wish to uninstall all AJ related scoreboard objectives added by this rig?","color":"green"},"\n",{"text":"[Yes]","color":"green","clickEvent":{"action":"run_command","value":"/function statues:uninstall/remove_aj_related"}},{"text":" [No]","color":"red","clickEvent":{"action":"run_command","value":"/function statues:uninstall/keep_aj_related"}}]
}
dir uninstall {
	function keep_aj_related {
		execute if score #uninstall aj.i matches 0 run tellraw @a [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"Uninstall not in-progress. Please run","color":"gray"},"\n",{"text":" function statues:uninstall","color":"red"},"\n",{"text":" to start the uninstallation process.","color":"gray"}]
		execute if score #uninstall aj.i matches 1 run {
			scoreboard players set #uninstall aj.i 0
			tellraw @a [{"text":"Keeping AJ specific scoreboard objectives.","color":"green"}]
		}
	}
	function remove_aj_related {
		execute if score #uninstall aj.i matches 0 run tellraw @a [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"Uninstall not in-progress. Please run","color":"gray"},"\n",{"text":" function statues:uninstall","color":"red"},"\n",{"text":" to start the uninstallation process.","color":"gray"}]
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
		kill @e[type=minecraft:marker,tag=aj.statues]
		kill @e[type=#statues:bone_entities,tag=aj.statues]
	}
	function this {
		execute (if entity @s[tag=aj.statues.root] at @s) {
			scoreboard players operation # aj.id = @s aj.id
			execute as @e[type=#statues:bone_entities,tag=aj.statues,distance=..5.84] if score @s aj.id = # aj.id run kill @s
			kill @s
		} else {
			tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:remove/this ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
		}
	}
}
dir summon {
	function default {
		# Summon Root Entity
		summon minecraft:marker ~ ~ ~ {Tags:['new','aj.statues','aj.statues.root']}
		# Execute as summoned root
		execute as @e[type=minecraft:marker,tag=aj.statues.root,tag=new,distance=..1,limit=1] rotated ~ 0 run {
			# Copy the execution position and rotation onto the root
			tp @s ~ ~ ~ ~ ~
			# Get an ID for this rig
			execute store result score @s aj.id run scoreboard players add .aj.last_id aj.i 1
			# Execute at updated location
			execute at @s run {
				# Summon all bone entities
				summon minecraft:area_effect_cloud ^-1 ^-1.1005 ^0 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.body'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.body','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:1}}],Pose:{Head:[-7.5f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^-1 ^-0.29495 ^-0.10605 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.head'],Passengers:[{CustomName:'{"text":"SnaveSutit"}',CustomNameVisible:1b,id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.head','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:2}}],Pose:{Head:[-25f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^-1.375 ^-0.41072 ^-0.02777 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.right_arm'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.right_arm','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:3}}],Pose:{Head:[-133.999f,-3.126f,-30.464f]}}]}
				summon minecraft:area_effect_cloud ^-0.625 ^-0.41072 ^-0.02777 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.left_arm'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.left_arm','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:4}}],Pose:{Head:[-128.942f,3.725f,33.355f]}}]}
				summon minecraft:area_effect_cloud ^-1.28482 ^-1.84426 ^-0.35471 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.right_piv'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.right_piv','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:5}}],Pose:{Head:[26.043f,23.961f,22.542f]}}]}
				summon minecraft:area_effect_cloud ^-0.69023 ^-1.87395 ^0.22451 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.left_piv'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.left_piv','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:6}}],Pose:{Head:[-12.388f,-16.356f,-7.787f]}}]}
				summon minecraft:area_effect_cloud ^-1 ^0.5245 ^0.8125 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.command_block'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.command_block','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:7}}],Pose:{Head:[0f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^1 ^-1.13175 ^0 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.body2'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.body2','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:8}}],Pose:{Head:[-5f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^1 ^-0.32234 ^-0.07081 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.head2'],Passengers:[{CustomName:'{"text":"Galactic_Wolf"}',CustomNameVisible:1b,id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.head2','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:9}}],Pose:{Head:[5f,0f,0f]}}]}
				summon minecraft:area_effect_cloud ^0.75 ^-0.50859 ^-0.06263 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.right_arm2'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.right_arm2','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:10}}],Pose:{Head:[-48.741f,-40.549f,-26.496f]}}]}
				summon minecraft:area_effect_cloud ^1.17414 ^-1.21523 ^0.36672 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.axe'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.axe','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:11}}],Pose:{Head:[10.073f,-19.869f,-7.399f]}}]}
				summon minecraft:area_effect_cloud ^1.25 ^-0.50913 ^-0.05447 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.left_arm2'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.left_arm2','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:12}}],Pose:{Head:[-69.031f,45.687f,18.602f]}}]}
				summon minecraft:area_effect_cloud ^0.74623 ^-1.90375 ^0.06537 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.bone'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.bone','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:13}}],Pose:{Head:[-5.175f,14.942f,6.162f]}}]}
				summon minecraft:area_effect_cloud ^1.25377 ^-1.90375 ^-0.06537 {Age:-2147483648,Duration:-1,WaitTime:-2147483648,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.bone2'],Passengers:[{id:'minecraft:armor_stand',Invisible:true,Marker:false,NoGravity:true,DisabledSlots:4144959,Tags:['new','aj.statues','aj.statues.bone','aj.statues.bone.bone2','aj.statues.bone_display'],ArmorItems:[{},{},{},{id:'minecraft:white_dye',Count:1b,tag:{CustomModelData:14}}],Pose:{Head:[5.175f,-14.942f,-8.838f]}}]}
				# Update rotation and ID of bone entities to match the root entity
				execute as @e[type=#statues:bone_entities,tag=aj.statues,tag=new,distance=..5.84] positioned as @s run {
					scoreboard players operation @s aj.id = .aj.last_id aj.i
					tp @s ~ ~ ~ ~ ~
					tag @s remove new
				}
			}
			tag @s remove new
			# Set all animation modes to configured default
			scoreboard players set @s aj.statues.idle.loopMode 2
			scoreboard players set @s aj.frame 0
			scoreboard players set @s aj.statues.animating 0
		}
		# Assert animation flags
		function statues:assert_animation_flags
	}
}
# Resets the model to it's initial summon position/rotation and stops all active animations
function reset {
	# Make sure this function has been ran as the root entity
	execute(if entity @s[tag=aj.statues.root] at @s rotated ~ 0) {
		# Remove all animation tags
		tag @s remove aj.statues.anim.idle
		# Reset animation time
		scoreboard players set @s aj.frame 0
		scoreboard players operation .this aj.id = @s aj.id
		execute as @e[type=minecraft:area_effect_cloud,tag=aj.statues.bone,distance=..5.84] if score @s aj.id = .this aj.id run {
			tp @s[tag=aj.statues.bone.body] ^-1 ^-1.1 ^0
			tp @s[tag=aj.statues.bone.head] ^-1 ^-0.295 ^-0.106
			tp @s[tag=aj.statues.bone.right_arm] ^-1.375 ^-0.411 ^-0.028
			tp @s[tag=aj.statues.bone.left_arm] ^-0.625 ^-0.411 ^-0.028
			tp @s[tag=aj.statues.bone.right_piv] ^-1.285 ^-1.844 ^-0.355
			tp @s[tag=aj.statues.bone.left_piv] ^-0.69 ^-1.874 ^0.225
			tp @s[tag=aj.statues.bone.command_block] ^-1 ^0.525 ^0.813
			tp @s[tag=aj.statues.bone.body2] ^1 ^-1.132 ^0
			tp @s[tag=aj.statues.bone.head2] ^1 ^-0.322 ^-0.071
			tp @s[tag=aj.statues.bone.right_arm2] ^0.75 ^-0.509 ^-0.063
			tp @s[tag=aj.statues.bone.axe] ^1.174 ^-1.215 ^0.367
			tp @s[tag=aj.statues.bone.left_arm2] ^1.25 ^-0.509 ^-0.054
			tp @s[tag=aj.statues.bone.bone] ^0.746 ^-1.904 ^0.065
			tp @s[tag=aj.statues.bone.bone2] ^1.254 ^-1.904 ^-0.065
			execute store result score .calc aj.i run data get entity @s Air
			execute store result entity @s Air short 1 run scoreboard players add .calc aj.i 2
		}
		execute as @e[type=minecraft:armor_stand,tag=aj.statues.bone,distance=..5.84] if score @s aj.id = .this aj.id run {
			data modify entity @s[tag=aj.statues.bone.body] Pose.Head set value [-7.5f,0f,0f]
			data modify entity @s[tag=aj.statues.bone.head] Pose.Head set value [-25f,0f,0f]
			data modify entity @s[tag=aj.statues.bone.right_arm] Pose.Head set value [-133.999f,-3.126f,-30.464f]
			data modify entity @s[tag=aj.statues.bone.left_arm] Pose.Head set value [-128.942f,3.725f,33.355f]
			data modify entity @s[tag=aj.statues.bone.right_piv] Pose.Head set value [26.043f,23.961f,22.542f]
			data modify entity @s[tag=aj.statues.bone.left_piv] Pose.Head set value [-12.388f,-16.356f,-7.787f]
			data modify entity @s[tag=aj.statues.bone.command_block] Pose.Head set value [0f,0f,0f]
			data modify entity @s[tag=aj.statues.bone.body2] Pose.Head set value [-5f,0f,0f]
			data modify entity @s[tag=aj.statues.bone.head2] Pose.Head set value [5f,0f,0f]
			data modify entity @s[tag=aj.statues.bone.right_arm2] Pose.Head set value [-48.741f,-40.549f,-26.496f]
			data modify entity @s[tag=aj.statues.bone.axe] Pose.Head set value [10.073f,-19.869f,-7.399f]
			data modify entity @s[tag=aj.statues.bone.left_arm2] Pose.Head set value [-69.031f,45.687f,18.602f]
			data modify entity @s[tag=aj.statues.bone.bone] Pose.Head set value [-5.175f,14.942f,6.162f]
			data modify entity @s[tag=aj.statues.bone.bone2] Pose.Head set value [5.175f,-14.942f,-8.838f]
			tp @s ~ ~ ~ ~ ~
		}
		# If this entity is not the root
	} else {
		tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:reset ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
	}
}
function move {
	# Make sure this function has been ran as the root entity
	execute(if entity @s[tag=aj.statues.root] rotated ~ 0) {
		tp @s ~ ~ ~ ~ ~
		scoreboard players operation .this aj.id = @s aj.id
		scoreboard players operation .this aj.frame = @s aj.frame
		# Split based on animation name
		scoreboard players set # aj.i 0
		execute if entity @s[tag=aj.statues.anim.idle] run {
			scoreboard players set # aj.i 1
			# Select bone entities
			execute at @s as @e[type=#statues:bone_entities,tag=aj.statues.bone] if score @s aj.id = .this aj.id run {
				# Split based on bone entity type
				execute if entity @s[type=minecraft:area_effect_cloud] run {
					# Run root animation frame tree
					function statues:animations/idle/tree/root_bone_name
					execute store result score .calc aj.i run data get entity @s Air
					execute store result entity @s Air short 1 run scoreboard players add .calc aj.i 2
				}
				execute if entity @s[type=minecraft:armor_stand] run tp @s ~ ~ ~ ~ ~
			}
		}
		execute if score # aj.i matches 0 run {
			execute at @s as @e[type=minecraft:area_effect_cloud,tag=aj.statues.bone] if score @s aj.id = .this aj.id run tp @s ~ ~ ~
			function statues:reset
		}
		# If this entity is not the root
	} else {
		tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:move ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
	}
}
function animation_loop {
	# Schedule clock
	schedule function statues:animation_loop 1t
	# Set anim_loop active flag to true
	scoreboard players set .aj.anim_loop aj.statues.animating 1
	# Reset animating flag (Used internally to check if any animations have ticked during this tick)
	scoreboard players set .aj.animation aj.statues.animating 0
	# Run animations that are active on the entity
	execute as @e[type=minecraft:marker,tag=aj.statues.root] run{
		execute if entity @s[tag=aj.statues.anim.idle] at @s run function statues:animations/idle/next_frame
		scoreboard players operation @s aj.statues.animating = .aj.animation aj.statues.animating
	}
	# Stop the anim_loop clock if no models are animating
	execute if score .aj.animation aj.statues.animating matches 0 run {
		# Stop anim_loop shedule clock
		schedule clear statues:animation_loop
		# Set anim_loop active flag to false
		scoreboard players set .aj.anim_loop aj.statues.animating 0
	}
}
dir animations {
	dir idle {
		# Starts the animation from the first frame
		function play {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.statues.root] at @s) {
				# Add animation tag
				tag @s add aj.statues.anim.idle
				# Reset animation time
				execute if score .aj.statues.framerate aj.i matches ..-1 run scoreboard players set @s aj.frame 57
				execute if score .aj.statues.framerate aj.i matches 1.. run scoreboard players set @s aj.frame 0
				# Assert that .noScripts is tracked properly
				scoreboard players add .noScripts aj.i 0
				# Start the animation loop if not running
				execute if score .aj.anim_loop aj.statues.animating matches 0 run function statues:animation_loop
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:animations/idle/play ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
			}
		}
		# Stops the animation and resets to first frame
		function stop {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.statues.root] at @s) {
				# Add animation tag
				tag @s remove aj.statues.anim.idle
				# Reset animation time
				scoreboard players set @s aj.frame 0
				# load initial animation frame without running scripts
				scoreboard players operation .oldValue aj.i = .noScripts aj.i
				scoreboard players set .noScripts aj.i 1
				function statues:animations/idle/next_frame
				scoreboard players operation .noScripts aj.i = .oldValue aj.i
				# Reset animation time
				scoreboard players set @s aj.frame 0
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:animations/idle/stop ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
			}
		}
		# Pauses the animation on the current frame
		function pause {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.statues.root] at @s) {
				# Remove animation tag
				tag @s remove aj.statues.anim.idle
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:animations/idle/pause ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
			}
		}
		# Resumes the animation from the current frame
		function resume {
			# Make sure this function has been ran as the root entity
			execute(if entity @s[tag=aj.statues.root]) {
				# Remove animation tag
				tag @s add aj.statues.anim.idle
				# Start the animation loop
				execute if score .aj.anim_loop aj.statues.animating matches 0 run function statues:animation_loop
				# If this entity is not the root
			} else {
				tellraw @s [["",{"text":"[ ","color":"dark_gray"},{"text":"AJ","color":"green"},{"text":" → ","color":"light_purple"},{"text":"Error ☠","color":"red"},{"text":" ]","color":"dark_gray"},"\n"],{"text":"→ ","color":"red"},{"text":"The function ","color":"gray"},{"text":"statues:animations/idle/resume ","color":"yellow"},{"text":"must be","color":"gray"},"\n",{"text":"executed as @e[tag=aj.statues.root]","color":"light_purple"}]
			}
		}
		# Plays the next frame in the animation
		function next_frame {
			scoreboard players operation .this aj.id = @s aj.id
			scoreboard players operation .this aj.frame = @s aj.frame
			execute rotated ~ 0 as @e[type=#statues:bone_entities,tag=aj.statues.bone,distance=..4.027] if score @s aj.id = .this aj.id run {
				name tree/trunk
				# Bone Roots
				execute if entity @s[type=minecraft:area_effect_cloud] run {
					name tree/root_bone_name
					execute if entity @s[tag=aj.statues.bone.head] run {
						name tree/head_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/head_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/head_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^-1 ^-0.295 ^-0.106 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^-1 ^-0.291 ^-0.105 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^-1 ^-0.288 ^-0.104 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^-1 ^-0.284 ^-0.103 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^-1 ^-0.281 ^-0.102 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^-1 ^-0.278 ^-0.101 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^-1 ^-0.275 ^-0.1 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^-1 ^-0.272 ^-0.099 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/head_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^-1 ^-0.269 ^-0.098 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^-1 ^-0.267 ^-0.098 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^-1 ^-0.266 ^-0.097 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^-1 ^-0.264 ^-0.097 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^-1 ^-0.263 ^-0.096 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^-1 ^-0.262 ^-0.096 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^-1 ^-0.262 ^-0.096 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/head_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^-1 ^-0.263 ^-0.096 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^-1 ^-0.264 ^-0.097 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^-1 ^-0.265 ^-0.097 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^-1 ^-0.267 ^-0.098 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^-1 ^-0.269 ^-0.098 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^-1 ^-0.272 ^-0.099 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^-1 ^-0.274 ^-0.1 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^-1 ^-0.277 ^-0.101 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/head_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^-1 ^-0.28 ^-0.102 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^-1 ^-0.284 ^-0.103 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^-1 ^-0.287 ^-0.104 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^-1 ^-0.291 ^-0.105 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^-1 ^-0.294 ^-0.106 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^-1 ^-0.298 ^-0.107 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^-1 ^-0.302 ^-0.108 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^-1 ^-0.305 ^-0.109 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/head_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^-1 ^-0.309 ^-0.11 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^-1 ^-0.312 ^-0.111 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^-1 ^-0.315 ^-0.112 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^-1 ^-0.318 ^-0.113 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^-1 ^-0.32 ^-0.114 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^-1 ^-0.323 ^-0.114 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^-1 ^-0.324 ^-0.115 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^-1 ^-0.326 ^-0.115 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/head_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^-1 ^-0.327 ^-0.116 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^-1 ^-0.328 ^-0.116 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^-1 ^-0.328 ^-0.116 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^-1 ^-0.327 ^-0.116 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^-1 ^-0.326 ^-0.116 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^-1 ^-0.325 ^-0.115 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^-1 ^-0.323 ^-0.115 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/head_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^-1 ^-0.321 ^-0.114 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^-1 ^-0.319 ^-0.113 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^-1 ^-0.316 ^-0.112 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^-1 ^-0.313 ^-0.112 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^-1 ^-0.31 ^-0.111 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^-1 ^-0.307 ^-0.11 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^-1 ^-0.303 ^-0.109 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^-1 ^-0.3 ^-0.107 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^-1 ^-0.296 ^-0.106 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.body] run {
						name tree/body_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/body_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/body_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^-1 ^-1.1 ^0 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^-1 ^-1.097 ^0 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^-1 ^-1.094 ^-0.001 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^-1 ^-1.09 ^-0.001 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^-1 ^-1.087 ^-0.002 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^-1 ^-1.084 ^-0.002 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^-1 ^-1.081 ^-0.003 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^-1 ^-1.079 ^-0.003 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/body_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^-1 ^-1.076 ^-0.003 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^-1 ^-1.074 ^-0.003 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^-1 ^-1.073 ^-0.004 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^-1 ^-1.071 ^-0.004 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^-1 ^-1.07 ^-0.004 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/body_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^-1 ^-1.07 ^-0.004 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^-1 ^-1.071 ^-0.004 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^-1 ^-1.072 ^-0.004 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^-1 ^-1.074 ^-0.003 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^-1 ^-1.076 ^-0.003 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^-1 ^-1.078 ^-0.003 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^-1 ^-1.081 ^-0.003 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^-1 ^-1.084 ^-0.002 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/body_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^-1 ^-1.087 ^-0.002 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^-1 ^-1.09 ^-0.001 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^-1 ^-1.093 ^-0.001 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^-1 ^-1.097 ^-0.001 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^-1 ^-1.1 ^0 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^-1 ^-1.104 ^0 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^-1 ^-1.107 ^0.001 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^-1 ^-1.11 ^0.001 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/body_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^-1 ^-1.114 ^0.002 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^-1 ^-1.117 ^0.002 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^-1 ^-1.119 ^0.002 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^-1 ^-1.122 ^0.003 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^-1 ^-1.124 ^0.003 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^-1 ^-1.126 ^0.003 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^-1 ^-1.128 ^0.004 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^-1 ^-1.13 ^0.004 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/body_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^-1 ^-1.131 ^0.004 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^-1 ^-1.131 ^0.004 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^-1 ^-1.13 ^0.004 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^-1 ^-1.129 ^0.004 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^-1 ^-1.127 ^0.004 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/body_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^-1 ^-1.125 ^0.003 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^-1 ^-1.123 ^0.003 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^-1 ^-1.12 ^0.003 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^-1 ^-1.118 ^0.002 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^-1 ^-1.115 ^0.002 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^-1 ^-1.111 ^0.001 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^-1 ^-1.108 ^0.001 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^-1 ^-1.105 ^0.001 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^-1 ^-1.101 ^0 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.right_arm] run {
						name tree/right_arm_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/right_arm_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/right_arm_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^-1.375 ^-0.411 ^-0.028 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^-1.375 ^-0.407 ^-0.027 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^-1.375 ^-0.404 ^-0.026 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^-1.375 ^-0.4 ^-0.025 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^-1.375 ^-0.397 ^-0.024 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^-1.375 ^-0.394 ^-0.024 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^-1.375 ^-0.391 ^-0.023 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^-1.375 ^-0.389 ^-0.022 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/right_arm_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^-1.375 ^-0.386 ^-0.022 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^-1.375 ^-0.384 ^-0.021 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^-1.375 ^-0.383 ^-0.021 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^-1.375 ^-0.381 ^-0.02 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^-1.375 ^-0.38 ^-0.02 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^-1.375 ^-0.38 ^-0.02 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^-1.375 ^-0.379 ^-0.02 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^-1.375 ^-0.38 ^-0.02 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/right_arm_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^-1.375 ^-0.38 ^-0.02 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^-1.375 ^-0.381 ^-0.02 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^-1.375 ^-0.382 ^-0.021 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^-1.375 ^-0.384 ^-0.021 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^-1.375 ^-0.386 ^-0.021 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^-1.375 ^-0.388 ^-0.022 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^-1.375 ^-0.391 ^-0.023 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^-1.375 ^-0.394 ^-0.023 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/right_arm_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^-1.375 ^-0.397 ^-0.024 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^-1.375 ^-0.4 ^-0.025 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^-1.375 ^-0.403 ^-0.026 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^-1.375 ^-0.407 ^-0.027 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^-1.375 ^-0.41 ^-0.028 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^-1.375 ^-0.414 ^-0.029 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^-1.375 ^-0.417 ^-0.029 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^-1.375 ^-0.421 ^-0.03 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/right_arm_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^-1.375 ^-0.424 ^-0.031 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^-1.375 ^-0.427 ^-0.032 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^-1.375 ^-0.43 ^-0.033 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^-1.375 ^-0.433 ^-0.033 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^-1.375 ^-0.435 ^-0.034 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^-1.375 ^-0.437 ^-0.034 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^-1.375 ^-0.439 ^-0.035 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^-1.375 ^-0.44 ^-0.035 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/right_arm_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^-1.375 ^-0.441 ^-0.035 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^-1.375 ^-0.442 ^-0.036 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^-1.375 ^-0.442 ^-0.036 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^-1.375 ^-0.441 ^-0.035 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^-1.375 ^-0.439 ^-0.035 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^-1.375 ^-0.438 ^-0.035 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/right_arm_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^-1.375 ^-0.436 ^-0.034 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^-1.375 ^-0.434 ^-0.034 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^-1.375 ^-0.431 ^-0.033 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^-1.375 ^-0.428 ^-0.032 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^-1.375 ^-0.425 ^-0.031 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^-1.375 ^-0.422 ^-0.031 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^-1.375 ^-0.419 ^-0.03 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^-1.375 ^-0.415 ^-0.029 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^-1.375 ^-0.412 ^-0.028 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.left_arm] run {
						name tree/left_arm_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/left_arm_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/left_arm_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^-0.625 ^-0.411 ^-0.028 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^-0.625 ^-0.407 ^-0.027 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^-0.625 ^-0.404 ^-0.026 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^-0.625 ^-0.4 ^-0.025 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^-0.625 ^-0.397 ^-0.024 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^-0.625 ^-0.394 ^-0.024 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^-0.625 ^-0.391 ^-0.023 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^-0.625 ^-0.389 ^-0.022 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/left_arm_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^-0.625 ^-0.386 ^-0.022 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^-0.625 ^-0.384 ^-0.021 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^-0.625 ^-0.383 ^-0.021 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^-0.625 ^-0.381 ^-0.02 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^-0.625 ^-0.38 ^-0.02 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^-0.625 ^-0.38 ^-0.02 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^-0.625 ^-0.379 ^-0.02 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^-0.625 ^-0.38 ^-0.02 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/left_arm_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^-0.625 ^-0.38 ^-0.02 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^-0.625 ^-0.381 ^-0.02 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^-0.625 ^-0.382 ^-0.021 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^-0.625 ^-0.384 ^-0.021 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^-0.625 ^-0.386 ^-0.021 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^-0.625 ^-0.388 ^-0.022 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^-0.625 ^-0.391 ^-0.023 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^-0.625 ^-0.394 ^-0.023 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/left_arm_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^-0.625 ^-0.397 ^-0.024 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^-0.625 ^-0.4 ^-0.025 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^-0.625 ^-0.403 ^-0.026 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^-0.625 ^-0.407 ^-0.027 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^-0.625 ^-0.41 ^-0.028 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^-0.625 ^-0.414 ^-0.029 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^-0.625 ^-0.417 ^-0.029 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^-0.625 ^-0.421 ^-0.03 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/left_arm_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^-0.625 ^-0.424 ^-0.031 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^-0.625 ^-0.427 ^-0.032 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^-0.625 ^-0.43 ^-0.033 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^-0.625 ^-0.433 ^-0.033 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^-0.625 ^-0.435 ^-0.034 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^-0.625 ^-0.437 ^-0.034 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^-0.625 ^-0.439 ^-0.035 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^-0.625 ^-0.44 ^-0.035 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/left_arm_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^-0.625 ^-0.441 ^-0.035 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^-0.625 ^-0.442 ^-0.036 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^-0.625 ^-0.442 ^-0.036 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^-0.625 ^-0.441 ^-0.035 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^-0.625 ^-0.439 ^-0.035 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^-0.625 ^-0.438 ^-0.035 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/left_arm_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^-0.625 ^-0.436 ^-0.034 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^-0.625 ^-0.434 ^-0.034 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^-0.625 ^-0.431 ^-0.033 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^-0.625 ^-0.428 ^-0.032 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^-0.625 ^-0.425 ^-0.031 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^-0.625 ^-0.422 ^-0.031 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^-0.625 ^-0.419 ^-0.03 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^-0.625 ^-0.415 ^-0.029 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^-0.625 ^-0.412 ^-0.028 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.right_piv] run {
						name tree/right_piv_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/right_piv_root_0-56
							execute if score .this aj.frame matches 0 run tp @s ^-1.285 ^-1.844 ^-0.355 ~ ~
							execute if score .this aj.frame matches 56 run tp @s ^-1.285 ^-1.844 ^-0.355 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.left_piv] run {
						name tree/left_piv_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/left_piv_root_0-56
							execute if score .this aj.frame matches 0 run tp @s ^-0.69 ^-1.874 ^0.225 ~ ~
							execute if score .this aj.frame matches 56 run tp @s ^-0.69 ^-1.874 ^0.225 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.command_block] run {
						name tree/command_block_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/command_block_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/command_block_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^-1.062 ^0.525 ^0.625 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^-1.062 ^0.545 ^0.626 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^-1.061 ^0.566 ^0.63 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^-1.059 ^0.586 ^0.635 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^-1.056 ^0.606 ^0.643 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^-1.053 ^0.624 ^0.653 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^-1.049 ^0.641 ^0.666 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^-1.044 ^0.657 ^0.679 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/command_block_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^-1.039 ^0.671 ^0.695 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^-1.033 ^0.683 ^0.712 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^-1.027 ^0.693 ^0.73 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^-1.021 ^0.701 ^0.75 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^-1.014 ^0.707 ^0.77 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^-1.007 ^0.711 ^0.79 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^-1 ^0.712 ^0.811 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^-0.993 ^0.711 ^0.832 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/command_block_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^-0.987 ^0.708 ^0.853 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^-0.98 ^0.702 ^0.873 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^-0.973 ^0.694 ^0.892 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^-0.967 ^0.684 ^0.911 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^-0.962 ^0.672 ^0.928 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^-0.956 ^0.658 ^0.944 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^-0.952 ^0.643 ^0.958 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^-0.947 ^0.626 ^0.97 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/command_block_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^-0.944 ^0.608 ^0.98 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^-0.941 ^0.589 ^0.989 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^-0.939 ^0.569 ^0.995 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^-0.938 ^0.548 ^0.999 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^-0.938 ^0.527 ^1 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^-0.938 ^0.506 ^0.999 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^-0.939 ^0.486 ^0.996 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^-0.941 ^0.465 ^0.99 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/command_block_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^-0.943 ^0.446 ^0.983 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^-0.947 ^0.427 ^0.973 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^-0.95 ^0.41 ^0.961 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^-0.955 ^0.394 ^0.947 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^-0.96 ^0.38 ^0.932 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^-0.966 ^0.368 ^0.915 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^-0.972 ^0.357 ^0.897 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^-0.978 ^0.349 ^0.878 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/command_block_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^-0.985 ^0.343 ^0.858 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^-0.992 ^0.339 ^0.837 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^-0.999 ^0.337 ^0.816 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^-1.006 ^0.338 ^0.796 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^-1.013 ^0.341 ^0.775 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^-1.019 ^0.346 ^0.755 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^-1.026 ^0.354 ^0.735 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^-1.032 ^0.363 ^0.716 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/command_block_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^-1.038 ^0.375 ^0.699 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^-1.043 ^0.389 ^0.683 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^-1.048 ^0.404 ^0.669 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^-1.052 ^0.421 ^0.656 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^-1.056 ^0.439 ^0.646 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^-1.058 ^0.458 ^0.637 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^-1.061 ^0.478 ^0.631 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^-1.062 ^0.498 ^0.627 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^-1.062 ^0.519 ^0.625 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.head2] run {
						name tree/head2_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/head2_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/head2_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^1 ^-0.304 ^-0.071 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^1 ^-0.304 ^-0.069 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^1 ^-0.304 ^-0.068 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^1 ^-0.304 ^-0.066 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^1 ^-0.305 ^-0.065 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^1 ^-0.306 ^-0.063 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^1 ^-0.307 ^-0.062 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^1 ^-0.308 ^-0.061 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/head2_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^1 ^-0.31 ^-0.06 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^1 ^-0.311 ^-0.059 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^1 ^-0.313 ^-0.058 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^1 ^-0.315 ^-0.057 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^1 ^-0.317 ^-0.057 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^1 ^-0.319 ^-0.057 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^1 ^-0.321 ^-0.057 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^1 ^-0.323 ^-0.057 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/head2_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^1 ^-0.325 ^-0.057 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^1 ^-0.327 ^-0.057 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^1 ^-0.329 ^-0.058 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^1 ^-0.331 ^-0.059 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^1 ^-0.333 ^-0.06 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^1 ^-0.335 ^-0.061 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^1 ^-0.336 ^-0.062 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^1 ^-0.337 ^-0.063 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/head2_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^1 ^-0.339 ^-0.065 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^1 ^-0.34 ^-0.066 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^1 ^-0.34 ^-0.067 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^1 ^-0.341 ^-0.069 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^1 ^-0.341 ^-0.071 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^1 ^-0.341 ^-0.072 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^1 ^-0.341 ^-0.074 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^1 ^-0.341 ^-0.075 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/head2_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^1 ^-0.34 ^-0.077 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^1 ^-0.339 ^-0.078 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^1 ^-0.338 ^-0.079 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^1 ^-0.337 ^-0.081 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^1 ^-0.335 ^-0.082 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^1 ^-0.334 ^-0.083 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^1 ^-0.332 ^-0.083 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^1 ^-0.33 ^-0.084 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/head2_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^1 ^-0.328 ^-0.085 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^1 ^-0.326 ^-0.085 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^1 ^-0.324 ^-0.085 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^1 ^-0.322 ^-0.085 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^1 ^-0.32 ^-0.085 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^1 ^-0.318 ^-0.084 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^1 ^-0.316 ^-0.084 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^1 ^-0.314 ^-0.083 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/head2_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^1 ^-0.312 ^-0.082 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^1 ^-0.31 ^-0.081 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^1 ^-0.309 ^-0.08 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^1 ^-0.307 ^-0.079 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^1 ^-0.306 ^-0.077 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^1 ^-0.305 ^-0.076 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^1 ^-0.304 ^-0.074 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^1 ^-0.304 ^-0.073 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^1 ^-0.304 ^-0.071 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.right_arm2] run {
						name tree/right_arm2_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/right_arm2_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/right_arm2_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^0.75 ^-0.49 ^-0.063 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^0.75 ^-0.49 ^-0.061 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^0.75 ^-0.49 ^-0.06 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^0.75 ^-0.491 ^-0.059 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^0.75 ^-0.491 ^-0.058 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^0.75 ^-0.492 ^-0.057 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^0.75 ^-0.493 ^-0.056 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^0.75 ^-0.495 ^-0.055 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/right_arm2_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^0.75 ^-0.496 ^-0.054 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^0.75 ^-0.498 ^-0.053 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^0.75 ^-0.499 ^-0.053 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^0.75 ^-0.501 ^-0.052 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^0.75 ^-0.503 ^-0.052 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^0.75 ^-0.505 ^-0.052 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^0.75 ^-0.507 ^-0.052 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^0.75 ^-0.51 ^-0.052 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/right_arm2_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^0.75 ^-0.512 ^-0.052 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^0.75 ^-0.514 ^-0.052 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^0.75 ^-0.516 ^-0.053 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^0.75 ^-0.518 ^-0.053 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^0.75 ^-0.519 ^-0.054 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^0.75 ^-0.521 ^-0.055 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^0.75 ^-0.522 ^-0.056 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^0.75 ^-0.524 ^-0.057 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/right_arm2_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^0.75 ^-0.525 ^-0.058 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^0.75 ^-0.526 ^-0.059 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^0.75 ^-0.527 ^-0.06 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^0.75 ^-0.527 ^-0.061 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^0.75 ^-0.527 ^-0.062 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^0.75 ^-0.527 ^-0.064 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^0.75 ^-0.527 ^-0.065 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^0.75 ^-0.527 ^-0.066 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/right_arm2_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^0.75 ^-0.526 ^-0.067 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^0.75 ^-0.525 ^-0.068 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^0.75 ^-0.524 ^-0.069 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^0.75 ^-0.523 ^-0.07 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^0.75 ^-0.521 ^-0.071 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^0.75 ^-0.52 ^-0.072 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^0.75 ^-0.518 ^-0.072 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^0.75 ^-0.516 ^-0.073 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/right_arm2_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^0.75 ^-0.514 ^-0.073 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^0.75 ^-0.512 ^-0.073 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^0.75 ^-0.51 ^-0.073 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^0.75 ^-0.508 ^-0.073 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^0.75 ^-0.506 ^-0.073 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^0.75 ^-0.504 ^-0.073 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^0.75 ^-0.502 ^-0.073 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^0.75 ^-0.5 ^-0.072 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/right_arm2_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^0.75 ^-0.498 ^-0.071 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^0.75 ^-0.496 ^-0.07 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^0.75 ^-0.495 ^-0.07 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^0.75 ^-0.494 ^-0.069 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^0.75 ^-0.492 ^-0.068 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^0.75 ^-0.491 ^-0.066 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^0.75 ^-0.491 ^-0.065 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^0.75 ^-0.49 ^-0.064 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^0.75 ^-0.49 ^-0.063 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.left_arm2] run {
						name tree/left_arm2_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/left_arm2_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/left_arm2_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^1.25 ^-0.49 ^-0.054 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^1.25 ^-0.49 ^-0.053 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^1.25 ^-0.491 ^-0.052 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^1.25 ^-0.491 ^-0.051 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^1.25 ^-0.492 ^-0.05 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^1.25 ^-0.493 ^-0.049 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^1.25 ^-0.494 ^-0.048 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^1.25 ^-0.495 ^-0.047 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/left_arm2_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^1.25 ^-0.497 ^-0.046 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^1.25 ^-0.498 ^-0.045 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^1.25 ^-0.5 ^-0.045 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^1.25 ^-0.502 ^-0.044 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^1.25 ^-0.504 ^-0.044 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^1.25 ^-0.506 ^-0.044 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^1.25 ^-0.508 ^-0.044 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^1.25 ^-0.51 ^-0.044 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/left_arm2_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^1.25 ^-0.512 ^-0.044 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^1.25 ^-0.514 ^-0.044 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^1.25 ^-0.516 ^-0.045 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^1.25 ^-0.518 ^-0.045 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^1.25 ^-0.52 ^-0.046 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^1.25 ^-0.522 ^-0.047 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^1.25 ^-0.523 ^-0.048 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^1.25 ^-0.524 ^-0.049 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/left_arm2_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^1.25 ^-0.526 ^-0.05 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^1.25 ^-0.526 ^-0.051 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^1.25 ^-0.527 ^-0.052 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^1.25 ^-0.528 ^-0.053 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^1.25 ^-0.528 ^-0.054 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^1.25 ^-0.528 ^-0.056 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^1.25 ^-0.528 ^-0.057 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^1.25 ^-0.527 ^-0.058 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/left_arm2_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^1.25 ^-0.527 ^-0.059 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^1.25 ^-0.526 ^-0.06 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^1.25 ^-0.525 ^-0.061 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^1.25 ^-0.523 ^-0.062 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^1.25 ^-0.522 ^-0.063 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^1.25 ^-0.52 ^-0.064 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^1.25 ^-0.519 ^-0.064 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^1.25 ^-0.517 ^-0.065 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/left_arm2_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^1.25 ^-0.515 ^-0.065 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^1.25 ^-0.513 ^-0.065 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^1.25 ^-0.511 ^-0.065 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^1.25 ^-0.508 ^-0.065 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^1.25 ^-0.506 ^-0.065 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^1.25 ^-0.504 ^-0.065 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^1.25 ^-0.502 ^-0.064 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^1.25 ^-0.5 ^-0.064 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/left_arm2_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^1.25 ^-0.499 ^-0.063 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^1.25 ^-0.497 ^-0.062 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^1.25 ^-0.495 ^-0.061 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^1.25 ^-0.494 ^-0.06 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^1.25 ^-0.493 ^-0.059 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^1.25 ^-0.492 ^-0.058 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^1.25 ^-0.491 ^-0.057 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^1.25 ^-0.491 ^-0.056 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^1.25 ^-0.49 ^-0.055 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.body2] run {
						name tree/body2_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/body2_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/body2_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^1 ^-1.113 ^0 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^1 ^-1.113 ^0 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^1 ^-1.114 ^0 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^1 ^-1.115 ^0 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^1 ^-1.116 ^0 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^1 ^-1.117 ^0 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^1 ^-1.118 ^0 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/body2_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^1 ^-1.12 ^0 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^1 ^-1.122 ^0 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^1 ^-1.124 ^0 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^1 ^-1.125 ^0 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^1 ^-1.127 ^0 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^1 ^-1.13 ^0 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^1 ^-1.132 ^0 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^1 ^-1.134 ^0 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/body2_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^1 ^-1.136 ^0 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^1 ^-1.138 ^0 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^1 ^-1.14 ^0 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^1 ^-1.142 ^0 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^1 ^-1.143 ^0 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^1 ^-1.145 ^0 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^1 ^-1.146 ^0 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^1 ^-1.148 ^0 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/body2_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^1 ^-1.149 ^0 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^1 ^-1.149 ^0 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^1 ^-1.15 ^0 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^1 ^-1.15 ^0 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/body2_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^1 ^-1.149 ^0 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^1 ^-1.148 ^0 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^1 ^-1.147 ^0 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^1 ^-1.145 ^0 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^1 ^-1.144 ^0 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^1 ^-1.142 ^0 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^1 ^-1.14 ^0 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^1 ^-1.138 ^0 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/body2_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^1 ^-1.136 ^0 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^1 ^-1.134 ^0 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^1 ^-1.132 ^0 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^1 ^-1.13 ^0 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^1 ^-1.128 ^0 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^1 ^-1.126 ^0 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^1 ^-1.124 ^0 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^1 ^-1.122 ^0 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/body2_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^1 ^-1.12 ^0 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^1 ^-1.119 ^0 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^1 ^-1.117 ^0 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^1 ^-1.116 ^0 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^1 ^-1.115 ^0 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^1 ^-1.114 ^0 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^1 ^-1.114 ^0 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^1 ^-1.113 ^0 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^1 ^-1.113 ^0 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.bone] run {
						name tree/bone_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/bone_root_0-56
							execute if score .this aj.frame matches 0 run tp @s ^0.746 ^-1.904 ^0.065 ~ ~
							execute if score .this aj.frame matches 56 run tp @s ^0.746 ^-1.904 ^0.065 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.bone2] run {
						name tree/bone2_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/bone2_root_0-56
							execute if score .this aj.frame matches 0 run tp @s ^1.254 ^-1.904 ^-0.065 ~ ~
							execute if score .this aj.frame matches 56 run tp @s ^1.254 ^-1.904 ^-0.065 ~ ~
						}
					}
					execute if entity @s[tag=aj.statues.bone.axe] run {
						name tree/axe_root_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/axe_root_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/axe_root_0-7
								execute if score .this aj.frame matches 0 run tp @s ^1.174 ^-1.196 ^0.367 ~ ~
								execute if score .this aj.frame matches 1 run tp @s ^1.176 ^-1.197 ^0.369 ~ ~
								execute if score .this aj.frame matches 2 run tp @s ^1.178 ^-1.197 ^0.371 ~ ~
								execute if score .this aj.frame matches 3 run tp @s ^1.18 ^-1.197 ^0.373 ~ ~
								execute if score .this aj.frame matches 4 run tp @s ^1.181 ^-1.198 ^0.375 ~ ~
								execute if score .this aj.frame matches 5 run tp @s ^1.183 ^-1.199 ^0.377 ~ ~
								execute if score .this aj.frame matches 6 run tp @s ^1.185 ^-1.2 ^0.379 ~ ~
								execute if score .this aj.frame matches 7 run tp @s ^1.186 ^-1.202 ^0.381 ~ ~
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/axe_root_8-15
								execute if score .this aj.frame matches 8 run tp @s ^1.187 ^-1.203 ^0.382 ~ ~
								execute if score .this aj.frame matches 9 run tp @s ^1.188 ^-1.205 ^0.383 ~ ~
								execute if score .this aj.frame matches 10 run tp @s ^1.189 ^-1.207 ^0.384 ~ ~
								execute if score .this aj.frame matches 11 run tp @s ^1.19 ^-1.209 ^0.385 ~ ~
								execute if score .this aj.frame matches 12 run tp @s ^1.19 ^-1.211 ^0.386 ~ ~
								execute if score .this aj.frame matches 13 run tp @s ^1.191 ^-1.213 ^0.386 ~ ~
								execute if score .this aj.frame matches 14 run tp @s ^1.191 ^-1.215 ^0.386 ~ ~
								execute if score .this aj.frame matches 15 run tp @s ^1.191 ^-1.217 ^0.386 ~ ~
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/axe_root_16-23
								execute if score .this aj.frame matches 16 run tp @s ^1.19 ^-1.219 ^0.386 ~ ~
								execute if score .this aj.frame matches 17 run tp @s ^1.19 ^-1.221 ^0.385 ~ ~
								execute if score .this aj.frame matches 18 run tp @s ^1.189 ^-1.223 ^0.385 ~ ~
								execute if score .this aj.frame matches 19 run tp @s ^1.188 ^-1.225 ^0.384 ~ ~
								execute if score .this aj.frame matches 20 run tp @s ^1.187 ^-1.227 ^0.382 ~ ~
								execute if score .this aj.frame matches 21 run tp @s ^1.186 ^-1.228 ^0.381 ~ ~
								execute if score .this aj.frame matches 22 run tp @s ^1.185 ^-1.23 ^0.379 ~ ~
								execute if score .this aj.frame matches 23 run tp @s ^1.183 ^-1.231 ^0.377 ~ ~
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/axe_root_24-31
								execute if score .this aj.frame matches 24 run tp @s ^1.182 ^-1.232 ^0.375 ~ ~
								execute if score .this aj.frame matches 25 run tp @s ^1.18 ^-1.233 ^0.373 ~ ~
								execute if score .this aj.frame matches 26 run tp @s ^1.178 ^-1.233 ^0.371 ~ ~
								execute if score .this aj.frame matches 27 run tp @s ^1.176 ^-1.234 ^0.369 ~ ~
								execute if score .this aj.frame matches 28 run tp @s ^1.174 ^-1.234 ^0.367 ~ ~
								execute if score .this aj.frame matches 29 run tp @s ^1.172 ^-1.234 ^0.365 ~ ~
								execute if score .this aj.frame matches 30 run tp @s ^1.171 ^-1.234 ^0.363 ~ ~
								execute if score .this aj.frame matches 31 run tp @s ^1.169 ^-1.233 ^0.361 ~ ~
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/axe_root_32-39
								execute if score .this aj.frame matches 32 run tp @s ^1.167 ^-1.232 ^0.358 ~ ~
								execute if score .this aj.frame matches 33 run tp @s ^1.165 ^-1.231 ^0.357 ~ ~
								execute if score .this aj.frame matches 34 run tp @s ^1.164 ^-1.23 ^0.355 ~ ~
								execute if score .this aj.frame matches 35 run tp @s ^1.162 ^-1.229 ^0.353 ~ ~
								execute if score .this aj.frame matches 36 run tp @s ^1.161 ^-1.227 ^0.352 ~ ~
								execute if score .this aj.frame matches 37 run tp @s ^1.16 ^-1.225 ^0.35 ~ ~
								execute if score .this aj.frame matches 38 run tp @s ^1.159 ^-1.223 ^0.349 ~ ~
								execute if score .this aj.frame matches 39 run tp @s ^1.158 ^-1.221 ^0.348 ~ ~
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/axe_root_40-47
								execute if score .this aj.frame matches 40 run tp @s ^1.157 ^-1.219 ^0.348 ~ ~
								execute if score .this aj.frame matches 41 run tp @s ^1.157 ^-1.217 ^0.347 ~ ~
								execute if score .this aj.frame matches 42 run tp @s ^1.157 ^-1.215 ^0.347 ~ ~
								execute if score .this aj.frame matches 43 run tp @s ^1.157 ^-1.213 ^0.347 ~ ~
								execute if score .this aj.frame matches 44 run tp @s ^1.157 ^-1.211 ^0.348 ~ ~
								execute if score .this aj.frame matches 45 run tp @s ^1.158 ^-1.209 ^0.348 ~ ~
								execute if score .this aj.frame matches 46 run tp @s ^1.158 ^-1.207 ^0.349 ~ ~
								execute if score .this aj.frame matches 47 run tp @s ^1.159 ^-1.205 ^0.35 ~ ~
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/axe_root_48-55
								execute if score .this aj.frame matches 48 run tp @s ^1.16 ^-1.204 ^0.351 ~ ~
								execute if score .this aj.frame matches 49 run tp @s ^1.162 ^-1.202 ^0.353 ~ ~
								execute if score .this aj.frame matches 50 run tp @s ^1.163 ^-1.201 ^0.354 ~ ~
								execute if score .this aj.frame matches 51 run tp @s ^1.165 ^-1.2 ^0.356 ~ ~
								execute if score .this aj.frame matches 52 run tp @s ^1.166 ^-1.198 ^0.358 ~ ~
								execute if score .this aj.frame matches 53 run tp @s ^1.168 ^-1.198 ^0.36 ~ ~
								execute if score .this aj.frame matches 54 run tp @s ^1.17 ^-1.197 ^0.362 ~ ~
								execute if score .this aj.frame matches 55 run tp @s ^1.172 ^-1.197 ^0.364 ~ ~
							}
							execute if score .this aj.frame matches 56 run tp @s ^1.174 ^-1.196 ^0.366 ~ ~
						}
					}
					execute store result entity @s Air short 1 run scoreboard players get .this aj.frame
				}
				# Bone Displays
				execute if entity @s[type=minecraft:armor_stand] run {
					name tree/display_bone_name
					execute if entity @s[tag=aj.statues.bone.head] run {
						name tree/head_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/head_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/head_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-23f,0f,0f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-22.901f,0f,0f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-22.8282f,0f,0f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-22.7824f,0f,0f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-22.7642f,0f,0f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-22.774f,0f,0f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-22.8115f,0f,0f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-22.8762f,0f,0f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/head_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-22.9675f,0f,0f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-23.084f,0f,0f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-23.2245f,0f,0f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-23.387f,0f,0f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-23.5697f,0f,0f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-23.7702f,0f,0f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-23.9861f,0f,0f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-24.2145f,0f,0f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/head_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-24.4528f,0f,0f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-24.6979f,0f,0f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-24.9467f,0f,0f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-25.1962f,0f,0f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-25.4433f,0f,0f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-25.6849f,0f,0f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-25.9179f,0f,0f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-26.1394f,0f,0f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/head_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-26.3468f,0f,0f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-26.5374f,0f,0f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-26.7088f,0f,0f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-26.8589f,0f,0f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-26.9858f,0f,0f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-27.088f,0f,0f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-27.1642f,0f,0f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-27.2134f,0f,0f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/head_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-27.235f,0f,0f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-27.2288f,0f,0f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-27.1947f,0f,0f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-27.1333f,0f,0f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-27.0454f,0f,0f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-26.9319f,0f,0f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-26.7943f,0f,0f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-26.6344f,0f,0f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/head_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-26.4541f,0f,0f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-26.2557f,0f,0f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-26.0417f,0f,0f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-25.8146f,0f,0f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-25.5774f,0f,0f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-25.333f,0f,0f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-25.0845f,0f,0f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-24.8349f,0f,0f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/head_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-24.5873f,0f,0f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-24.3449f,0f,0f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-24.1107f,0f,0f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-23.8875f,0f,0f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-23.6783f,0f,0f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-23.4855f,0f,0f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-23.3115f,0f,0f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-23.1586f,0f,0f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-23.0287f,0f,0f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.body] run {
						name tree/body_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/body_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/body_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-7.5f,0f,0f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-7.3885f,0f,0f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-7.2785f,0f,0f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-7.1711f,0f,0f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-7.0679f,0f,0f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-6.9701f,0f,0f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-6.8789f,0f,0f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-6.7954f,0f,0f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/body_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-6.7207f,0f,0f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-6.6557f,0f,0f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-6.6012f,0f,0f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-6.5579f,0f,0f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-6.5264f,0f,0f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-6.507f,0f,0f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-6.5f,0f,0f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-6.5055f,0f,0f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/body_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-6.5233f,0f,0f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-6.5534f,0f,0f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-6.5952f,0f,0f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-6.6483f,0f,0f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-6.712f,0f,0f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-6.7855f,0f,0f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-6.868f,0f,0f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-6.9583f,0f,0f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/body_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-7.0554f,0f,0f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-7.158f,0f,0f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-7.2649f,0f,0f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-7.3747f,0f,0f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-7.486f,0f,0f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-7.5976f,0f,0f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-7.7079f,0f,0f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-7.8156f,0f,0f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/body_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-7.9195f,0f,0f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-8.018f,0f,0f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-8.1101f,0f,0f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-8.1947f,0f,0f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-8.2705f,0f,0f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-8.3368f,0f,0f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-8.3926f,0f,0f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-8.4373f,0f,0f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/body_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-8.4703f,0f,0f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-8.4912f,0f,0f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-8.4998f,0f,0f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-8.4959f,0f,0f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-8.4796f,0f,0f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-8.4511f,0f,0f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-8.4107f,0f,0f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-8.359f,0f,0f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/body_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-8.2965f,0f,0f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-8.2242f,0f,0f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-8.1428f,0f,0f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-8.0534f,0f,0f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-7.9571f,0f,0f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-7.8551f,0f,0f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-7.7487f,0f,0f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-7.6392f,0f,0f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-7.5279f,0f,0f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.right_arm] run {
						name tree/right_arm_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/right_arm_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/right_arm_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-128.3716f,-0.4031f,-30.7724f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-128.0062f,-0.9853f,-30.7018f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-127.7161f,-1.5945f,-30.6304f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-127.505f,-2.223f,-30.559f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-127.3755f,-2.863f,-30.4885f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-127.3292f,-3.5065f,-30.4196f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-127.3667f,-4.1454f,-30.3531f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-127.4874f,-4.7717f,-30.2894f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/right_arm_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-127.6899f,-5.3777f,-30.2291f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-127.9715f,-5.9557f,-30.1726f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-128.3285f,-6.4984f,-30.1201f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-128.7566f,-6.9991f,-30.072f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-129.2503f,-7.4516f,-30.0286f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-129.8033f,-7.85f,-29.9901f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-130.4087f,-8.1895f,-29.9567f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-131.0587f,-8.4657f,-29.9286f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/right_arm_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-131.7454f,-8.6753f,-29.9061f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-132.4599f,-8.8156f,-29.8895f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-133.1935f,-8.8849f,-29.8789f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-133.9368f,-8.8823f,-29.8747f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-134.6805f,-8.8078f,-29.877f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-135.4155f,-8.6625f,-29.8862f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-136.1326f,-8.4481f,-29.9023f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-136.8228f,-8.1673f,-29.9255f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/right_arm_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-137.4776f,-7.8238f,-29.9559f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-138.0889f,-7.4218f,-29.9935f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-138.6493f,-6.9663f,-30.038f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-139.1517f,-6.4631f,-30.0892f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-139.5902f,-5.9185f,-30.1468f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-139.9593f,-5.3393f,-30.2103f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-140.2545f,-4.7328f,-30.2789f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-140.4724f,-4.1064f,-30.3518f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/right_arm_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-140.6102f,-3.4681f,-30.4282f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-140.6664f,-2.8257f,-30.507f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-140.6402f,-2.1873f,-30.5871f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-140.532f,-1.5608f,-30.6671f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-140.3432f,-0.9539f,-30.7459f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-140.0759f,-0.3743f,-30.8221f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-139.7335f,0.171f,-30.8945f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-139.3201f,0.6752f,-30.9617f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/right_arm_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-138.8407f,1.132f,-31.0226f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-138.3012f,1.5358f,-31.0761f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-137.708f,1.8816f,-31.1212f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-137.0685f,2.1651f,-31.1573f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-136.3905f,2.3828f,-31.1836f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-135.6824f,2.5321f,-31.1997f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-134.9528f,2.6109f,-31.2055f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-134.2109f,2.6184f,-31.2011f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/right_arm_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-133.4659f,2.5543f,-31.1865f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-132.7272f,2.4196f,-31.1623f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-132.0039f,2.2158f,-31.1291f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-131.3053f,1.9454f,-31.0876f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-130.6402f,1.6117f,-31.0387f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-130.0169f,1.2189f,-30.9834f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-129.4434f,0.7718f,-30.9228f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-128.927f,0.2759f,-30.8579f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-128.4741f,-0.2625f,-30.7898f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.left_arm] run {
						name tree/left_arm_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/left_arm_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/left_arm_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-123.3127f,1.0016f,33.6534f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-122.951f,1.5794f,33.586f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-122.6645f,2.1841f,33.5177f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-122.4569f,2.8083f,33.4494f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-122.3307f,3.4441f,33.382f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-122.2876f,4.0836f,33.3161f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-122.328f,4.7188f,33.2523f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-122.4514f,5.3418f,33.1913f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/left_arm_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-122.6563f,5.9448f,33.1334f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-122.9399f,6.5201f,33.079f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-123.2988f,7.0607f,33.0285f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-123.7283f,7.5597f,32.9822f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-124.2231f,8.0109f,32.9403f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-124.7768f,8.4086f,32.903f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-125.3825f,8.7479f,32.8707f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-126.0326f,9.0245f,32.8434f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/left_arm_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-126.7189f,9.2349f,32.8214f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-127.4327f,9.3765f,32.805f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-128.1652f,9.4476f,32.7944f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-128.9072f,9.4473f,32.7898f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-129.6493f,9.3756f,32.7916f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-130.3823f,9.2334f,32.7999f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-131.0971f,9.0225f,32.8148f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-131.7848f,8.7455f,32.8366f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/left_arm_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-132.4369f,8.4061f,32.8653f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-133.0453f,8.0083f,32.9009f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-133.6026f,7.5573f,32.9432f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-134.1018f,7.0587f,32.992f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-134.5369f,6.5186f,33.047f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-134.9026f,5.944f,33.1076f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-135.1945f,5.3419f,33.1731f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-135.4089f,4.7199f,33.243f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/left_arm_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-135.5433f,4.0857f,33.3161f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-135.5962f,3.4473f,33.3916f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-135.5668f,2.8125f,33.4684f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-135.4556f,2.1892f,33.5452f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-135.264f,1.5853f,33.6209f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-134.9942f,1.0082f,33.6941f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-134.6495f,0.465f,33.7636f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-134.2342f,-0.0376f,33.8283f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/left_arm_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-133.7532f,-0.4933f,33.887f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-133.2125f,-0.8964f,33.9386f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-132.6185f,-1.242f,33.9822f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-131.9787f,-1.5258f,34.0171f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-131.3008f,-1.7443f,34.0427f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-130.5932f,-1.8948f,34.0586f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-129.8647f,-1.9754f,34.0646f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-129.1242f,-1.985f,34.0608f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/left_arm_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-128.3811f,-1.9236f,34.0473f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-127.6446f,-1.7918f,34.0245f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-126.9239f,-1.5913f,33.9931f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-126.2282f,-1.3245f,33.9537f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-125.5662f,-0.9947f,33.9073f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-124.9463f,-0.606f,33.8547f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-124.3763f,-0.1632f,33.7969f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-123.8635f,0.3283f,33.735f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-123.4143f,0.8622f,33.67f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.right_piv] run {
						name tree/right_piv_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/right_piv_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/right_piv_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [26.0427f,23.9606f,22.5416f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [25.8867f,24.0095f,22.432f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [25.7325f,24.0577f,22.3236f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [25.582f,24.1046f,22.2179f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [25.4372f,24.1497f,22.1162f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [25.2998f,24.1924f,22.0197f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [25.1717f,24.2321f,21.9296f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [25.0543f,24.2684f,21.8472f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/right_piv_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [24.9493f,24.3008f,21.7733f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [24.8578f,24.329f,21.7091f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [24.7812f,24.3526f,21.6552f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [24.7202f,24.3714f,21.6124f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [24.6758f,24.385f,21.5812f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [24.6485f,24.3934f,21.562f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [24.6387f,24.3965f,21.5551f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [24.6463f,24.3941f,21.5605f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/right_piv_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [24.6715f,24.3864f,21.5782f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [24.7138f,24.3734f,21.6079f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [24.7727f,24.3553f,21.6493f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [24.8474f,24.3322f,21.7018f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [24.9371f,24.3046f,21.7648f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [25.0405f,24.2727f,21.8375f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [25.1564f,24.2368f,21.9189f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [25.2833f,24.1975f,22.008f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/right_piv_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [25.4196f,24.1552f,22.1038f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [25.5636f,24.1104f,22.205f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [25.7134f,24.0636f,22.3103f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [25.8673f,24.0156f,22.4184f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [26.0232f,23.9667f,22.5279f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [26.1792f,23.9177f,22.6375f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [26.3334f,23.8692f,22.7459f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [26.4839f,23.8217f,22.8516f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/right_piv_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [26.6288f,23.7759f,22.9534f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [26.7663f,23.7323f,23.0501f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [26.8947f,23.6915f,23.1403f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [27.0124f,23.6541f,23.223f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [27.118f,23.6205f,23.2972f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [27.2102f,23.591f,23.362f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [27.2879f,23.5662f,23.4166f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [27.35f,23.5464f,23.4602f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/right_piv_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [27.3959f,23.5317f,23.4925f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [27.425f,23.5224f,23.5129f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [27.4369f,23.5185f,23.5213f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [27.4315f,23.5203f,23.5175f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [27.4088f,23.5275f,23.5015f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [27.3692f,23.5402f,23.4737f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [27.313f,23.5582f,23.4342f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [27.2411f,23.5812f,23.3837f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/right_piv_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [27.1542f,23.6089f,23.3227f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [27.0535f,23.641f,23.2519f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [26.9402f,23.6771f,23.1722f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [26.8156f,23.7167f,23.0847f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [26.6813f,23.7592f,22.9903f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [26.539f,23.8043f,22.8903f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [26.3904f,23.8512f,22.7859f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [26.2374f,23.8994f,22.6784f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [26.0818f,23.9483f,22.5691f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.left_piv] run {
						name tree/left_piv_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/left_piv_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/left_piv_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-12.3877f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-12.2762f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-12.1661f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-12.0588f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-11.9556f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-11.8578f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-11.7665f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-11.6831f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/left_piv_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-11.6084f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-11.5434f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-11.4889f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-11.4456f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-11.4141f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-11.3947f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-11.3877f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-11.3932f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/left_piv_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-11.411f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-11.441f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-11.4829f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-11.536f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-11.5997f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-11.6732f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-11.7557f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-11.846f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/left_piv_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-11.9431f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-12.0457f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-12.1526f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-12.2624f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-12.3737f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-12.4853f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-12.5956f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-12.7033f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/left_piv_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-12.8071f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-12.9057f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-12.9978f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-13.0824f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-13.1582f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-13.2245f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-13.2803f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-13.325f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/left_piv_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-13.358f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-13.3789f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-13.3875f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-13.3836f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-13.3673f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-13.3388f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-13.2984f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-13.2467f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/left_piv_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-13.1842f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-13.1119f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-13.0305f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-12.9411f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-12.8448f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-12.7428f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-12.6364f,-16.3556f,-7.7873f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-12.5269f,-16.3556f,-7.7873f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-12.4156f,-16.3556f,-7.7873f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.command_block] run {
						name tree/command_block_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/command_block_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/command_block_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [0f,0f,90f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [5.0161f,5.0161f,89.4391f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [9.9697f,9.9697f,87.7634f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [14.799f,14.799f,84.9939f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [19.4439f,19.4439f,81.1649f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [23.8464f,23.8464f,76.3243f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [27.9517f,27.9517f,70.5324f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [31.7085f,31.7085f,63.8614f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/command_block_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [35.0702f,35.0702f,56.3943f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [37.9948f,37.9948f,48.2244f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [40.4457f,40.4457f,39.4534f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [42.3926f,42.3926f,30.1906f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [43.8111f,43.8111f,20.5516f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [44.6834f,44.6834f,10.6564f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [44.9989f,44.9989f,0.6283f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [44.7535f,44.7535f,-9.4076f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/command_block_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [43.9503f,43.9503f,-19.3262f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [42.5992f,42.5992f,-29.0039f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [40.7172f,40.7172f,-38.3201f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [38.3277f,38.3277f,-47.1587f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [35.4605f,35.4605f,-55.4095f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [32.1513f,32.1513f,-62.9697f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [28.4413f,28.4413f,-69.745f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [24.3769f,24.3769f,-75.651f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/command_block_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [20.0086f,20.0086f,-80.6141f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [15.3909f,15.3909f,-84.5723f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [10.5814f,10.5814f,-87.4765f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [5.64f,5.64f,-89.2903f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [0.6283f,0.6283f,-89.9912f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-4.3912f,-4.3912f,-89.5705f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-9.356f,-9.356f,-88.0333f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-14.2042f,-14.2042f,-85.3988f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/command_block_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-18.8753f,-18.8753f,-81.7f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-23.3112f,-23.3112f,-76.9828f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-27.4565f,-27.4565f,-71.3061f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-31.2596f,-31.2596f,-64.7406f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-34.6731f,-34.6731f,-57.3682f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-37.6544f,-37.6544f,-49.2807f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-40.1664f,-40.1664f,-40.579f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-42.1777f,-42.1777f,-31.3715f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/command_block_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-43.6633f,-43.6633f,-21.773f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-44.6047f,-44.6047f,-11.9031f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-44.9901f,-44.9901f,-1.8848f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-44.8148f,-44.8148f,8.1569f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-44.0809f,-44.0809f,18.097f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-42.7975f,-42.7975f,27.8115f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-40.9808f,-40.9808f,37.1794f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-38.6532f,-38.6532f,46.0839f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/command_block_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-35.8438f,-35.8438f,54.4139f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-32.5877f,-32.5877f,62.0658f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-28.9254f,-28.9254f,68.944f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-24.9026f,-24.9026f,74.9629f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-20.5694f,-20.5694f,80.0475f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-15.9798f,-15.9798f,84.1343f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-11.191f,-11.191f,87.1725f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-6.2628f,-6.2628f,89.1241f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-1.2565f,-1.2565f,89.9649f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.head2] run {
						name tree/head2_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/head2_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/head2_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [5f,0f,0f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [4.8885f,0f,0f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [4.7785f,0f,0f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [4.6711f,0f,0f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [4.5679f,0f,0f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [4.4701f,0f,0f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [4.3789f,0f,0f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [4.2954f,0f,0f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/head2_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [4.2207f,0f,0f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [4.1557f,0f,0f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [4.1012f,0f,0f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [4.0579f,0f,0f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [4.0264f,0f,0f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [4.007f,0f,0f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [4f,0f,0f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [4.0055f,0f,0f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/head2_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [4.0233f,0f,0f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [4.0534f,0f,0f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [4.0952f,0f,0f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [4.1483f,0f,0f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [4.212f,0f,0f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [4.2855f,0f,0f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [4.368f,0f,0f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [4.4583f,0f,0f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/head2_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [4.5554f,0f,0f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [4.658f,0f,0f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [4.7649f,0f,0f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [4.8747f,0f,0f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [4.986f,0f,0f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [5.0976f,0f,0f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [5.2079f,0f,0f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [5.3156f,0f,0f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/head2_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [5.4195f,0f,0f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [5.518f,0f,0f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [5.6101f,0f,0f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [5.6947f,0f,0f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [5.7705f,0f,0f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [5.8368f,0f,0f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [5.8926f,0f,0f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [5.9373f,0f,0f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/head2_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [5.9703f,0f,0f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [5.9912f,0f,0f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [5.9998f,0f,0f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [5.9959f,0f,0f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [5.9796f,0f,0f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [5.9511f,0f,0f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [5.9107f,0f,0f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [5.859f,0f,0f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/head2_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [5.7965f,0f,0f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [5.7242f,0f,0f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [5.6428f,0f,0f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [5.5534f,0f,0f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [5.4571f,0f,0f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [5.3551f,0f,0f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [5.2487f,0f,0f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [5.1392f,0f,0f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [5.0279f,0f,0f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.right_arm2] run {
						name tree/right_arm2_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/right_arm2_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/right_arm2_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-48.7408f,-40.5488f,-26.496f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-48.6096f,-40.499f,-26.5812f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-48.4803f,-40.4497f,-26.6652f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-48.3543f,-40.4014f,-26.7469f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-48.2334f,-40.3549f,-26.8252f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-48.1189f,-40.3107f,-26.8993f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-48.0123f,-40.2694f,-26.9683f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-47.9148f,-40.2315f,-27.0313f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/right_arm2_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-47.8277f,-40.1975f,-27.0875f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-47.752f,-40.1679f,-27.1364f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-47.6886f,-40.143f,-27.1773f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-47.6382f,-40.1233f,-27.2097f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-47.6016f,-40.1088f,-27.2333f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-47.579f,-40.1f,-27.2478f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-47.5709f,-40.0968f,-27.2531f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-47.5772f,-40.0993f,-27.249f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/right_arm2_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-47.598f,-40.1074f,-27.2356f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-47.6329f,-40.1212f,-27.2131f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-47.6815f,-40.1403f,-27.1818f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-47.7433f,-40.1645f,-27.1419f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-47.8176f,-40.1936f,-27.094f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-47.9033f,-40.227f,-27.0387f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-47.9996f,-40.2645f,-26.9765f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-48.1051f,-40.3054f,-26.9083f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/right_arm2_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-48.2187f,-40.3493f,-26.8347f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-48.3389f,-40.3955f,-26.7569f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-48.4643f,-40.4436f,-26.6756f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-48.5933f,-40.4928f,-26.5918f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-48.7244f,-40.5426f,-26.5067f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-48.8558f,-40.5923f,-26.4212f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-48.9861f,-40.6413f,-26.3364f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-49.1134f,-40.689f,-26.2534f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/right_arm2_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-49.2363f,-40.7349f,-26.1733f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-49.3531f,-40.7783f,-26.097f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-49.4624f,-40.8188f,-26.0256f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-49.5628f,-40.8558f,-25.96f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-49.653f,-40.889f,-25.9009f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-49.7319f,-40.9179f,-25.8493f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-49.7984f,-40.9422f,-25.8057f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-49.8517f,-40.9617f,-25.7708f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/right_arm2_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-49.8911f,-40.976f,-25.745f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-49.916f,-40.9851f,-25.7286f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-49.9262f,-40.9888f,-25.7219f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-49.9216f,-40.9871f,-25.7249f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-49.9021f,-40.98f,-25.7377f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-49.8681f,-40.9676f,-25.76f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-49.82f,-40.9501f,-25.7916f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-49.7583f,-40.9276f,-25.832f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/right_arm2_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-49.684f,-40.9003f,-25.8807f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-49.5979f,-40.8687f,-25.937f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-49.5012f,-40.8331f,-26.0003f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-49.395f,-40.7939f,-26.0696f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-49.2808f,-40.7515f,-26.1442f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-49.1601f,-40.7065f,-26.223f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-49.0342f,-40.6594f,-26.305f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-48.9049f,-40.6108f,-26.3893f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-48.7737f,-40.5613f,-26.4746f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.left_arm2] run {
						name tree/left_arm2_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/left_arm2_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/left_arm2_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-71.0305f,45.6872f,18.602f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-70.8669f,45.6515f,18.7101f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-70.6806f,45.6161f,18.8167f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-70.4739f,45.5814f,18.9204f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-70.2494f,45.5479f,19.0199f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-70.0099f,45.5159f,19.1141f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-69.7582f,45.486f,19.2018f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-69.4975f,45.4584f,19.282f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/left_arm2_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-69.2311f,45.4337f,19.3536f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-68.9622f,45.4122f,19.4158f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-68.6942f,45.394f,19.4679f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-68.4303f,45.3796f,19.5092f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-68.1738f,45.3691f,19.5393f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-67.9279f,45.3626f,19.5578f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-67.6956f,45.3602f,19.5645f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-67.4799f,45.3621f,19.5593f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/left_arm2_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-67.2834f,45.368f,19.5423f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-67.1087f,45.3781f,19.5136f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-66.9578f,45.392f,19.4736f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-66.8327f,45.4097f,19.4229f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-66.7349f,45.4309f,19.3619f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-66.6658f,45.4552f,19.2914f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-66.6263f,45.4824f,19.2123f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-66.6167f,45.512f,19.1255f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/left_arm2_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-66.6374f,45.5438f,19.032f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-66.688f,45.5771f,18.9331f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-66.768f,45.6117f,18.8298f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-66.8764f,45.6471f,18.7236f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-67.0118f,45.6827f,18.6156f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-67.1725f,45.7182f,18.5072f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-67.3566f,45.7532f,18.3998f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-67.5618f,45.7871f,18.2948f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/left_arm2_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-67.7854f,45.8196f,18.1934f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-68.0247f,45.8503f,18.097f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-68.2766f,45.8788f,18.0067f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-68.538f,45.9049f,17.9237f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-68.8056f,45.9282f,17.8492f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-69.076f,45.9484f,17.784f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-69.3458f,45.9655f,17.7291f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-69.6117f,45.9791f,17.685f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/left_arm2_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-69.8703f,45.9891f,17.6525f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-70.1183f,45.9954f,17.6318f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-70.3527f,45.998f,17.6234f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-70.5705f,45.9968f,17.6272f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-70.769f,45.9919f,17.6433f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-70.9458f,45.9832f,17.6714f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-71.0986f,45.971f,17.7112f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-71.2256f,45.9552f,17.7622f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/left_arm2_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-71.3252f,45.9361f,17.8236f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-71.3963f,45.9139f,17.8948f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-71.4379f,45.8889f,17.9747f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-71.4495f,45.8612f,18.0623f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-71.4311f,45.8313f,18.1566f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-71.3829f,45.7994f,18.2563f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-71.3056f,45.766f,18.3601f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-71.2f,45.7314f,18.4668f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-71.0676f,45.6961f,18.5749f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.body2] run {
						name tree/body2_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/body2_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/body2_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-5f,0f,0f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-4.8885f,0f,0f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-4.7785f,0f,0f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-4.6711f,0f,0f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-4.5679f,0f,0f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-4.4701f,0f,0f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-4.3789f,0f,0f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-4.2954f,0f,0f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/body2_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-4.2207f,0f,0f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-4.1557f,0f,0f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-4.1012f,0f,0f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-4.0579f,0f,0f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-4.0264f,0f,0f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-4.007f,0f,0f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-4f,0f,0f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-4.0055f,0f,0f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/body2_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-4.0233f,0f,0f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-4.0534f,0f,0f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-4.0952f,0f,0f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-4.1483f,0f,0f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-4.212f,0f,0f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-4.2855f,0f,0f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-4.368f,0f,0f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-4.4583f,0f,0f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/body2_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-4.5554f,0f,0f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-4.658f,0f,0f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-4.7649f,0f,0f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-4.8747f,0f,0f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-4.986f,0f,0f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-5.0976f,0f,0f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-5.2079f,0f,0f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-5.3156f,0f,0f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/body2_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-5.4195f,0f,0f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-5.518f,0f,0f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-5.6101f,0f,0f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-5.6947f,0f,0f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-5.7705f,0f,0f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-5.8368f,0f,0f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-5.8926f,0f,0f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-5.9373f,0f,0f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/body2_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-5.9703f,0f,0f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-5.9912f,0f,0f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-5.9998f,0f,0f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-5.9959f,0f,0f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-5.9796f,0f,0f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-5.9511f,0f,0f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-5.9107f,0f,0f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-5.859f,0f,0f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/body2_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-5.7965f,0f,0f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-5.7242f,0f,0f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-5.6428f,0f,0f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-5.5534f,0f,0f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-5.4571f,0f,0f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-5.3551f,0f,0f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-5.2487f,0f,0f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-5.1392f,0f,0f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-5.0279f,0f,0f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.bone] run {
						name tree/bone_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/bone_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/bone_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [-4.1754f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [-4.1817f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [-4.2003f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [-4.2311f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [-4.2736f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [-4.3274f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [-4.3917f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [-4.4659f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/bone_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [-4.5488f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [-4.6396f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [-4.7371f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [-4.84f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [-4.9471f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [-5.057f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [-5.1685f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [-5.28f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/bone_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [-5.3902f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [-5.4977f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [-5.6012f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [-5.6994f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [-5.7911f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [-5.8751f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [-5.9504f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [-6.016f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/bone_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [-6.0712f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [-6.1151f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [-6.1474f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [-6.1676f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [-6.1753f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [-6.1707f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [-6.1536f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [-6.1243f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/bone_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [-6.0832f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [-6.0308f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [-5.9677f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [-5.8948f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [-5.8129f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [-5.723f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [-5.6263f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [-5.524f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/bone_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [-5.4174f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [-5.3077f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [-5.1964f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [-5.0848f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [-4.9744f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [-4.8664f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [-4.7623f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [-4.6634f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/bone_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [-4.5708f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [-4.4858f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [-4.4094f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [-4.3425f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [-4.286f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [-4.2406f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [-4.2069f,14.9416f,6.1622f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [-4.1852f,14.9416f,6.1622f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [-4.1758f,14.9416f,6.1622f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.bone2] run {
						name tree/bone2_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/bone2_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/bone2_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [4.1754f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [4.1817f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [4.2003f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [4.2311f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [4.2736f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [4.3274f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [4.3917f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [4.4659f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/bone2_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [4.5488f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [4.6396f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [4.7371f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [4.84f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [4.9471f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [5.057f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [5.1685f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [5.28f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/bone2_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [5.3902f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [5.4977f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [5.6012f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [5.6994f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [5.7911f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [5.8751f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [5.9504f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [6.016f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/bone2_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [6.0712f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [6.1151f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [6.1474f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [6.1676f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [6.1753f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [6.1707f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [6.1536f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [6.1243f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/bone2_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [6.0832f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [6.0308f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [5.9677f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [5.8948f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [5.8129f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [5.723f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [5.6263f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [5.524f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/bone2_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [5.4174f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [5.3077f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [5.1964f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [5.0848f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [4.9744f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [4.8664f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [4.7623f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [4.6634f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/bone2_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [4.5708f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [4.4858f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [4.4094f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [4.3425f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [4.286f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [4.2406f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [4.2069f,-14.9416f,-8.8378f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [4.1852f,-14.9416f,-8.8378f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [4.1758f,-14.9416f,-8.8378f]
						}
					}
					execute if entity @s[tag=aj.statues.bone.axe] run {
						name tree/axe_display_top
						execute if score .this aj.frame matches 0..56 run {
							name tree/axe_display_0-56
							execute if score .this aj.frame matches 0..7 run {
								name tree/axe_display_0-7
								execute if score .this aj.frame matches 0 run data modify entity @s Pose.Head set value [10.0729f,-19.8687f,-7.3992f]
								execute if score .this aj.frame matches 1 run data modify entity @s Pose.Head set value [9.9349f,-19.7712f,-7.5698f]
								execute if score .this aj.frame matches 2 run data modify entity @s Pose.Head set value [9.7985f,-19.6749f,-7.7381f]
								execute if score .this aj.frame matches 3 run data modify entity @s Pose.Head set value [9.6651f,-19.5809f,-7.9021f]
								execute if score .this aj.frame matches 4 run data modify entity @s Pose.Head set value [9.5367f,-19.4906f,-8.0597f]
								execute if score .this aj.frame matches 5 run data modify entity @s Pose.Head set value [9.4147f,-19.4049f,-8.209f]
								execute if score .this aj.frame matches 6 run data modify entity @s Pose.Head set value [9.3007f,-19.325f,-8.3482f]
								execute if score .this aj.frame matches 7 run data modify entity @s Pose.Head set value [9.1962f,-19.2518f,-8.4756f]
							}
							execute if score .this aj.frame matches 8..15 run {
								name tree/axe_display_8-15
								execute if score .this aj.frame matches 8 run data modify entity @s Pose.Head set value [9.1026f,-19.1864f,-8.5894f]
								execute if score .this aj.frame matches 9 run data modify entity @s Pose.Head set value [9.0211f,-19.1294f,-8.6885f]
								execute if score .this aj.frame matches 10 run data modify entity @s Pose.Head set value [8.9527f,-19.0817f,-8.7715f]
								execute if score .this aj.frame matches 11 run data modify entity @s Pose.Head set value [8.8983f,-19.0437f,-8.8373f]
								execute if score .this aj.frame matches 12 run data modify entity @s Pose.Head set value [8.8586f,-19.0161f,-8.8853f]
								execute if score .this aj.frame matches 13 run data modify entity @s Pose.Head set value [8.8342f,-18.9991f,-8.9149f]
								execute if score .this aj.frame matches 14 run data modify entity @s Pose.Head set value [8.8254f,-18.993f,-8.9255f]
								execute if score .this aj.frame matches 15 run data modify entity @s Pose.Head set value [8.8323f,-18.9978f,-8.9172f]
							}
							execute if score .this aj.frame matches 16..23 run {
								name tree/axe_display_16-23
								execute if score .this aj.frame matches 16 run data modify entity @s Pose.Head set value [8.8547f,-19.0134f,-8.8901f]
								execute if score .this aj.frame matches 17 run data modify entity @s Pose.Head set value [8.8925f,-19.0397f,-8.8443f]
								execute if score .this aj.frame matches 18 run data modify entity @s Pose.Head set value [8.9451f,-19.0764f,-8.7806f]
								execute if score .this aj.frame matches 19 run data modify entity @s Pose.Head set value [9.0118f,-19.1229f,-8.6998f]
								execute if score .this aj.frame matches 20 run data modify entity @s Pose.Head set value [9.0918f,-19.1788f,-8.6027f]
								execute if score .this aj.frame matches 21 run data modify entity @s Pose.Head set value [9.1839f,-19.2432f,-8.4906f]
								execute if score .this aj.frame matches 22 run data modify entity @s Pose.Head set value [9.2871f,-19.3155f,-8.3648f]
								execute if score .this aj.frame matches 23 run data modify entity @s Pose.Head set value [9.3999f,-19.3946f,-8.227f]
							}
							execute if score .this aj.frame matches 24..31 run {
								name tree/axe_display_24-31
								execute if score .this aj.frame matches 24 run data modify entity @s Pose.Head set value [9.521f,-19.4796f,-8.0789f]
								execute if score .this aj.frame matches 25 run data modify entity @s Pose.Head set value [9.6488f,-19.5694f,-7.9221f]
								execute if score .this aj.frame matches 26 run data modify entity @s Pose.Head set value [9.7816f,-19.663f,-7.7588f]
								execute if score .this aj.frame matches 27 run data modify entity @s Pose.Head set value [9.9178f,-19.7591f,-7.591f]
								execute if score .this aj.frame matches 28 run data modify entity @s Pose.Head set value [10.0556f,-19.8565f,-7.4206f]
								execute if score .this aj.frame matches 29 run data modify entity @s Pose.Head set value [10.1934f,-19.954f,-7.2499f]
								execute if score .this aj.frame matches 30 run data modify entity @s Pose.Head set value [10.3293f,-20.0505f,-7.0809f]
								execute if score .this aj.frame matches 31 run data modify entity @s Pose.Head set value [10.4619f,-20.1446f,-6.9158f]
							}
							execute if score .this aj.frame matches 32..39 run {
								name tree/axe_display_32-39
								execute if score .this aj.frame matches 32 run data modify entity @s Pose.Head set value [10.5893f,-20.2353f,-6.7567f]
								execute if score .this aj.frame matches 33 run data modify entity @s Pose.Head set value [10.7101f,-20.3214f,-6.6055f]
								execute if score .this aj.frame matches 34 run data modify entity @s Pose.Head set value [10.8228f,-20.4018f,-6.4642f]
								execute if score .this aj.frame matches 35 run data modify entity @s Pose.Head set value [10.926f,-20.4755f,-6.3344f]
								execute if score .this aj.frame matches 36 run data modify entity @s Pose.Head set value [11.0185f,-20.5417f,-6.2179f]
								execute if score .this aj.frame matches 37 run data modify entity @s Pose.Head set value [11.0992f,-20.5995f,-6.1161f]
								execute if score .this aj.frame matches 38 run data modify entity @s Pose.Head set value [11.1672f,-20.6481f,-6.0303f]
								execute if score .this aj.frame matches 39 run data modify entity @s Pose.Head set value [11.2215f,-20.6871f,-5.9616f]
							}
							execute if score .this aj.frame matches 40..47 run {
								name tree/axe_display_40-47
								execute if score .this aj.frame matches 40 run data modify entity @s Pose.Head set value [11.2616f,-20.7159f,-5.9109f]
								execute if score .this aj.frame matches 41 run data modify entity @s Pose.Head set value [11.287f,-20.7341f,-5.8787f]
								execute if score .this aj.frame matches 42 run data modify entity @s Pose.Head set value [11.2974f,-20.7416f,-5.8655f]
								execute if score .this aj.frame matches 43 run data modify entity @s Pose.Head set value [11.2927f,-20.7382f,-5.8715f]
								execute if score .this aj.frame matches 44 run data modify entity @s Pose.Head set value [11.2729f,-20.724f,-5.8966f]
								execute if score .this aj.frame matches 45 run data modify entity @s Pose.Head set value [11.2382f,-20.6991f,-5.9404f]
								execute if score .this aj.frame matches 46 run data modify entity @s Pose.Head set value [11.1892f,-20.6639f,-6.0025f]
								execute if score .this aj.frame matches 47 run data modify entity @s Pose.Head set value [11.1263f,-20.6188f,-6.082f]
							}
							execute if score .this aj.frame matches 48..55 run {
								name tree/axe_display_48-55
								execute if score .this aj.frame matches 48 run data modify entity @s Pose.Head set value [11.0503f,-20.5644f,-6.1779f]
								execute if score .this aj.frame matches 49 run data modify entity @s Pose.Head set value [10.962f,-20.5013f,-6.2891f]
								execute if score .this aj.frame matches 50 run data modify entity @s Pose.Head set value [10.8627f,-20.4303f,-6.414f]
								execute if score .this aj.frame matches 51 run data modify entity @s Pose.Head set value [10.7534f,-20.3522f,-6.5513f]
								execute if score .this aj.frame matches 52 run data modify entity @s Pose.Head set value [10.6355f,-20.2682f,-6.699f]
								execute if score .this aj.frame matches 53 run data modify entity @s Pose.Head set value [10.5103f,-20.1791f,-6.8554f]
								execute if score .this aj.frame matches 54 run data modify entity @s Pose.Head set value [10.3795f,-20.0861f,-7.0185f]
								execute if score .this aj.frame matches 55 run data modify entity @s Pose.Head set value [10.2447f,-19.9904f,-7.1862f]
							}
							execute if score .this aj.frame matches 56 run data modify entity @s Pose.Head set value [10.1074f,-19.8931f,-7.3565f]
						}
					}
					# Make sure rotation stays aligned with root entity
					execute positioned as @s run tp @s ~ ~ ~ ~ ~
				}
			}
			# Increment frame
			scoreboard players operation @s aj.frame += .aj.statues.framerate aj.i
			# Let the anim_loop know we're still running
			scoreboard players set .aj.animation aj.statues.animating 1
			# If (the next frame is the end of the animation) perform the necessary actions for the loop mode of the animation
			execute unless score @s aj.frame matches 0..57 run function statues:animations/idle/edge
		}
		# Performs a loop mode action depending on what the animation's configured loop mode is
		function edge {
			# Play Once
			execute if score @s aj.statues.idle.loopMode matches 0 run function statues:animations/idle/stop
			# Hold on last frame
			execute if score @s aj.statues.idle.loopMode matches 1 run function statues:animations/idle/pause
			# loop
			execute if score @s aj.statues.idle.loopMode matches 2 run {
				execute (if score @s aj.frame matches ..1) {
					scoreboard players set @s aj.frame 57
				} else {
					scoreboard players set @s aj.frame 0
				}
			}
		}
	}
}