#!tag "minecraft:tick"

execute as @p[nbt={RootVehicle: {}}] at @s run commands
    execute if entity @s[tag=!fnf.riding] run commands
        execute
            at @e[type=minecart,sort=nearest,limit=1]
            positioned ~-5.5 ~ ~-16
            run function fnf:reset_scene

        effect give @s slowness 1000000 255 true
        effect give @s night_vision 1000000 255 true

        #!for arrow in ["up", "down", "left", "right"]
        #!set confirm = generate_objective("confirm." ~ arrow)
        scoreboard players set @s __confirm__ -1
        #!endfor

        tag @s add fnf.riding

    function fnf:handle_input
    function fnf:animate_arrows

execute as @p[nbt=!{RootVehicle: {}}] at @s run commands
    execute if entity @s[tag=fnf.riding] run commands
        effect clear @s
        tag @s remove fnf.riding
