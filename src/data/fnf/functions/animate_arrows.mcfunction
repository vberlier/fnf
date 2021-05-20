#!for arrow in ["up", "down", "left", "right"]

#!set confirm = generate_objective("confirm." ~ arrow)
#!set press = generate_objective("press." ~ arrow)
#!set bf = "fnf.bf" ~ arrow

execute if score @s[scores={__press__=0..}] __press__ <= @s __confirm__
    run scoreboard players set @s __confirm__ 4
execute if score @s[scores={__confirm__=0..}] __confirm__ <= @s __press__
    run scoreboard players set @s __press__ 4

scoreboard players set @s[scores={__confirm__=4..}] __confirm__ -1
scoreboard players set @s[scores={__press__=4..}] __press__ -1

#!for i in range(4)
execute if entity @s[scores={__confirm__=__i__}]
    run data modify entity @e[tag=__bf__, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/arrows/" ~ arrow ~ "_confirm000" ~ i] }}
execute if entity @s[scores={__press__=__i__}]
    run data modify entity @e[tag=__bf__, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/arrows/" ~ arrow ~ "_press000" ~ i] }}
#!endfor

execute if entity @s[scores={__confirm__=-1,__press__=-1}]
    run data modify entity @e[tag=__bf__, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/arrows/arrow" ~ arrow ~ "0000"] }}

scoreboard players add @s[scores={__confirm__=0..}] __confirm__ 1
scoreboard players add @s[scores={__press__=0..}] __press__ 1
#!endfor
