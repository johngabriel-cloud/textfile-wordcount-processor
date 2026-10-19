def count_words(sample_text):
    words = sample_text.split()
    word_count = len(words)
    return word_count

if __name__ == "__main__":
    sample_text = "A sample text with several words to count."
    total_word_count = count_words(sample_text)
    print(f"Text has {total_word_count} words.")