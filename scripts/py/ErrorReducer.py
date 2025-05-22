from abc import ABC, abstractmethod
from typing import List, Literal
import sys
import re

# =============== Interfaces ===============


class PipeLine():
    """ 可以批量执行的Rules。用于组合有一定关联、顺序的Rules """

    def __init__(self, transformers: List['Rule']) -> None:
        self.transformers = transformers

    def execute(self, msg: str) -> str:
        for trans in self.transformers:
            msg = trans.compose(msg)
        return msg


class Rule(ABC):
    """ 接口类：描述对字符串的一种修改，也即是对错误信息的一次编辑、过滤 """
    @abstractmethod
    def compose(self, msg: str) -> str:
        pass


class ErrorMsg:
    """  错误信息封装类，方便对错误信息进行流式处理 """

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
    """
    STL容器的处理规则，实际上适用于任意满足`std:xxx<...>`形式的片段\n
    作用: `std::{container_name}<...>` => `alias_name`\n
    \t\t`container_name`: 容器类型，比如 "vector"、"unordered_map"\n
    \t\t`alias_name`: 想替换的别名，如 "VECTOR"、"MAP"
    """

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
    """ 固定字符串替换 `pattern` => `replacement`"""

    def __init__(self, pattern: str, replacement: str) -> None:
        self.pattern = pattern
        self.replacement = replacement

    def compose(self, msg: str) -> str:
        return msg.replace(self.pattern, self.replacement)


class RegexStrRule(Rule):
    """ 正则表达式替换 `re.sub(pattern, replacement, msg) """

    def __init__(self, pattern: str, replacement: str) -> None:
        self.pattern = pattern
        self.replacement = replacement

    def compose(self, msg: str) -> str:
        return re.sub(self.pattern, self.replacement, msg)


class ColorfulRule(Rule):
    """ 为满足正则表达式`pattern`的片段添加ANSI颜色 """

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
        """
        定义需要处理的标准库组件
        `TODO`: 容器类型可以改为从参数指定，不然可能会折叠过多
        """
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
                StdContainerRule("basic_istream"),
                StdContainerRule("basic_ostream"),
                StdContainerRule("shared_ptr"),
                StdContainerRule("unique_ptr"),
                StdContainerRule("weak_ptr"),
            ])

    @staticmethod
    def GetDetailRecudePileLine() -> 'PipeLine':
        """ 折叠所有的detail命名空间中内容: `std::__detail<...>` => `DETAIL` """
        return PipeLine(
            [
                RegexStrRule(r"(std::__detail.*?)(\<)", r"std::DETAIL\2"),
                StdContainerRule("DETAIL", "SOME_STD_DETAIL<>")
            ])

    @staticmethod
    def GetColorfulLogPatternPipeLine() -> 'PipeLine':
        """ 为类似日志的片段添加高亮，比如 路径、error、warning 等"""
        return PipeLine(
            [
                ColorfulRule(r"((([CD]:)|(/usr)|(/home)).*?:(\d+(:)?)*)",
                             rf"{Utils.UNDERLINE}{Utils.FG_GRAY}"),
                ColorfulRule(r"([Ee]rror[:]?)", Utils.BG_RED),
                ColorfulRule(r"([Ff]ail(ed)?:?)", Utils.FG_RED),
                ColorfulRule(r"([Ww]arn(ing)?(s)?[:]?)", Utils.BG_YELLOW),
                ColorfulRule(r"([Nn]ote[:]?)", Utils.BG_BLUE),
            ]
        )

    @staticmethod
    def GetColorfulRecgonizedPatternPipeLine() -> 'PipeLine':
        """ 高亮一些错误信息中 `固定的`、`带有提示性意味`的短语或片段。可以不断更新 """
        return PipeLine(
            [
                ColorfulRule(r"([~]*\^[~]*)", Utils.FG_PURPLE),
                ColorfulRule(r"(no matching function)", Utils.FG_YELLOW),
                ColorfulRule(r"(required( by)?( from)?)", Utils.FG_BLUE),
                ColorfulRule(r"(In .*? of\s)", Utils.FG_BLUE)
            ]
        )


if __name__ == '__main__':
    error_msg = sys.stdin.read()

    msg = ErrorMsg(error_msg)

    msg \
        .reduce_pipe(Utils.GetStdContainerPipeline()) \
        .reduce_pipe(Utils.GetDetailRecudePileLine()) \
        .reduce_pipe(Utils.GetColorfulLogPatternPipeLine()) \
        .reduce_pipe(Utils.GetColorfulRecgonizedPatternPipeLine()) \
        .dump()
