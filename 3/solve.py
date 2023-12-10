#!/usr/bin/env python3

import sys

NEIGHBORS = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (-1, -1), (-1, 1), (1, -1)]
SYMBOLS = "#$%&*+-/=@"


def get_valid_coordinates(schematics):
    valid_coordinations = []
    for i, line in enumerate(schematics):
        for j, char in enumerate(line.rstrip()):
            if char in SYMBOLS:
                for di, dj in NEIGHBORS:
                    if 0 <= i + di < len(schematics) and 0 <= j + dj < len(line):
                        valid_coordinations.append((i + di, j + dj))
    return valid_coordinations


def challange_1():
    schematics = sys.stdin.readlines()
    valid_coordinates = get_valid_coordinates(schematics)
    total = 0
    for i, line in enumerate(schematics):
        n = 0
        is_valid = False
        for j, char in enumerate(
            line
        ):  # dont rstrip(), so we get a free \n at the end for the else clause
            if char in "0123456789":
                n = n * 10 + int(char)
                is_valid = is_valid or (i, j) in valid_coordinates
            else:
                if is_valid:
                    total += n
                n = 0
                is_valid = False
    print("total for challange 1: ", total)


# TODO: merge into get_valid_coordinates()
def get_gears(schematics):
    gears = dict()  # (i, j) -> gear_id
    gear_id = 0
    for i, line in enumerate(schematics):
        for j, char in enumerate(line.rstrip()):
            if char in "*":
                for di, dj in NEIGHBORS:
                    if 0 <= i + di < len(schematics) and 0 <= j + dj < len(line):
                        gears[(i + di, j + dj)] = gear_id
                gear_id += 1
    return gears


# TODO: 1 generator for numbers & start/end coodrinates
def challange_2():
    schematics = sys.stdin.readlines()
    gears = get_gears(schematics)
    gear_to_parts = dict()  # gear_id -> [pars1, part2, ...]])
    total = 0
    for i, line in enumerate(schematics):
        n = 0
        belongs_to_gear_id = None
        for j, char in enumerate(
            line
        ):  # dont rstrip(), so we get a free \n at the end for the else clause
            if char in "0123456789":
                n = n * 10 + int(char)
                if (i, j) in gears.keys():
                    belongs_to_gear_id = belongs_to_gear_id or gears[(i, j)]
            else:
                if belongs_to_gear_id is not None and n > 0:
                    gear_to_parts.setdefault(belongs_to_gear_id, []).append(n)
                n = 0
                belongs_to_gear_id = None

    # print(gear_to_parts)
    for parts in gear_to_parts.values():
        if len(parts) == 2:
            total += parts[0] * parts[1]
    print("total for challange 2: ", total)


def main() -> None:
    # challange_1()
    challange_2()


if __name__ == "__main__":
    main()
