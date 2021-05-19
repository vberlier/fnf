from beet import Context


def beet_default(ctx: Context):
    config = ctx.meta.get("display", ())

    for options in config:
        for key in ctx.assets.models.match(*options.pop("match")):
            ctx.assets.models[key].data["display"] = options
