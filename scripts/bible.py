#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
import json
import typing as t
import urllib.request
from dataclasses import dataclass


@dataclass
class Book:
    number: int
    name: str


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
            + [f"{verse.number}. {verse.text}" for verse in self.verses]
        )


def argument_parser():
    parser = argparse.ArgumentParser(description="make md file for bible chapters")
    parser.add_argument("chapter", type=int, help="chapter of the book")
    return parser


def main(argv=None):
    args = argument_parser().parse_args(argv)
    response = urllib.request.urlopen(
        f"https://bible-go-api.rkeplin.com//v1/books/43/chapters/{args.chapter}?translation=esv"
    )
    chapter = Chapter.from_data(response.read())
    print(chapter.to_markdown())


if __name__ == "__main__":
    main()
