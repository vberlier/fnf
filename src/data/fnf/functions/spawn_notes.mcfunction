#!from "note.mcfunction" import new_note

#!set tick = generate_objective("tick")

#!for node in generate_song("tutorial")
#!function node.parent append
#!if node.partition(8)
execute if score @s __tick__ matches {{ node.range }} run function {{ node.children }}

#!else
#!set notes = node.value

#!if notes | length == 1
execute if score @s __tick__ matches {{ node.range }}
    run {{ new_note(notes[0]) }}

#!else
#!set chord_function = generate_chord(notes)
execute if score @s __tick__ matches {{ node.range }} run function {{ chord_function }}

#!function chord_function
#!for note in notes
#!print new_note(note)
#!endfor
#!endfunction

#!endif

#!endif
#!endfunction
#!endfor
