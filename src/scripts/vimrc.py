#!/usr/bin/python
# -*- coding: utf-8 -*-

import commands
import re
try:
    import vim
    __is_vim__ = True
except ImportError:
    # Isn't in vim. Probably this is a test.
    __is_vim__ = False

def paste():
    line, row = vim.current.window.cursor
    for line_text in commands.getoutput("xclip -o").split("\n"):
        vim.current.buffer.append(line_text)

def get_all_words(text):
    words = []
    for line in text.split("\n"):
        words_of_line = [match.group() for match in re.finditer("[A-Za-z_]+", line)]
        words.extend(words_of_line)
    return words

def get_completation(text, used_text):
    words = get_all_words(text)
    completed = ""
    for word in words:
        if word.startswith(used_text) and word != used_text:
            if completed:
                index = get_index_of_equals(completed, word)
                completed = word[:index]
            else:
                completed = word
    return completed

def get_index_of_equals(text1, text2):
    for index, letter1 in enumerate(text1):
        if index < len(text2) - 1:
            if text2[index] != letter1:
                return index
    return min(len(text1), len(text2))

def get_used_text(text):
    match = re.search("[A-Za-z_]+$", text)
    if match == None:
        return ""
    used = text[match.start():]
    return used

def get_unused_text(text):
    match = re.search("[A-Za-z_]+$", text)
    if match == None:
        return text
    unused = text[:match.start()]
    return unused

if __is_vim__:
    pass
    #def auto_complete():
    #    line, row = vim.current.window.cursor
    #    text = vim.current.buffer[line - 1]
    #    unused_text, used_text = get_used_text(text)
    #    text = get_completation(used_text)
    #    if used_text:
    #        if text:
    #            vim.current.buffer[line - 1] = unused_text % text
    #            vim.current.window.cursor = (line, len(unused_text % text))
    #    else:
    #        vim.current.buffer[line - 1] = "    " + unused_text % used_text
    #        vim.current.window.cursor = (line, row + 4)
