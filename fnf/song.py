from dataclasses import dataclass
from itertools import groupby
from typing import Dict, Iterable, Iterator, List, Optional, cast

from beet import Context, Function, JsonFile, Sound, generate_tree
from beet.core.utils import JsonDict

ARROW_DIRECTIONS = ["left", "down", "up", "right"]
ARROW_COLORS = {"left": "purple", "down": "blue", "up": "green", "right": "red"}


@dataclass
class Note:
    song: "Song"
    tick: int
    arrow: str
    should_press: bool
    hold_duration: int = 0

    @property
    def color(self) -> str:
        return ARROW_COLORS[self.arrow]

    @property
    def hash_string(self) -> str:
        return f"{self.arrow}-{self.should_press}-{self.hold_duration}"

    @property
    def anchor_tag(self) -> str:
        prefix = "bf" if self.should_press else "static"
        return f"fnf.{prefix}{self.arrow}"

    @property
    def sprite_name(self) -> str:
        return f"fnf:sprite/arrows/{self.color}0000"

    @property
    def hold_piece_sprite_name(self) -> str:
        return f"fnf:sprite/arrows/{self.color}_hold_piece0000"

    @property
    def hold_end_sprite_name(self) -> str:
        if self.color == "purple":  # take into account weird typo
            return f"fnf:sprite/arrows/pruple_end_hold0000"
        return f"fnf:sprite/arrows/{self.color}_hold_end0000"

    @property
    def tail(self) -> Iterable[int]:
        return range(0, int(self.hold_duration * self.song.speed) // 2 * 2, 4)


@dataclass
class Song:
    notes: List[Optional[Note]]
    speed: float = 1

    def chords(self) -> Iterator[List[Note]]:
        for _, chord in groupby(filter(None, self.notes), key=lambda note: note.tick):
            yield list(chord)

    def import_notes(self, song_file: JsonFile):
        for section in song_file.data["song"]["notes"]:
            for strum_time, direction, hold in section["sectionNotes"]:
                self.notes.append(
                    Note(
                        self,
                        int(strum_time / 1000 * 20),
                        ARROW_DIRECTIONS[direction % 4],
                        section["mustHitSection"] or direction > 3,
                        int(hold / 1000 * 20),
                    )
                )

        self.notes.sort(key=lambda note: (note.tick, note.should_press) if note else ())

        # Remove notes that can't be played because of the wasd controls
        for i in range(len(self.notes)):
            for j in range(i + 1, min(i + 4, len(self.notes))):
                if (
                    (a := self.notes[i])
                    and (b := self.notes[j])
                    and a.should_press == b.should_press
                    and b.tick - a.tick < 2
                ):
                    arrows = {a.arrow, b.arrow}
                    if arrows == {"left", "right"} or arrows == {"up", "down"}:
                        self.notes[j] = None


def beet_default(ctx: Context):
    config = ctx.meta.get("song", cast(JsonDict, {}))

    cache = ctx.cache["song"]
    generate = ctx.generate["song"]

    songs: Dict[str, Song] = {}
    ctx.template.globals["all_songs"] = songs

    ctx.template.expose(
        "generate_song",
        lambda name: generate_tree(
            ctx.meta["render_path"],
            songs[name].chords(),
            lambda notes: int(notes[0].tick - (80 / songs[name].speed) + 2),
        ),
    )

    ctx.template.expose(
        "generate_chord",
        lambda notes: generate["chord"].path(
            "{hash}", hash=" ".join(note.hash_string for note in notes)
        ),
    )

    ctx.template.expose(
        "generate_tail",
        lambda note: generate["tail"].path(
            "{hash}", hash=(note.arrow, note.hold_duration)
        ),
    )

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

        song = Song([], speed=data.get("speed", 1))
        song.import_notes(JsonFile(source_path=cache.download(data["notes"])))

        songs[name] = song
