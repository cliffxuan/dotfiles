#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import json
from pathlib import Path

VIM2VSCODE = {
    "bib": "bibtex",
    "c": "c",
    "coffee": "coffeescript",
    "cpp": "cpp",
    "csh": "shellscript",
    "css": "css",
    "doconce": "doconce",
    "fish": "shellscript",
    "gitcommit": "git-commit",
    "go": "go",
    "html": "html",
    "java": "java",
    "javascript": "javascript",
    "javascript-react": "javascriptreact",
    "json": "json",
    "ksh": "shellscript",
    "latex": "latex",
    "lua": "lua",
    "makefile": "makefile",
    "markdown": "markdown",
    "perl": "perl",
    "php": "php",
    "python": "python",
    "r": "r",
    "ruby": "ruby",
    "rust": "rust",
    "sh": "shellscript",
    "tcsh": "shellscript",
    "tex": "latex",
    "typescript": "typescript",
    "typescript-react": "typescriptreact",
    "us-language": "razor",
    "vue": "vue",
    "xml": "xml",
    "yaml": "yaml",
    "zsh": "shellscript",
    "asm": "asm-intel-x86-generic",
}


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
            return
        except KeyError:
            print(
                f'Unsupported color "{color}", use one of "{", ".join(mapping.keys())}".'
            )
    else:
        print(text)


class UltisnipParser:
    def __init__(self, ultisnip_dir: Path, vscode_dir: Path):
        self.ultisnip_dir = ultisnip_dir
        self.vscode_dir = vscode_dir

    def _replace_variables(self, string):
        """Replaces all of the ultisnips variables with the corresponding vscode
        variables. TODO: Needs updated
        """

        conversions = {"VISUAL": "TM_SELECTED_TEXT"}
        for old, new in conversions.items():
            string = string.replace(old, new)
        return string

    def parse_snippet(self, ultisnip_file: Path) -> dict:
        """
        Parses out the snippets into JSON form with the following schema
        {
            prefix : {
                "prefix": "",
                "description": "",
                "body": "",
            },
            ...
        }
        """
        snippets_dictionary = {}
        with open(ultisnip_file, "r") as f:
            for line in f:
                if line.startswith("snippet"):
                    snippet = {}
                    prefix = line.split()[1].strip()
                    snippet["prefix"] = prefix
                    if '"' in line:
                        snippet_name = line.split('"')[1].strip()
                        snippet["description"] = snippet_name
                    body = []
                    line = next(f)
                    while not line.startswith("endsnippet"):
                        body.append(self._replace_variables(line.strip("\n")))
                        line = next(f)
                    snippet["body"] = body
                    snippets_dictionary[prefix] = snippet
        return snippets_dictionary

    def parse_single_snippets(self) -> dict:
        print("# single snippets")
        data = {}
        for file in self.ultisnip_dir.glob("*.snippets"):
            snippet_data = {
                "snippets": {},
            }
            vscode_file_type = VIM2VSCODE.get(file.stem)

            if file.stem == "all":
                snippet_data["vscode_file"] = self.vscode_dir / "global.code-snippets"
            elif vscode_file_type is None:
                print(f"! cannot find file type {vscode_file_type}")
                continue
            else:
                snippet_data["vscode_file"] = self.vscode_dir.joinpath(
                    vscode_file_type + ".json"
                )

            snippets = self.parse_snippet(file)
            snippet_data["snippets"].update(snippets)
            print(f'- {file.name:30} {"-->":10} {snippet_data["vscode_file"].name:30}')

            data[file.name] = snippet_data
        print("")
        return data

    def parse_directories(self) -> dict:
        data = {}
        print("# directories")
        for direcotry in self.ultisnip_dir.iterdir():
            vim_lang = direcotry.name
            if direcotry.is_dir():
                print(f"- {direcotry.name}")
                lang_data = data.setdefault(
                    f"{direcotry.name}",
                    {
                        "files": [],
                        "vscode_file": Path(
                            self.vscode_dir / f"{VIM2VSCODE.get(vim_lang)}.json"
                        ),
                        "snippets": {},
                    },
                )
                for snippet in direcotry.iterdir():
                    lang_data["files"].append(snippet)
                    print(
                        f'  |- {snippet.name:27} {"-->":10} {lang_data["vscode_file"].name:30}'
                    )
                    lang_data["snippets"].update(self.parse_snippet(snippet))
        return data

    def write_snippets(self, data: dict) -> None:
        if not self.vscode_dir.exists():
            self.vscode_dir.mkdir()

        for ultisnip_file, snippet_data in data.items():
            with open(snippet_data.get("vscode_file"), "w") as f:
                json.dump(snippet_data.get("snippets"), f, indent=2)


def argument_parser():
    parser = argparse.ArgumentParser(
        description="convert vim ultisnip to vscode snippets"
    )
    parser.add_argument("--ultisnips", default="~/.vim/UltiSnips/")
    parser.add_argument(
        "--vscode-snippets", default="~/Library/Application Support/Code/User/snippets/"
    )
    return parser


def main(argv=None):
    args = argument_parser().parse_args(argv)
    parser = UltisnipParser(
        Path(args.ultisnips).expanduser(),
        Path(args.vscode_snippets).expanduser(),
    )
    parser.write_snippets(
        {
            **parser.parse_single_snippets(),
            **parser.parse_directories(),
        }
    )


if __name__ == "__main__":
    main()
