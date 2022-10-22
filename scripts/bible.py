#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
https://www.rkeplin.com/the-holy-bible-open-source-rest-api/
"""
import argparse
import enum
import json
import re
import os
import typing as t
import urllib.request
from dataclasses import dataclass

BOOKS = {
    1: "Genesis",
    2: "Exodus",
    3: "Leviticus",
    4: "Numbers",
    5: "Deuteronomy",
    6: "Joshua",
    7: "Judges",
    8: "Ruth",
    9: "1 Samuel",
    10: "2 Samuel",
    11: "1 Kings",
    12: "2 Kings",
    13: "1 Chronicles",
    14: "2 Chronicles",
    15: "Ezra",
    16: "Nehemiah",
    17: "Esther",
    18: "Job",
    19: "Psalms",
    20: "Proverbs",
    21: "Ecclesiastes",
    22: "Song of Solomon",
    23: "Isaiah",
    24: "Jeremiah",
    25: "Lamentations",
    26: "Ezekiel",
    27: "Daniel",
    28: "Hosea",
    29: "Joel",
    30: "Amos",
    31: "Obadiah",
    32: "Jonah",
    33: "Micah",
    34: "Nahum",
    35: "Habakkuk",
    36: "Zephaniah",
    37: "Haggai",
    38: "Zechariah",
    39: "Malachi",
    40: "Matthew",
    41: "Mark",
    42: "Luke",
    43: "John",
    44: "Acts",
    45: "Romans",
    46: "1 Corinthians",
    47: "2 Corinthians",
    48: "Galatians",
    49: "Ephesians",
    50: "Philippians",
    51: "Colossians",
    52: "1 Thessalonians",
    53: "2 Thessalonians",
    54: "1 Timothy",
    55: "2 Timothy",
    56: "Titus",
    57: "Philemon",
    58: "Hebrews",
    59: "James",
    60: "1 Peter",
    61: "2 Peter",
    62: "1 John",
    63: "2 John",
    64: "3 John",
    65: "Jude",
    66: "Revelation",
}

REVERSE_LOOKUP = {v.lower().replace(" ", ""): k for k, v in BOOKS.items()}
SPECIAL_ABBREVATIONS = {
    "pm": "Philemon",
    "phm": "Philemon",
    "pp": "Philippians",
    "php": "Philippians",
    "ml": "Malachi",
    "mt": "Matthew",
    "mk": "Mark",
    "mr": "Mark",
    "mrk": "Mark",
    "jd": "Jude",
    "jg": "Judges",
    "jdg": "Judges",
}


@dataclass
class Book:
    number: int
    name: str

    @classmethod
    def get_book(cls, string: str) -> "Book":
        value = string.lower().replace(" ", "")
        try:
            number = int(value)
            return cls(number=number, name=BOOKS[number])
        except ValueError:
            pass

        if value in SPECIAL_ABBREVATIONS:
            number = REVERSE_LOOKUP[
                SPECIAL_ABBREVATIONS[value].lower().replace(" ", "")
            ]
            return cls(number=number, name=BOOKS[number])

        if value in REVERSE_LOOKUP:
            number = REVERSE_LOOKUP[value]
            return cls(number=number, name=BOOKS[number])

        for key in REVERSE_LOOKUP:
            if key.startswith(value):
                number = REVERSE_LOOKUP[key]
                return cls(number=number, name=BOOKS[number])

        raise ValueError(f"Cannot find book {string}")


@dataclass
class Verse:
    """
    {
        "book": {"id": 43, "name": "John", "testament": "NT"},
        "chapterId": 5,
        "id": 43005001,
        "verse": "After this there was a feast of the Jews, and Jesus went up to Jerusalem.",
        "verseId": 1,
    }
    """

    book_number: int
    chapter_number: int
    number: int
    text: str

    def to_markdown(self) -> str:
        linebreak = "\n    "
        text = self.text
        # open quote
        one, two, three = text.partition(' "')
        if two:
            text = f"{one.strip()}{linebreak}{two.strip()}{three}"

        # full stop not at the end of the sentence
        one, two, three = text.partition(". ")
        if two:
            text = f"{one.strip()}{two.strip()}{linebreak}{three}"
        return f"{self.number}. {text}"


@dataclass
class Chapter:
    number: int
    book: Book
    verses: list[Verse]

    @classmethod
    def from_data(cls, data: t.Union[str, bytes]) -> "Chapter":
        verse_list = json.loads(data)
        book_dict = verse_list[0]["book"]
        book_number = book_dict["id"]
        book = Book(number=book_number, name=book_dict["name"])
        number = verse_list[0]["chapterId"]
        return Chapter(
            number=number,
            book=book,
            verses=[
                Verse(
                    book_number=book_number,
                    chapter_number=number,
                    number=v["verseId"],
                    text=v["verse"],
                )
                for v in verse_list
            ],
        )

    def to_markdown(self) -> str:
        return "\n\n".join(
            [f"# {self.book.name} {self.number}"]
            + [verse.to_markdown() for verse in self.verses]
        )


def argument_parser():
    parser = argparse.ArgumentParser(description="make md file for bible chapters")
    parser.add_argument(
        "book", type=Book.get_book, help=f"book name or number of the bible {BOOKS}"
    )
    parser.add_argument("chapter", type=int, help="chapter of the book")
    parser.add_argument(
        "--source",
        "-s",
        choices=["esv", "rkeplin"],
        default="rkeplin",
        help="chapter of the book",
    )
    return parser


def main(argv=None):
    args = argument_parser().parse_args(argv)
    if args.source == "rkeplin":
        response = urllib.request.urlopen(
            f"https://bible-go-api.rkeplin.com/v1/books/{args.book.number}/chapters/{args.chapter}?translation=esv"
        )
        chapter = Chapter.from_data(response.read())
        print(chapter.to_markdown())
    elif args.source == "esv":
        # response = urllib.request.urlopen(
        #     urllib.request.Request(
        #         url=f"https://api.esv.org/v3/passage/text/?q={args.book.name}+{args.chapter}",
        #         headers={
        #             "Authorization": "Token 1a1e2b2cca921c473380316c1b4b59b768e241a3"
        #         },
        #     )
        # )
        # text = json.loads(response.read())["passages"][0]
        text = open(os.path.expanduser("~/tmp/john9.txt")).read()

        verse_mark = re.compile(r"\[(\d+)\]")
        paragraph_mark = re.compile(r"\n\s*\n")
        footnote_mark = re.compile(r"\n\((\d+)\)")

        start = 0
        new_text = []
        for item in verse_mark.finditer(text):
            end = item.span()[0]
            new_text.append(verse_mark.sub(r"\1.", text[start : end - 1]))
            start = end
        new_text.append(verse_mark.sub(r"\1.", text[start : len(text)]))
        new_text = "\n".join(new_text)
        new_text = footnote_mark.sub(r"- (\1)", new_text)
        new_text = paragraph_mark.sub("\n\n---\n\n", new_text)
        lines = []
        verses = []
        for i, line in enumerate(new_text.split("\n")):
            match_verse = re.match(r"^(?P<number>\d+)\. (?P<text>.*)$", line)
            if i == 0:  # heading 1
                lines.append(f"# {line}")
            elif line == "Footnotes":
                lines.append("## Footnotes")
            elif match_verse:
                verse = Verse(
                    book_number=args.book.number,
                    chapter_number=args.chapter,
                    number=int(match_verse.groupdict()["number"]),
                    text=match_verse.groupdict()["text"],
                )
                verses.append(verse)
                lines.append(verse.to_markdown())
            elif "## Footnotes" not in lines and line.strip() not in (
                "",
                "---",
            ):  # sub heading before footnotes
                lines.append(f"## {line}")
            else:
                lines.append(line)
        print("\n".join(lines))


if __name__ == "__main__":
    main(["43", "9", "-s", "esv"])
    # main()


#  ======================================= tests ======================================
from textwrap import dedent  # noqa: E402
from unittest import TestCase  # noqa: E402


class TestBook(TestCase):
    def test_get_book(self):
        books = [
            ("1", "Genesis"),
            ("53", "2 Thessalonians"),
            ("66", "Revelation"),
            ("Genesis", "Genesis"),
            ("2 Thessalonians", "2 Thessalonians"),
            ("2thessalonians", "2 Thessalonians"),
            ("2th", "2 Thessalonians"),
            ("pm", "Philemon"),
            ("pp", "Philippians"),
            ("php", "Philippians"),
        ]
        for string, book in books:
            with self.subTest():
                self.assertEqual(Book.get_book(string).name, book)

    def test_special_abbrevations(self):
        for book in SPECIAL_ABBREVATIONS.values():
            with self.subTest():
                self.assertIn(book, BOOKS.values())

    def _find_dups(self, length: int) -> t.List[t.Tuple[str, str]]:
        names = [key for key in REVERSE_LOOKUP.keys()]
        abbr_names = [(name[:length], name) for name in names]
        abbrs = [name[:length] for name in names]
        dups = []
        for i, abbr in enumerate(abbrs):
            if abbrs.count(abbr) > 1:
                dups.append(abbr_names[i])
        return sorted(list(dups))

    def test_2_initials(self):
        dups = self._find_dups(2)
        print(f"duplicates for 2 initials: {dups}")
        self.assertEqual(len(dups), 26)

    def test_3_initials(self):
        dups = self._find_dups(3)
        print(f"duplicates for 3 initials: {dups}")
        self.assertEqual(len(dups), 4)

    def test_4_initials(self):
        dups = self._find_dups(4)
        print(f"duplicates for 4 initials: {dups}")
        self.assertEqual(len(dups), 2)

    def test_5_initials(self):
        dups = self._find_dups(5)
        self.assertEqual(len(dups), 0)


class TestVerse(TestCase):
    def test_to_markdown(self):
        verses = [
            (
                1,
                "After this there was a feast of the Jews, and Jesus went up to Jerusalem.",
                """
                1. After this there was a feast of the Jews, and Jesus went up to Jerusalem.
                """,
            ),
            (
                6,
                'When Jesus saw him lying there and knew that he had already been there a long time, he said to him, "Do you want to be healed?"',
                """
                6. When Jesus saw him lying there and knew that he had already been there a long time, he said to him,
                    "Do you want to be healed?"
                """,
            ),
            (
                9,
                "And at once the man was healed, and he took up his bed and walked. Now that day was the Sabbath.",
                """
                9. And at once the man was healed, and he took up his bed and walked.
                    Now that day was the Sabbath.
                """,
            ),
        ]
        for number, text, result in verses:
            verse = Verse(book_number=43, chapter_number=5, number=number, text=text)
            with self.subTest():
                self.assertEqual(verse.to_markdown(), dedent(result).strip())
