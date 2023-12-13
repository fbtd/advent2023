#!/usr/bin/env python3

# xxZ leads back to the node after xxA
# A --> B --> C -...-> Z --> B
# distance A-Z == distance Z-Z


import sys, re
from dataclasses import dataclass
from math import lcm
from typing import Optional, List, Tuple, Sequence


@dataclass
class Point:
    pos: str
    hash: int = 0
    left: Optional["Point"] = None
    right: Optional["Point"] = None

    def __repr__(self):
        return f"{self.pos} ({self.left.pos}, {self.right.pos})"

    def __post_init__(self):
        self.hash = hash(self.pos)

    def __hash__(self) -> int:
        return self.hash


def load_points(input_file=sys.stdin) -> Tuple[List[Point]]:
    all_points_by_pos = {}
    for line in input_file:
        row_match = re.match(
            r"(?P<pos>[0-9A-Z]+) = \((?P<left>[0-9A-Z]+), (?P<right>[0-9A-Z]+)\)", line
        )
        if row_match is None:
            raise ValueError(f"Could not parse line: {line}")
        row_gd = row_match.groupdict()
        point = Point(pos=row_gd["pos"])
        is_end = row_gd["pos"].endswith("Z")
        is_start = row_gd["pos"].endswith("A")
        all_points_by_pos[point.pos] = {
            "point": point,
            "is_start": is_start,
            "is_end": is_end,
        } | row_gd

    for k, v in all_points_by_pos.items():
        v["point"].left = all_points_by_pos[all_points_by_pos[k]["left"]]["point"]
        v["point"].right = all_points_by_pos[all_points_by_pos[k]["right"]]["point"]

    return (
        [p["point"] for p in all_points_by_pos.values() if p["is_start"]],
        [p["point"] for p in all_points_by_pos.values() if p["is_end"]],
    )


def periodicity(
    start_points: Sequence[Point], end_points: Sequence[Point], directions: str
) -> List[int]:
    steps = 0
    periods = []
    points = start_points
    while points:
        for point in points:
            if point in end_points:
                periods.append(steps)
                points = [p for p in points if p != point]

        if directions[steps % len(directions)] == "L":
            points = [p.left for p in points]
        else:
            points = [p.right for p in points]
        steps += 1
    return periods


def main(input_file=sys.stdin, single=-1):
    directions = input_file.readline().strip()
    input_file.readline()  # Skip blank line
    start_points, end_points = load_points(input_file)
    print(f"{start_points=}\n{end_points=}")
    print()

    periods = periodicity(start_points, end_points, directions)
    print(f"{periods=}, {lcm(*periods)=}")


if __name__ == "__main__":
    main()
