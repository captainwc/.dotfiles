from abc import ABC, abstractmethod
from typing import List, Literal
import sys
import re

# =============== Interfaces ===============


class PipeLine():
    def __init__(self, transformers: List['Rule']) -> None:
        self.transformers = transformers

    def execute(self, msg: str) -> str:
        for trans in self.transformers:
            msg = trans.compose(msg)
        return msg


class Rule(ABC):
    @abstractmethod
    def compose(self, msg: str) -> str:
        pass


class ErrorMsg:
    def __init__(self, msg: str) -> None:
        self.data = msg

    def __str__(self) -> str:
        return self.data

    def reduce(self, rule: 'Rule') -> 'ErrorMsg':
        self.data = rule.compose(self.data)
        return self

    def reduce_pipe(self, pipe: 'PipeLine') -> 'ErrorMsg':
        self.data = pipe.execute(self.data)
        return self

    def dump(self) -> None:
        print(self.__str__())


# ===============  Concreates ===============

class StdContainerRule(Rule):
    def __init__(self, container_name: str, alias_name: str = "") -> None:
        self.name = container_name
        if alias_name == "":
            self.alias = self.name.upper()
        else:
            self.alias = alias_name

    def compose(self, msg: str) -> str:
        prefix = f'std::{self.name}<'
        start = msg.find(prefix)
        while start != -1:
            end = Utils.FindPairedPos(msg, '<', start+len(prefix))+1
            msg = msg.replace(msg[start:end], self.alias)
            start = msg.find(prefix)
        return msg


class FixedStrRule(Rule):
    def __init__(self, pattern: str, replacement: str) -> None:
        self.pattern = pattern
        self.replacement = replacement

    def compose(self, msg: str) -> str:
        return msg.replace(self.pattern, self.replacement)


class RegexStrRule(Rule):
    def __init__(self, pattern: str, replacement: str) -> None:
        self.pattern = pattern
        self.replacement = replacement

    def compose(self, msg: str) -> str:
        return re.sub(self.pattern, self.replacement, msg)


class ColorfulRule(Rule):
    def __init__(self, pattern: str, color: str) -> None:
        self.pattern = pattern
        self.color = color

    def compose(self, msg: str) -> str:
        return re.sub(self.pattern, rf'{self.color}\1{Utils.RESET}', msg)


# ===============  Utils ===============


class Utils:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"
    ITALIC = "\033[3m"
    STRIKETHROUGH = "\033[9m"

    FG_RED = "\033[31m"
    FG_ORANGE = "\033[38;5;208m"
    FG_YELLOW = "\033[33m"
    FG_GREEN = "\033[32m"
    FG_GRAY = "\033[38;5;245m"
    FG_BLUE = "\033[34m"
    FG_PURPLE = "\033[35m"

    BG_RED = "\033[41m"
    BG_ORANGE = "\033[48;5;208m"
    BG_YELLOW = "\033[43m"
    BG_GREEN = "\033[42m"
    BG_BLUE = "\033[44m"
    BG_PURPLE = "\033[45m"

    @staticmethod
    def FindPairedPos(msg: str,
                      pair: Literal['<', '(', '{', '['], start: int
                      ) -> int:
        pair_mp = {'<': '>', '(': ')', '{': '}', '[': ']'}
        paired = pair_mp.get(pair)
        left_cnt = 1
        idx = start+1
        while idx < len(msg):
            if msg[idx] == pair:
                left_cnt += 1
            elif msg[idx] == paired:
                left_cnt -= 1
                if left_cnt == 0:
                    return idx
            else:
                pass
            idx += 1
        raise RuntimeError(f"Cannot find paired {pair} at {start} in {msg}")

    @staticmethod
    def GetStdContainerPipeline() -> 'PipeLine':
        # TODO: 容器类型可以改为从参数指定，不然可能会折叠过多
        return PipeLine(
            [
                StdContainerRule("__cxx11::basic_string", "STRING"),
                FixedStrRule("_M_string_length", "LENGTH"),
                StdContainerRule("allocator"),
                StdContainerRule("vector"),
                StdContainerRule("map"),
                StdContainerRule("unordered_map"),
                StdContainerRule("set"),
                StdContainerRule("unordered_set"),
                StdContainerRule("variant"),
            ])

    @staticmethod
    def GetDetailRecudePileLine() -> 'PipeLine':
        return PipeLine(
            [
                RegexStrRule(r"(std::__detail.*?)(\<)", r"std::DETAIL\2"),
                StdContainerRule("DETAIL", "SOME_STD_DETAIL<>")
            ])

    @staticmethod
    def GetColorfulPipeLine() -> 'PipeLine':
        return PipeLine(
            [
                ColorfulRule(r"((([CD]:)|(/usr)|(/home)).*?:(\d+(:)?)*)",
                             rf"{Utils.UNDERLINE}{Utils.FG_GRAY}"),
                ColorfulRule(r"([Ee]rror[:]?)", Utils.BG_RED),
                ColorfulRule(r"([Ff]ail(ed)?:?)", Utils.FG_RED),
                ColorfulRule(r"([Ww]arn(ing)?(s)?[:]?)", Utils.BG_YELLOW),
                ColorfulRule(r"([Nn]ote[:]?)", Utils.BG_BLUE),
                ColorfulRule(r"([~]*\^[~]*)", Utils.FG_PURPLE),
                ColorfulRule(r"(no matching function)", Utils.FG_YELLOW),
                ColorfulRule(r"(required( by)?( from)?)", Utils.FG_BLUE),
                ColorfulRule(r"(In .*? of)", Utils.FG_BLUE)
            ]
        )


if __name__ == '__main__':
    error_msg = sys.stdin.read()

    msg = ErrorMsg(error_msg)

    msg \
        .reduce_pipe(Utils.GetStdContainerPipeline()) \
        .reduce_pipe(Utils.GetDetailRecudePileLine()) \
        .reduce_pipe(Utils.GetColorfulPipeLine()) \
        .dump()
