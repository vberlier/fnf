#!set tick = generate_objective("tick")

execute as @e[tag=fnf.toparrow] at @s positioned ~ ~1 ~ run kill @e[tag=fnf.note,distance=..0.5]

execute as @e[tag=fnf.note] at @s run teleport @s ~ ~{{ all_songs["tutorial"].speed / 10 }} ~

scoreboard players add @s __tick__ 1
