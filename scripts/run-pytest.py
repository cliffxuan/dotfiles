#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
run pytest
"""
import argparse
import re
import subprocess
import typing as t

RED = (255, 0, 0)
GREEN = (0, 255, 0)
YELLOW = (255, 255, 0)


def color_text(text: str, rgb: t.Tuple[int, int, int]) -> str:
    r, g, b = rgb
    return f"\033[38;2;{r};{g};{b}m{text}\033[0m"


def argument_parser():
    parser = argparse.ArgumentParser(
        description="run specifiy test from a file using pytest"
    )
    parser.add_argument(
        "filename", type=argparse.FileType("r"), help="name of the file to run"
    )
    parser.add_argument("--line-number", "-l", type=int, help="line number")
    return parser


def get_test_function(line: str) -> t.Optional[str]:
    try:
        return re.search(r"^ *def (test.*)\(", line).groups()[0]
    except (AttributeError, IndexError):
        return


def main(argv=None):
    args = argument_parser().parse_args(argv)
    lines = args.filename.readlines()
    line_number = args.line_number or len(lines)
    for line in lines[line_number - 1 : 0 : -1]:
        func = get_test_function(line)
        if func:
            subprocess.call(["pytest", f"{args.filename.name}::{func}", "-vv"])
            break
    else:
        print(
            color_text(
                f'no test found for "{args.filename.name}" from line "{args.line_number}" above',
                RED,
            )
        )


def test_get_test_function_1():
    assert get_test_function("def test_xyz():") == "test_xyz"


def test_get_test_function_2():
    assert get_test_function("def test_xyz(x, y):") == "test_xyz"


if __name__ == "__main__":
    main()
