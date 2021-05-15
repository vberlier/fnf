#!for arrow in ["up", "down", "left", "right"]

#!set confirm = generate_objective("confirm." ~ arrow)
#!set bf = "fnf.bf" ~ arrow

scoreboard players set @s[scores={__confirm__=3..}] __confirm__ -1

#!for i in range(3)
execute
    if entity @s[scores={__confirm__=__i__}]
    run data modify
        entity @e[tag=__bf__, limit=1]
        ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/arrows/" ~ arrow ~ "_confirm000" ~ i] }}
#!endfor

execute
    if entity @s[scores={__confirm__=-1}]
    run data modify
        entity @e[tag=__bf__, limit=1]
        ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/arrows/arrow" ~ arrow ~ "0000"] }}

scoreboard players add @s[scores={__confirm__=0..}] __confirm__ 1
scoreboard objectives setdisplay sidebar __confirm__
#!endfor
