data modify entity @e[tag=fnf.bf, limit=1] ArmorItems[3].tag.CustomModelData
    set value {{ sprite_overrides["fnf:sprite/bf/bf_idle_dance0000"] }}

#!for arrow in ["up", "down", "left", "right"]

#!set confirm = generate_objective("confirm." ~ arrow)
#!set press = generate_objective("press." ~ arrow)

execute if entity @s[scores={__press__=0..1}] run
    data modify entity @e[tag=fnf.bf, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/bf/bf_note_" ~ arrow ~ "_miss0001"] }}
execute if entity @s[scores={__confirm__=0..1}] run
    data modify entity @e[tag=fnf.bf, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/bf/bf_note_" ~ arrow ~ "0001"] }}
execute if entity @s[scores={__press__=2..}] run
    data modify entity @e[tag=fnf.bf, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/bf/bf_note_" ~ arrow ~ "_miss0003"] }}
execute if entity @s[scores={__confirm__=2..}] run
    data modify entity @e[tag=fnf.bf, limit=1] ArmorItems[3].tag.CustomModelData
        set value {{ sprite_overrides["fnf:sprite/bf/bf_note_" ~ arrow ~ "0003"] }}

#!endfor
