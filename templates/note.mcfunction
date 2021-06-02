#!from "sprite.mcfunction" import new_sprite

#!macro new_note(note)
#!if note.hold_duration == 0
execute at @e[tag={{ note.anchor_tag }}]
    run {{ new_sprite(note.sprite_name,  "~ ~-8 ~0.1", "fnf.note", "fnf.note" ~ note.arrow) }}

#!else
#!set tail_function = generate_tail(note)
execute at @e[tag={{ note.anchor_tag }}] run function {{ tail_function }}

#!function tail_function
#!print new_sprite(note.sprite_name,  "~ ~-8 ~0.1", "fnf.note", "fnf.note" ~ note.arrow)

#!for step in note.tail
#!set pos = "~ ~" ~ (-8 - step / 10) ~ " ~0.1"
#!print new_sprite(note.hold_piece_sprite_name, pos, "fnf.note", "fnf.tail" ~ note.arrow)
#!if loop.last
#!print new_sprite(note.hold_end_sprite_name, pos, "fnf.note", "fnf.tail" ~ note.arrow)
#!endif
#!endfor
#!endfunction

#!endif
#!endmacro
