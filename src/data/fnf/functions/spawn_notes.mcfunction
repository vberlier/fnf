#!from "sprite.mcfunction" import new_sprite

#!set tick = generate_objective("tick")

#!for node in generate_song("tutorial")
#!function node.parent append
#!if node.partition(8)
execute if score @s __tick__ matches {{ node.range }} run function {{ node.children }}

#!else
#!set notes = node.value

#!if notes | length == 1
execute if score @s __tick__ matches {{ node.range }}
    at @e[tag={{ notes[0].anchor_tag }}]
    run {{ new_sprite(notes[0].sprite_name,  "~ ~-8 ~0.1", "fnf.note", "fnf.note" ~ notes[0].arrow) }}

#!else
#!set chord_function = generate_chord(notes)
execute if score @s __tick__ matches {{ node.range }} run function {{ chord_function }}

#!function chord_function
#!for note in notes
execute at @e[tag={{ note.anchor_tag }}]
    run {{ new_sprite(note.sprite_name,  "~ ~-8 ~0.1", "fnf.note", "fnf.note" ~ note.arrow) }}
#!endfor
#!endfunction

#!endif

#!endif
#!endfunction
#!endfor
