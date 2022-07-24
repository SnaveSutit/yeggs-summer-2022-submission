import log.mcm

dir pollen {
	function summon {
		execute align xyz positioned ~.5 ~ ~.5 run summon marker ~ ~ ~ {Tags:['gen.pollen','new']}
		execute as @e[type=marker,limit=1,distance=..2,tag=new] at @s run {
			execute store result score @s id run scoreboard players add last.id v 1
			scoreboard players set @s cap 0
			tag @s remove new
		}
	}
	# function tick {
	# }
	clock 5t {
		execute as @e[type=marker,tag=gen.pollen] at @s run {

			tag @s add this.gen
			scoreboard players operation #old_cap v = @s cap
			execute if entity @s[tag=!captured_by_a] as @a[distance=..3,team=a] run function generators:pollen/cap_a
			execute if entity @s[tag=!captured_by_b] as @a[distance=..3,team=b] run function generators:pollen/cap_b

			execute (if score #old_cap v = @s cap) {
				execute if score @s cap matches 1.. run scoreboard players remove @s cap 1
				execute if score @s cap matches ..-1 run scoreboard players add @s cap 1
				execute unless score @s cap = #old_cap v run function generators:pollen/layered_charging_audio
				particle dust 0 1 0 1 ~ ~.5 ~
			} else {
				function generators:pollen/layered_charging_audio
			}

			execute if score @s cap matches 100.. run function generators:pollen/captured_by_a
			execute if score @s cap matches ..-100 run function generators:pollen/captured_by_b

			tag @s remove this.gen
		}

		# execute if entity @e[type=bee,distance=..3,scores={pollen=..10}] run {
		# 	scoreboard players operation @s 
		# }
	}
	function captured_by_a {
		tag @s add captured_by_a
		tag @s remove captured_by_b
		function generators:pollen/capture_effects
		scoreboard players set @s cap 0
	}
	function captured_by_b {
		tag @s add captured_by_b
		tag @s remove captured_by_a
		function generators:pollen/capture_effects
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
		scoreboard players add @e[type=marker,limit=1,sort=nearest] cap 1
		particle dust 0 0 1 1 ~ ~.5 ~
	}
	function cap_b {
		scoreboard players remove @e[type=marker,limit=1,sort=nearest] cap 1
		particle dust 1 0 0 1 ~ ~.5 ~
	}
}


