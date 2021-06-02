# fnf

> Friday Night Funkin in Minecraft.

This is an experimental recreation of Friday Night Funkin in Minecraft. The project uses [`beet`](https://github.com/mcbeet/beet) to convert the original assets to item models, import the songs and maps, and re-implement the game logic with functions.

- **Demo** https://youtu.be/tm7zzrliiKU

## Building

The project uses [`poetry`](https://python-poetry.org) to manage dependencies.

```bash
$ poetry install
```

You can build the project and link the generated resource pack and data pack to a Minecraft world with the `beet build` command.

```bash
$ beet build --link "New world"
```

Once you have the data pack and the resource pack activated, summon a minecart, jump in, and look north.

---

License - [MIT](https://github.com/vberlier/fnf/blob/main/LICENSE)
