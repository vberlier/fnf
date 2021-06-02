from beet import Context


def beet_default(ctx: Context):
    config = ctx.meta.get("resize", ())

    for options in config:
        factor = options["factor"]

        for key in ctx.assets.models.match(*options.pop("match")):
            for cube in ctx.assets.models[key].data["elements"]:
                cube["from"] = [(x - 8) * factor + 8 for x in cube["from"]]
                cube["to"] = [(x - 8) * factor + 8 for x in cube["to"]]
