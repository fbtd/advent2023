#!/usr/bin/env python3
import sys, json


PART = 2


def candidate_hint_positions(springs, i_start, i_end, hint):
    len_seq = 0
    for i in range(i_start, i_end + 1):
        if i < i_end and springs[i] == "#":
            len_seq += 1
            if len_seq > hint:
                return []
        else:
            len_seq = 0

    candidates = list()
    for i in range(i_start, i_end - hint + 1):
        if (i == 0 or (i != i_start and springs[i - 1] in "?.")) and (
            i + hint == len(springs)
            or (i + hint != i_end and springs[i + hint] in "?.")
        ):
            for ii in range(0, hint):
                # print(f"{i=} {ii=} {springs[i + ii]=}")
                if springs[i + ii] == ".":
                    # print(f"discard: {i=} {ii=}")
                    break
            else:
                # print(f"accept: {i=}")
                candidates.append(i)
        # print()
    return candidates


def combinations_single_hint(springs, i_start, i_end, hint):
    candidates = candidate_hint_positions(springs, i_start, i_end, hint)
    if len(candidates) == 0:
        return 0

    invalid_candidates = 0
    for candidate in candidates:
        if (
            "#" in springs[i_start:candidate]
            or "#" in springs[candidate + hint + 1 : i_end]
        ):
            invalid_candidates += 1
    return len(candidates) - invalid_candidates


cache = dict()


def solve(springs, i_start, i_end, hints):
    # print(f"{i_start=}, {i_end=}, {hints=}")
    cache_key = (
        springs[i_start:i_end]
        + hints
        + (
            i_start == 0,
            i_end == len(springs),
        )
    )
    c = cache.get(cache_key)
    if c:
        # print("h", end="", flush=True)
        return c
    # print("m", end="", flush=True)
    # print(springs[i_start:i_end] + hints)
    # print(len(cache))

    if len(hints) == 0:
        if "#" in springs[i_start:i_end]:
            # print("combinations=0")
            cache[cache_key] = 0
            return 0
        # print("combinations=1")
        cache[cache_key] = 1
        return 1

    if len(hints) == 1:
        combinations = combinations_single_hint(springs, i_start, i_end, hints[0])
        # print(f"{combinations=}")
        cache[cache_key] = combinations
        return combinations

    longest_hint = max(hints)
    i_longest_hint = hints.index(longest_hint)
    left_hints = hints[:i_longest_hint]
    right_hints = hints[i_longest_hint + 1 :]

    total = 0
    candidates = candidate_hint_positions(springs, i_start, i_end, longest_hint)
    # print(f"{candidates=}")
    for candidate in candidates:
        r = 0
        l = solve(springs, i_start, candidate, left_hints)
        if l:
            r = solve(springs, candidate + longest_hint, i_end, right_hints)
            # print(f"{candidate=}, {longest_hint=}: {l=}, {r=}")
        total += l * r
    cache[cache_key] = total
    return total


def main(input_file=sys.stdin):
    inputs = json.loads(input_file.read())
    tot_solutions = 0
    for row in inputs:
        if PART == 1:
            springs = row["springs"]
            hints = row["hints"]
        elif PART == 2:
            springs = ((row["springs"] + ["?"]) * 5)[:-1]
            hints = row["hints"] * 5
        springs = tuple(springs)
        hints = tuple(hints)
        # print(springs, hints)
        tot_solutions += solve(springs, 0, len(springs), hints)

    print(tot_solutions)


if __name__ == "__main__":
    main()
