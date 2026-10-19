import pytest
from textfile_wordcount_processor.wordcount import count_words


def test_count_words():
    assert count_words("This is a sample text") == 5

def test_count_words_empty_string():
    assert count_words("") == 0

def test_count_words_only_whitespace():
    assert count_words("   \n\t  ") == 0

def test_count_words_with_newlines_and_tabs():
    assert count_words("one\ntwo\tthree") == 3

def test_count_words_with_punctuation():
    assert count_words("hello, world!") == 2