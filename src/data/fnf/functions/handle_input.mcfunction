function wasd:_wasd/mounted

#!set wasd_directions = {"up": "forward", "down": "backward", "left": "left", "right": "right"}

#!for arrow in ["up", "down", "left", "right"]

#!set wasd = "wasd." ~ wasd_directions[arrow]
#!set confirm = generate_objective("confirm." ~ arrow)

execute if entity @s[tag=__wasd__] run commands
    scoreboard players set @s[scores={__confirm__=-1}] __confirm__ 0
    scoreboard players set @s[scores={__confirm__=2}] __confirm__ 0

tag @s remove __wasd__

#!endfor
