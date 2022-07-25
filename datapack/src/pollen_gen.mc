import log.mcm

function summon {
	execute align xyz positioned ~.5 ~.5 ~.5 run summon marker ~ ~ ~ {Tags:['gen.pollen','new']}
	execute as @e[type=marker,tag=gen.pollen,limit=1,distance=..2,tag=new] at @s run {
		execute store result score @s id run scoreboard players add last.id v 1
		summon armor_stand ~ ~-1.5 ~ {Tags:['gen.pollen.ring','new'],Invisible:1b,Marker:false,NoGravity:1b,Invulnerable:1b,ArmorItems:[{},{},{},{id:"minecraft:white_dye",Count:1b}]}
		scoreboard players set @s cap 0
		scoreboard players set @s pollen 0
		scoreboard players set @s gen_timer 0
		tag @s remove new
	}
}

clock 1t {
	execute as @e[type=armor_stand,tag=gen.pollen.ring] at @s run {
		LOOP(200,i) {
			execute if score @s cap matches <%i-100%> run tp @s ~ ~ ~ ~<%(i-100)/4%> ~
		}
	}
}

clock 5t {
	execute as @e[type=marker,tag=gen.pollen] at @s positioned ~ ~-1.5 ~ run {
		tag @s add this.gen
		scoreboard players operation #old_cap v = @s cap
		execute if entity @s[tag=!captured_by_a] as @a[distance=..5,team=a] run function pollen_gen:cap_a
		execute if entity @s[tag=!captured_by_b] as @a[distance=..5,team=b] run function pollen_gen:cap_b

		execute (if score #old_cap v = @s cap) {
			execute if score @s cap matches 1.. run scoreboard players remove @s cap 1
			execute if score @s cap matches ..-1 run scoreboard players add @s cap 1
			execute unless score @s cap = #old_cap v run function pollen_gen:layered_charging_audio
			particle dust 0 1 0 1 ~ ~.5 ~
		} else {
			function pollen_gen:layered_charging_audio
		}

		scoreboard players operation #cap v = @s cap
		execute as @e[type=armor_stand,tag=gen.pollen.ring,distance=..3,limit=1] run scoreboard players operation @s cap = #cap v

		execute if score @s cap matches 100.. run function pollen_gen:captured_by_a
		execute if score @s cap matches ..-100 run function pollen_gen:captured_by_b

		# scoreboard players operation #pollen v = @s pollen
		# execute if score @s pollen matches 1.. as @e[type=bee,dx=0,dy=0,dz=0,scores={pollen=..9}] run {
		# 	scoreboard players set #count v 10
		# 	scoreboard players operation #count v -= @s pollen
		# 	execute if score #pollen v >= #count v run {
		# 		scoreboard players operation #pollen v -= #count v
		# 		scoreboard players set @s pollen 10
		# 		data modify entity @s HasNectar set value true
		# 		tellraw @a ["", {"text":"Gathered "}, {"score":{"name":"#count","objective":"v"}}, {"text":" pollen!"}]
		# 	}
		# }
		# execute unless score #pollen v = @s pollen run scoreboard players operation @s pollen = #pollen v

		LOOP(['a','b'], team) {
			execute if entity @s[tag=captured_by_<%team%>, scores={pollen=..100}] run {
				scoreboard players add @s gen_timer 1
				execute if score @s gen_timer >= #<%team%>.pollen_gen.speed v run {
					playsound minecraft:block.big_dripleaf.tilt_up block @a ~ ~ ~ 1 1
					particle minecraft:falling_nectar ~ ~2 ~ 1 0.5 1 0 10 force @a
					scoreboard players set @s gen_timer 0
					scoreboard players operation @s pollen += #<%team%>.pollen_gen.amount v
				}
			}
		}

		tag @s remove this.gen
	}

}

# function pulse {
# 	<%%config.storage.r = 5%%>
# 	<%%config.storage.points = 100%%>
# 	LOOP(config.storage.points, i) {
# 		<%%
# 			let theta = (2 * Math.PI) / config.storage.points
# 			let angle = (theta * i)
# 			let x = Math.round(config.storage.r*Math.cos(angle) * 1000)/1000
# 			let z = Math.round(config.storage.r*Math.sin(angle) * 1000)/1000
# 			emit(`particle minecraft:end_rod ~ ~-1.3 ~ ${x/10} ${((Math.sin(i)*0.1))/10} ${z/10} 1 0 force`)
# 		%%>
# 	}
# }

function captured_by_a {
	tag @s add captured_by_a
	tag @s remove captured_by_b
	function pollen_gen:capture_effects
	scoreboard players set @s cap 0
}
function captured_by_b {
	tag @s add captured_by_b
	tag @s remove captured_by_a
	function pollen_gen:capture_effects
	scoreboard players set @s cap 0
}
function capture_effects {
	playsound minecraft:item.bottle.fill_dragonbreath player @a ~ ~ ~ 1 1
	stopsound @a[distance=..10] player minecraft:block.beacon.ambient
}
function layered_charging_audio {
	scoreboard players operation # v = @s cap
	execute if score # v matches ..-1 run scoreboard players operation # v *= -1 v
	<%%config.temp = 100%%>
	LOOP(config.temp,i){
		execute if score # v matches <%i+1%> run playsound minecraft:block.beacon.ambient player @a ~ ~ ~ 2 <%0.5+(i * (1.5 / config.temp))%>
	}
}
function cap_a {
	scoreboard players add @e[type=marker,tag=gen.pollen,limit=1,sort=nearest] cap 1
	particle dust 0 0 1 1 ~ ~.5 ~
}
function cap_b {
	scoreboard players remove @e[type=marker,tag=gen.pollen,limit=1,sort=nearest] cap 1
	particle dust 1 0 0 1 ~ ~.5 ~
}

