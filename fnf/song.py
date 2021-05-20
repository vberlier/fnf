from typing import cast

from beet import Context, Function, Sound
from beet.core.utils import JsonDict


def beet_default(ctx: Context):
    config = ctx.meta.get("song", cast(JsonDict, {}))

    cache = ctx.cache["song"]
    generate = ctx.generate["song"]

    for name, data in config.items():
        playsound_commands = [f"playsound fnf.song.{name}_inst master @s"]

        ctx.assets[f"minecraft:song/{name}_inst"] = Sound(
            source_path=cache.download(data["inst"]),
            event=f"fnf.song.{name}_inst",
            stream=True,
        )

        if voices := data.get("voices"):
            playsound_commands.append(f"playsound fnf.song.{name}_voices master @s")
            ctx.assets[f"minecraft:song/{name}_voices"] = Sound(
                source_path=cache.download(voices),
                event=f"fnf.song.{name}_voices",
                stream=True,
            )

        generate(f"play_{name}", Function(playsound_commands))
