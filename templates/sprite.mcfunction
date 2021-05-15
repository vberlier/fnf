#!macro new_sprite(name, position)
#!set tags = varargs + ("fnf.sprite",)

summon minecraft:armor_stand {{ position }}
    {
        Invisible: true,
        Marker: true,
        Tags: {{ tags|tojson }},
        ArmorItems: [
            {},
            {},
            {},
            {
                id: "minecraft:diamond_hoe",
                Count: 1b,
                tag: {
                    CustomModelData: {{ sprite_overrides[name] }}
                }
            }
        ]
    }
#!endmacro
