from dataclasses import dataclass
from typing import Optional, cast
from xml.etree import ElementTree

from beet import Context, Model, Texture
from beet.core.utils import JsonDict, normalize_string
from PIL import Image
from pydantic import BaseModel


def beet_default(ctx: Context):
    config = ctx.meta.get("sprite", cast(JsonDict, {}))
    sprite_manager = ctx.inject(SpriteManager)

    for name, options in config.items():
        sprite_manager.load(
            name,
            texture_url=options["texture"],
            atlas_url=options.get("atlas"),
            scale=options.get("scale", 1),
        )


def sprite_override(ctx: Context):
    ctx.meta["sprite_overrides"] = {}

    yield

    ctx.assets["minecraft:item/diamond_hoe"] = Model(
        {
            "parent": "minecraft:item/handheld",
            "textures": {"layer0": "minecraft:item/diamond_hoe"},
            "overrides": [
                {"predicate": {"custom_model_data": custom_data}, "model": model_name}
                for model_name, custom_data in ctx.meta["sprite_overrides"].items()
            ],
        }
    )


class TextureAtlasInfo(BaseModel):
    x: int
    y: int
    width: int
    height: int


@dataclass
class SpriteManager:
    ctx: Context

    def load(
        self,
        name: str,
        texture_url: str,
        atlas_url: Optional[str] = None,
        scale: float = 1,
    ):
        self.ctx.require(sprite_override)

        cache = self.ctx.cache[__name__]
        generate = self.ctx.generate["sprite"]
        overrides = self.ctx.meta["sprite_overrides"]

        original = Image.open(cache.download(texture_url))

        size = max(original.size)
        square = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        square.paste(original, (0, 0))

        texture_name = generate(name, Texture(square))

        if atlas_url:
            texture_atlas = ElementTree.parse(cache.download(atlas_url))
            sprites = {
                texture_info.attrib["name"]: TextureAtlasInfo(**texture_info.attrib)
                for texture_info in texture_atlas.getroot()
            }

            for sprite_name, info in sorted(sprites.items()):
                model = self.create_sprite(
                    texture_name, info.x, info.y, info.width, info.height, size, scale
                )
                model_name = generate[name](normalize_string(sprite_name), model)
                overrides[model_name] = len(overrides)
        else:
            model = self.create_sprite(
                texture_name, 0, 0, original.width, original.height, size, scale
            )
            model_name = generate(name, model)
            overrides[model_name] = len(overrides)

    @staticmethod
    def create_sprite(
        texture: str,
        x: float,
        y: float,
        width: float,
        height: float,
        size: float,
        scale: float,
    ) -> Model:
        factor = 16 / size
        uv = x * factor, y * factor, (x + width) * factor, (y + height) * factor

        width *= scale
        height *= scale

        left = factor * (size - width) / 2
        top = factor * (size - height) / 2
        right = factor * (left + width)
        bottom = factor * (top + height)

        model = Model(
            {
                "textures": {"all": texture},
                "elements": [
                    {
                        "from": [left, top, 8],
                        "to": [right, bottom, 8],
                        "faces": {
                            "north": {"uv": uv, "texture": "#all"},
                        },
                    }
                ],
            }
        )

        return model
