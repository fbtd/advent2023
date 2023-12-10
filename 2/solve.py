#!/usr/bin/env python3

import sys, re
from dataclasses import dataclass
from typing import Sequence, Generator

MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14


@dataclass
class Game:
    id: int
    blue: int = 0
    green: int = 0
    red: int = 0


# Game 1: 1 blue, 8 green; 14 green, 15 blue; 3 green, 9 blue; 8 green, 8 blue, 1 red; 1 red, 9 green, 10 blue
def games_from_line(line: str) -> Generator[Game, None, None]:
    game_id, line = re.match(r"Game (\d+): (.*)", line).groups()
    game_id = int(game_id)
    for game_str in line.split(";"):
        colors = dict()
        for color in game_str.split(","):
            count, color = re.match(r" *(\d+) (\w+)", color).groups()
            count = int(count)
            colors[color] = count
        yield Game(game_id, **colors)


def is_valid(game: Game) -> bool:
    return game.blue <= MAX_BLUE and game.green <= MAX_GREEN and game.red <= MAX_RED


def challange_1():
    total = 0
    for line in sys.stdin:
        for game in games_from_line(line):
            if not is_valid(game):
                break
        else:
            total += game.id
    print("total for challange 1: ", total)


def power(games: Sequence[Game]) -> int:
    min_game = Game(id=0)
    for game in games:
        min_game.blue = max(min_game.blue, game.blue)
        min_game.green = max(min_game.green, game.green)
        min_game.red = max(min_game.red, game.red)
    return min_game.blue * min_game.green * min_game.red


def challange_2():
    total = 0
    for line in sys.stdin:
        total += power(games_from_line(line))
    print("total for challange 2: ", total)


def main():
    # challange_1()
    challange_2()


if __name__ == "__main__":
    main()
