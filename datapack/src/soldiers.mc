import ./log.mcm

function load {
	scoreboard players set #soldier.IDLE state 0
	scoreboard players set #soldier.GATHER state 1
	scoreboard players set #soldier.ATTACK state 2
}

function summon {
	summon bee ~ ~ ~ {Tags:['soldier','new'], PersistenceRequired:1b,NoAI:false,Health:20f,Attributes:[{Name:generic.max_health,Base:20}],CustomName:'{"text":"Soldier"}',CustomNameVisible:true}
	execute as @e[type=bee,tag=new,distance=..1,limit=1] at @s run {
		execute store result score @s id run scoreboard players add last.id i 1
		scoreboard players set @s state 0
		scoreboard players set @s target -1
		scoreboard players set @s path_timer 0
		tag @s remove new
	}
}

clock 2s {
	execute as @e[type=bee,tag=soldier] run {
		tag @s remove tick_a
		tag @s remove tick_b
	}
	execute store result score #count v if entity @e[type=bee,tag=soldier]
	scoreboard players operation #half v = #count v
	scoreboard players operation #half v /= 2 v
	scoreboard players operation #loop v = #half v
	{
		execute as @e[type=bee,tag=soldier,tag=!tick_a,tag=!tick_b,limit=1] run tag @s add tick_a
		scoreboard players remove #loop v 1
		execute if score #loop v matches 1.. run function $block
	}
	scoreboard players operation #loop v = #half v
	scoreboard players add #loop v 1
	{
		execute as @e[type=bee,tag=soldier,tag=!tick_a,tag=!tick_b,limit=1] run tag @s add tick_b
		scoreboard players remove #loop v 1
		execute if score #loop v matches 1.. run function $block
	}
}

clock 2t {
	execute store success score #soldier.tick_flipflop v if score #soldier.tick_flipflop v matches 0
	execute if score #soldier.tick_flipflop v matches 0 as @e[type=bee,tag=soldier,tag=tick_a] at @s run function soldiers:state_tick
	execute if score #soldier.tick_flipflop v matches 1 as @e[type=bee,tag=soldier,tag=tick_b] at @s run function soldiers:state_tick
}

clock 2t {
	execute as @e[type=bee,tag=soldier] at @s run {
		execute if score @s state = #soldier.GATHER state run function soldiers:update_rotation
		execute if score @s state = #soldier.ATTACK state run function soldiers:update_rotation
	}
}

clock 1t {
	execute as @e[type=bee,tag=soldier] at @s run {
		execute if score @s state = #soldier.GATHER state run function soldiers:apply_motion
		execute if score @s state = #soldier.ATTACK state run function soldiers:apply_motion
	}
}

function state_tick {
	execute if score @s state = #soldier.IDLE state run {
		scoreboard players operation @s target = @e[type=marker,tag=drone_target,tag=swarm,limit=1,sort=nearest] id
		scoreboard players operation @s state = #soldier.GATHER state
	}
	execute if score @s state = #soldier.GATHER state run {
		function soldiers:set_motion
	}
	execute if score @s state = #soldier.ATTACK state run {
		scoreboard players set #deposited v 0
		execute if entity @e[type=marker,tag=hive,distance=..1] run {
			say Damaged enemy hive!
			tp @s ~ -2000 ~
			kill @s
			scoreboard players set #deposited v 1
		}
		function soldiers:set_motion
	}
}

function update_rotation {
	scoreboard players operation # v = @s target
	tag @s add this.soldier
	execute as @e[type=marker,tag=drone_target] if score @s id = # v run {
		tag @s add this.target
		# tp @e[type=bee,tag=this.soldier,distance=..1,limit=1] ~ ~ ~ facing entity @s feet
		execute as @e[type=bee,tag=this.soldier,distance=..1,limit=1] at @s anchored eyes facing entity @e[type=marker,tag=this.target] feet positioned ^ ^ ^0.5 rotated as @s positioned ^ ^ ^1 facing entity @s eyes facing ^ ^ ^-1 positioned as @s rotated ~ 0 run tp @s ~ ~ ~ ~1 ~
		tag @s remove this.target
	}
	tag @s remove this.soldier
}

function set_motion {
	function math:this/get/pos
	scoreboard players operation # v = @s target
	tag @s add this.soldier
	execute as @e[type=marker,tag=drone_target] if score @s id = # v run function math:other/get/pos
	tag @s remove this.soldier
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

