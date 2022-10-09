#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
run pytest
"""
import argparse
import re
import subprocess
import typing as t


def color_print(text: str, color: str = ""):
    mapping = {
        "black": (0, 0, 0),
        "white": (255, 255, 255),
        "red": (255, 0, 0),
        "lime": (0, 255, 0),
        "blue": (0, 0, 255),
        "yellow": (255, 255, 0),
        "cyan": (0, 255, 255),
        "magenta": (255, 0, 255),
        "silver": (192, 192, 192),
        "gray": (128, 128, 128),
        "maroon": (128, 0, 0),
        "olive": (128, 128, 0),
        "green": (0, 128, 0),
        "purple": (128, 0, 128),
        "teal": (0, 128, 128),
        "navy": (0, 0, 128),
    }
    if color:
        try:
            r, g, b = mapping[color]
            print(f"\033[38;2;{r};{g};{b}m{text}\033[0m")
        except KeyError:
            print(
                f'Unsupported color "{color}", use one of "{", ".join(mapping.keys())}".'
            )
    else:
        print(text)


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
    match = re.search(r"^ *def (test.*)\(", line)
    if match:
        return match.groups()[0]
    return None


def main(argv=None):
    args = argument_parser().parse_args(argv)
    lines = args.filename.readlines()
    line_number = args.line_number or len(lines)
    for line in lines[line_number - 1 : 0 : -1]:
        func = get_test_function(line)
        if func:
            cmd = ["pytest", f"{args.filename.name}::{func}", "-vv"]
            color_print(" ".join(cmd), "green")
            subprocess.call(cmd)
            break
    else:
        color_print(
            f'no test found for "{args.filename.name}" from line "{args.line_number}" above',
            "red",
        )


# tests start
def test_get_test_function_1():
    assert get_test_function("def test_xyz():") == "test_xyz"


def test_get_test_function_2():
    assert get_test_function("def test_xyz(x, y):") == "test_xyz"


# tests end


if __name__ == "__main__":
    main()
