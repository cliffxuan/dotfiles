#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
https://www.rkeplin.com/the-holy-bible-open-source-rest-api/
"""
import argparse
import base64
import json
import re
import typing as t
import urllib.parse
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
    "dn": "Daniel",
    "dt": "Deuteronomy",
    "gn": "Genesis",
    "hb": "Habakkuk",
    "hg": "Haggai",
    "jdg": "Judges",
    "jg": "Judges",
    "jm": "James",
    "jn": "John",
    "jr": "Jeremiah",
    "lv": "Leviticus",
    "mc": "Micah",
    "mk": "Mark",
    "ml": "Malachi",
    "mr": "Mark",
    "mt": "Matthew",
    "nb": "Numbers",
    "phm": "Philemon",
    "php": "Philippians",
    "pm": "Philemon",
    "pp": "Philippians",
    "zc": "Zechariah",
    "zp": "Zephaniah",
}
REVERSE_LOOKUP_NO_VOWELS = {
    re.sub(r"[a|e|i|o|u|A|E|I|O|O]", "", k): v for k, v in REVERSE_LOOKUP.items()
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

        if value in REVERSE_LOOKUP:
            number = REVERSE_LOOKUP[value]
            return cls(number=number, name=BOOKS[number])

        if value in SPECIAL_ABBREVATIONS:
            number = REVERSE_LOOKUP[
                SPECIAL_ABBREVATIONS[value].lower().replace(" ", "")
            ]
            return cls(number=number, name=BOOKS[number])

        if value in REVERSE_LOOKUP_NO_VOWELS:
            number = REVERSE_LOOKUP_NO_VOWELS[value]
            return cls(number=number, name=BOOKS[number])

        for key in REVERSE_LOOKUP:
            if key.startswith(value):
                number = REVERSE_LOOKUP[key]
                return cls(number=number, name=BOOKS[number])

        raise ValueError(f"Cannot find book {string}")


def verse_to_markdown(number: int, text: str) -> str:
    linebreak = "\n    "

    # open quote
    text = re.sub(r' "', f'{linebreak}"', text)
    # open quote
    text = re.sub(r" '", f"{linebreak}'", text)
    text = re.sub(r"\.(?!($|'|\")) *", f".{linebreak}", text)
    # closing marks
    for mark in [
        "!",
        ";",
        "'",
        '"',
        "?",
    ]:
        text = re.sub(rf"\{mark} ", f"{mark}{linebreak}", text)
    for link_word in [
        "so that",
        "but",
        "because",
        "not because",
        "therefore",
        "for",
        "in order that",
        "unless",
        "not only",
    ]:
        text = re.sub(
            rf"(,|;)(?P<ref>\(\d+\)|) {link_word} ",
            rf"\1\2{linebreak}{link_word} ",
            text,
        )
    text = re.sub(
        r"(,|;)(?P<ref>\(\d+\)|) as (?!\w+ as)",  # not as many|well|far|... as
        rf"\1\2{linebreak}as ",
        text,
    )
    text = re.sub(
        r"(,|;)(?P<ref>\(\d+\)|) and (?!(\w+ |)(\w+)(\.|;))",  # not oxford comma
        rf"\1\2{linebreak}and ",
        text,
    )
    return f"{number}. {text}"


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

    book: Book
    chapter_number: int
    number: int
    text: str = ""

    def to_markdown(self) -> str:
        return verse_to_markdown(self.number, self.text)


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
                    book=Book.get_book(book_number),
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
    parser = argparse.ArgumentParser(description="make md file for bible verses")
    parser.add_argument(
        "query",
        help="query of bible books and verses",
    )
    parser.add_argument(
        "--source",
        "-s",
        choices=["esv", "rkeplin"],
        default="esv",
        help="chapter of the book",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="debug",
    )
    return parser


def get_esv_passages(start_verse: Verse, end_verse: t.Optional[Verse]) -> str:
    qs = f"{start_verse.book.name}+{start_verse.chapter_number}"
    if start_verse.number > 0:
        qs = f"{qs}:{start_verse.number}"
    if end_verse:
        qs = f"{qs}-{end_verse.chapter_number}"
        if end_verse.number > 0:
            qs = f"{qs}:{end_verse.number}"
    qs = urllib.parse.urlencode({"q": qs})
    token = base64.b85decode(b"F<~)fGGa1gV_`WmF=I40Gc!0aGch(}F=8}gH92B8HaKN6G%;Z_")
    response = urllib.request.urlopen(
        urllib.request.Request(
            url=f"https://api.esv.org/v3/passage/text/?{qs}",
            headers={"Authorization": f"Token {token.decode()}"},
        )
    )
    return json.loads(response.read())["passages"][0]


def process_1(text: str) -> str:
    for old, new in [
        ("“", '"'),
        ("”", '"'),
        ("‘", "'"),
        ("’", "'"),
    ]:
        text = text.replace(old, new)

    verse_mark = re.compile(r"\[(\d+)\]")

    start = 0
    result = []
    for item in verse_mark.finditer(text):
        end = item.span()[0]
        result.append(verse_mark.sub(r"\1.", text[start : end - 1]))
        start = end
    result.append(verse_mark.sub(r"\1.", text[start : len(text)]))
    return "\n".join(result)


def process_2(text: str) -> str:
    LINE_BREAK = "\n"
    PARAGRAPH_BREAK = "\n---\n"
    footnote_mark = re.compile(r"^\((\d+)\)")
    lines = []
    footnotes = []
    for i, line in enumerate(text.split(LINE_BREAK)):
        match_verse = re.match(r"^(?P<number>\d+)\. (?P<text>.*)$", line)
        if i == 0:  # heading 1
            lines.append(f"# {line}")
        elif line == "Footnotes":
            lines.append("## Footnotes")
        elif match_verse:
            if lines[-1] not in (LINE_BREAK, PARAGRAPH_BREAK):  # john12:36
                lines.append(LINE_BREAK)
            lines.append(
                verse_to_markdown(
                    number=int(match_verse.groupdict()["number"]),
                    text=match_verse.groupdict()["text"],
                )
            )
            lines.append(
                LINE_BREAK
            )  # extra line break after a verse TODO compact option
        elif footnote_mark.match(line):
            footnote = footnote_mark.sub(r"- (\1)", line)
            footnotes.append(footnote)
            lines.append(footnote)
        elif "## Footnotes" not in lines:  # before footnote section
            if line.strip() == "":
                if lines[-1] != PARAGRAPH_BREAK:  # paragraph break
                    lines.append(PARAGRAPH_BREAK)
            elif line.startswith(" "):  # a verse across multiple lines, e.g. John 12:15
                # previous line strip ending line break
                if lines[-1] == LINE_BREAK:
                    lines.pop(-1)
                lines.append(line)
            else:  # section header before footnotes
                lines.append(f"## {line}")
        elif line.strip() != "":  # footnote section
            lines.append(line)
    return LINE_BREAK.join(lines)


def get_from_esv(query: str, debug: bool = False) -> str:
    start_verse, end_verse = parse_query(query)
    text = get_esv_passages(start_verse, end_verse)
    if debug:
        with open(f"/tmp/{query}.txt", "w") as f:
            f.write(text)
    # text = open(f"/tmp/{query}.txt").read()
    return process_2(process_1(text))


def parse_single_chapter_no_verse(query: str) -> tuple[str, int]:
    try:
        int(query[-1])  # TODO maybe this should return the whole book?
    except (IndexError, ValueError):
        query = query + "1"  # no chapter then 1
    match = re.match(r"(?P<book>^.+?)(?P<chapter>\d+)", query)
    if not match:
        return "1", 1
    return match.groupdict()["book"], int(match.groupdict()["chapter"])


def parse_single_chapter_with_start_verse(
    query: str,
) -> t.Optional[tuple[str, int, int]]:
    match = re.match(r"^(?P<book>^.+?)(?P<chapter>\d+):(?P<verse>\d+)$", query)
    if not match:
        return None
    return (
        match.groupdict()["book"],
        int(match.groupdict()["chapter"]),
        int(match.groupdict()["verse"] or "1"),
    )


def parse_single_chapter_with_verses(
    query: str,
) -> t.Optional[tuple[str, int, int, int]]:
    match = re.match(
        r"^(?P<book>^.+?)(?P<chapter>\d+):(?P<start_verse>\d+)-(?P<end_verse>\d+)$",
        query,
    )
    if not match:
        return None
    return (
        match.groupdict()["book"],
        int(match.groupdict()["chapter"]),
        int(match.groupdict()["start_verse"]),
        int(match.groupdict()["end_verse"]),
    )


def parse_chapters_with_verses(
    query: str,
) -> t.Optional[tuple[str, int, int, int, int]]:
    match = re.match(
        r"^(?P<book>^.+?)(?P<start_chapter>\d+)(:(?P<start_verse>\d+)|)-(?P<end_chapter>\d+)(:(?P<end_verse>\d+)|)$",
        query,
    )
    if not match:
        return None
    return (
        match.groupdict()["book"],
        int(match.groupdict()["start_chapter"]),
        int(match.groupdict()["start_verse"] or "0"),
        int(match.groupdict()["end_chapter"]),
        int(match.groupdict()["end_verse"] or "0"),
    )


def parse_query(query: str) -> tuple[Verse, t.Optional[Verse]]:
    parsed = parse_chapters_with_verses(query)
    if parsed:
        book, start_chapter, start_verse, end_chapter, end_verse = parsed
        return Verse(
            book=Book.get_book(book),
            chapter_number=int(start_chapter),
            number=start_verse,
        ), Verse(
            book=Book.get_book(book),
            chapter_number=int(end_chapter),
            number=end_verse,
        )

    parsed = parse_single_chapter_with_verses(query)
    if parsed:
        book, chapter, start_verse, end_verse = parsed
        return Verse(
            book=Book.get_book(book),
            chapter_number=int(chapter),
            number=start_verse,
        ), Verse(
            book=Book.get_book(book),
            chapter_number=int(chapter),
            number=end_verse,
        )

    parsed = parse_single_chapter_with_start_verse(query)
    if parsed:
        book, chapter, verse = parsed
        return (
            Verse(
                book=Book.get_book(book),
                chapter_number=int(chapter),
                number=verse,
            ),
            None,
        )

    book, chapter = parse_single_chapter_no_verse(query)
    return (
        Verse(
            book=Book.get_book(book),
            chapter_number=int(chapter),
            number=0,  # entire book
        ),
        None,
    )


def main(argv=None):
    args = argument_parser().parse_args(argv)
    if args.source == "rkeplin":
        response = urllib.request.urlopen(
            f"https://bible-go-api.rkeplin.com/v1/books/{args.book.number}/chapters/{args.chapter}?translation=esv"
        )
        chapter = Chapter.from_data(response.read())
        print(chapter.to_markdown())
    elif args.source == "esv":
        print(get_from_esv(args.query, args.debug))


if __name__ == "__main__":
    # main(["43", "9", "-s", "esv"])
    main()


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
            ("lk", "Luke"),
            ("jhn", "John"),
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

    def test_reverse_lookup_no_vowels_no_dups(self):
        assert len(REVERSE_LOOKUP_NO_VOWELS) == len(BOOKS)

    def test_reverse_lookup_no_vowels_no_overlap(self):
        assert (
            set(REVERSE_LOOKUP_NO_VOWELS.keys()) & SPECIAL_ABBREVATIONS.keys() == set()
        )


class TestVerse(TestCase):
    def test_to_markdown(self):
        verses = [
            (
                1,
                "After this there was a feast of the Jews, and Jesus went up to Jerusalem.",
                """
                1. After this there was a feast of the Jews,
                    and Jesus went up to Jerusalem.
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
                9. And at once the man was healed,
                    and he took up his bed and walked.
                    Now that day was the Sabbath.
                """,
            ),
            (
                21,
                'And they asked him, "What then? Are you Elijah?" He said, "I am not." "Are you the Prophet?" And he answered, "No."',
                """
                21. And they asked him,
                    "What then?
                    Are you Elijah?"
                    He said,
                    "I am not."
                    "Are you the Prophet?"
                    And he answered,
                    "No."
                """,
            ),
            (
                42,
                'He brought him to Jesus. Jesus looked at him and said, "You are Simon the son of John. You shall be called Cephas" (which means Peter(12)).',
                """
                42. He brought him to Jesus.
                    Jesus looked at him and said,
                    "You are Simon the son of John.
                    You shall be called Cephas"
                    (which means Peter(12)).
                """,
            ),
            (
                4,
                'Nicodemus said to him, "How can a man be born when he is old? Can he enter a second time into his mother\'s womb and be born?"',
                """
                4. Nicodemus said to him,
                    "How can a man be born when he is old?
                    Can he enter a second time into his mother's womb and be born?"
                """,
            ),
            (
                25,
                'Jesus said to her, "I am the resurrection and the life.(4) Whoever believes in me, though he die, yet shall he live,',
                """
                25. Jesus said to her,
                    "I am the resurrection and the life.
                    (4) Whoever believes in me, though he die, yet shall he live,
                """,
            ),
            (
                14,
                "so that in Christ Jesus the blessing of Abraham might come to the Gentiles, so that we might receive the promised Spirit(5) through faith.",
                """
                14. so that in Christ Jesus the blessing of Abraham might come to the Gentiles,
                    so that we might receive the promised Spirit(5) through faith.
                """,
            ),
            (
                8,
                'The wind(5) blows where it wishes, and you hear its sound, but you do not know where it comes from or where it goes. So it is with everyone who is born of the Spirit."',
                """
                8. The wind(5) blows where it wishes,
                    and you hear its sound,
                    but you do not know where it comes from or where it goes.
                    So it is with everyone who is born of the Spirit."
                """,
            ),
            (
                27,
                "And he has given him authority to execute judgment, because he is the Son of Man.",
                """
                27. And he has given him authority to execute judgment,
                    because he is the Son of Man.
                """,
            ),
            (
                15,
                "If you were of the world, the world would love you as its own; but because you are not of the world, but I chose you out of the world, therefore the world hates you.",
                """
                15. If you were of the world, the world would love you as its own;
                    but because you are not of the world,
                    but I chose you out of the world,
                    therefore the world hates you.
                """,
            ),
            (
                25,
                "and needed no one to bear witness about man, for he himself knew what was in man.",
                """
            25. and needed no one to bear witness about man,
                for he himself knew what was in man.
            """,
            ),
            (
                5,
                "I have oxen, donkeys, flocks, male servants, and female servants. I have sent to tell my lord, in order that I may find favor in your sight.'\"",
                """
                5. I have oxen, donkeys, flocks, male servants, and female servants.
                    I have sent to tell my lord,
                    in order that I may find favor in your sight.'"
                """,
            ),
            (
                22,
                "If I had not come and spoken to them, they would not have been guilty of sin,(2) but now they have no excuse for their sin.",
                """
                22. If I had not come and spoken to them, they would not have been guilty of sin,(2)
                    but now they have no excuse for their sin.
                """,
            ),
            (
                20,
                "Remember the word that I said to you: 'A servant is not greater than his master.' If they persecuted me, they will also persecute you. If they kept my word, they will also keep yours.",
                """
                20. Remember the word that I said to you:
                    'A servant is not greater than his master.'
                    If they persecuted me, they will also persecute you.
                    If they kept my word, they will also keep yours.
                """,
            ),
            (
                30,
                "How could one have chased a thousand, and two have put ten thousand to flight, unless their Rock had sold them, and the LORD had given them up?",
                """
                30. How could one have chased a thousand,
                    and two have put ten thousand to flight,
                    unless their Rock had sold them,
                    and the LORD had given them up?
                """,
            ),
            (
                4,
                "So Abram went, as the LORD had told him, and Lot went with him. Abram was seventy-five years old when he departed from Haran.",
                """
                4. So Abram went,
                    as the LORD had told him,
                    and Lot went with him.
                    Abram was seventy-five years old when he departed from Haran.
                """,
            ),
            (
                10,
                "and with every living creature that is with you, the birds, the livestock, and every beast of the earth with you, as many as came out of the ark; it is for every beast of the earth.",
                """
                10. and with every living creature that is with you, the birds, the livestock,
                    and every beast of the earth with you, as many as came out of the ark;
                    it is for every beast of the earth.
                """,
            ),
            (
                22,
                "The sons of Shem: Elam, Asshur, Arpachshad, Lud, and Aram.",
                """
                22. The sons of Shem: Elam, Asshur, Arpachshad, Lud, and Aram.
                """,
            ),
            (
                29,
                "Ophir, Havilah, and Jobab; all these were the sons of Joktan.",
                """
                29. Ophir, Havilah, and Jobab;
                    all these were the sons of Joktan.
                """,
            ),
            (
                6,
                "He said this, not because he cared about the poor, but because he was a thief, and having charge of the moneybag he used to help himself to what was put into it.",
                """
                6. He said this,
                    not because he cared about the poor,
                    but because he was a thief,
                    and having charge of the moneybag he used to help himself to what was put into it.
                """,
            ),
            (
                9,
                "When the large crowd of the Jews learned that Jesus(4) was there, they came, not only on account of him but also to see Lazarus, whom he had raised from the dead.",
                """
                9. When the large crowd of the Jews learned that Jesus(4) was there, they came,
                    not only on account of him but also to see Lazarus, whom he had raised from the dead.
                """,
            ),
            (
                31,
                "Now is the judgment of this world; now will the ruler of this world be cast out.",
                """
                31. Now is the judgment of this world;
                    now will the ruler of this world be cast out.
                """,
            ),
        ]
        for number, text, result in verses:
            with self.subTest():
                self.assertEqual(
                    verse_to_markdown(number=number, text=text), dedent(result).strip()
                )


class TestParseQuery(TestCase):
    def test_parse_single_chapter_no_verse(self):
        for query, result in [
            ("", ("1", 1)),
            ("g1", ("g", 1)),
            ("1cor2", ("1cor", 2)),
            ("111", ("1", 11)),
            ("1j", ("1j", 1)),
        ]:
            with self.subTest():
                assert parse_single_chapter_no_verse(query) == result

    def test_parse_single_chapter_with_start_verse(self):
        for query, result in [
            ("g1:1", ("g", 1, 1)),
            ("g1:12", ("g", 1, 12)),
            ("1cor2:11", ("1cor", 2, 11)),
        ]:
            with self.subTest():
                assert parse_single_chapter_with_start_verse(query) == result

    def test_parse_single_chapter_with_verses(self):
        for query, result in [
            ("g1:1-20", ("g", 1, 1, 20)),
            ("g1:12-24", ("g", 1, 12, 24)),
            ("1cor2:11-13", ("1cor", 2, 11, 13)),
        ]:
            with self.subTest():
                assert parse_single_chapter_with_verses(query) == result

    def test_parse_chapters_with_verses(self):
        for query, result in [
            ("g1:1-2:10", ("g", 1, 1, 2, 10)),
            ("g1:12-2:24", ("g", 1, 12, 2, 24)),
            ("1john1-2:10", ("1john", 1, 0, 2, 10)),
            ("1john1-2", ("1john", 1, 0, 2, 0)),
            ("1cor2:11-4:13", ("1cor", 2, 11, 4, 13)),
        ]:
            with self.subTest():
                assert parse_chapters_with_verses(query) == result
