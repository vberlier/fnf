function wasd:_wasd/mounted

#!set wasd_directions = {"up": "forward", "down": "backward", "left": "left", "right": "right"}

#!for arrow in ["up", "down", "left", "right"]

#!set wasd = "wasd." ~ wasd_directions[arrow]
#!set confirm = generate_objective("confirm." ~ arrow)
#!set press = generate_objective("press." ~ arrow)
#!set bf = "fnf.bf" ~ arrow
#!set sustain = "fnf.sustain" ~ arrow

tag @s[scores={__confirm__=-1}] remove __sustain__

execute if entity @s[tag=__wasd__] as @e[tag=__bf__] at @s run commands
    execute unless entity @p[tag=__sustain__] unless entity @e[tag=fnf.note, distance=..0.45] run commands
        scoreboard players set @p[scores={__press__=-1}] __press__ 0
        scoreboard players set @p[scores={__press__=2}] __press__ 0
    execute as @e[tag=fnf.note, distance=..0.45, limit=1] run commands
        scoreboard players set @p[scores={__confirm__=-1}] __confirm__ 0
        scoreboard players set @p[scores={__confirm__=2}] __confirm__ 0
        kill @s
        say {{ arrow }}
        tag @p add __sustain__

tag @s remove __wasd__

#!endfor
