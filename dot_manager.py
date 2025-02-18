import json
import os
import platform
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict, Optional

local_mapper = "dot_conf/map2localpath.json"
repo_mapper = "dot_conf/map2repopath.json"
local_conf = "dot_conf/local.json"
repo_path = os.getcwd()


def _os_type() -> str:
    systype = platform.system()
    if systype == "Windows":
        return "win"
    else:
        return "linux"


RESET = "\033[0m"
BOLD = "\033[1m"
UNDERLINE = "\033[4m"
REVERSE = "\033[7m"

FG_RED = "\033[31m"
FG_GREEN = "\033[32m"
FG_YELLOW = "\033[33m"
FG_BLUE = "\033[34m"

BG_RED = "\033[41m"
BG_GREEN = "\033[42m"
BG_YELLOW = "\033[43m"
BG_BLUE = "\033[44m"

if _os_type() == "win":
    RESET = ""
    BOLD = ""
    UNDERLINE = ""
    REVERSE = ""
    FG_RED = ""
    FG_GREEN = ""
    FG_YELLOW = ""
    FG_BLUE = ""
    BG_RED = ""
    BG_GREEN = ""
    BG_YELLOW = ""
    BG_BLUE = ""

COMMON_FILE_LINK_COLOR = UNDERLINE + FG_BLUE
SUCCESS_FILE_LINK_COLOR = UNDERLINE + FG_BLUE + BOLD


def _warn(msg: str):
    print(f"{BG_YELLOW}[SKIPPED]{RESET} {msg}")


def _log(msg: str):
    print(f"[LOG] {msg}")


def _mapper(type: str) -> Dict[str, str]:
    """
    ``Return`` a dict\n
    ``type`` "local" or "repo", this two's mapper is different
    """
    if type == "local":
        with open(local_mapper, "r", encoding="utf-8") as file:
            if _os_type() == "win":
                if not os.path.exists(local_conf):
                    raise FileNotFoundError(
                        f"""!

{FG_YELLOW} You should config your windows-user-home first! {RESET}

By create a file named {BOLD}{FG_GREEN} <<{local_conf}>> {RESET}at the root of this git repo,
    in which specify your "win-user-home":"C:/msys2/home/xxx".
    and you can also just use "~"

This is because the difference below:
(1) If you are using [mingw64], your .bashrc maybe stored in C:/Users/xxx/.
    this case can use os.path.expanduser("~") just like unix-link.
(2) But if you are using [mysy2], your .bashrc maybe stored in [MYSY_HOME]/home/xxx/.
So you'd better specify them yourself, and of course, you'll do this work only once.

And the file {local_conf} you will create, won't added to the repo,
    if you insist to do this, modify the .gitignore file please.
                        """
                    )
                else:
                    win_home = ""
                    with open(local_conf, "r") as f:
                        win_home = json.load(f)["win-user-home"]
                    win_home = os.path.expanduser(win_home)
                    tmp = json.load(file)[_os_type()]
                    for k, val in tmp.items():
                        tmp[k] = os.path.normpath(
                            os.path.expanduser(
                                val.replace("${win-user-home}", win_home)
                            )
                        )
                    return tmp
            else:
                tmp = json.load(file)[_os_type()]
                for k, val in tmp.items():
                    tmp[k] = os.path.normpath(os.path.expanduser(val))
                return tmp
    elif type == "repo":
        with open(repo_mapper, "r", encoding="utf-8") as file:
            tmp = json.load(file)[_os_type()]
            for k, val in tmp.items():
                tmp[k] = os.path.expanduser(
                    os.path.join(os.path.normpath(repo_path), os.path.normpath(val))
                )
            return tmp
    else:
        raise RuntimeError(f"Unknown type {type}, ['os', 'repo'] supported.")


def _get_all_supported_conf():
    mapper = _mapper("repo")
    return [k for k in mapper]


def _get_conf_path(type: str, conf: str) -> Optional[str]:
    mapper = _mapper(type)
    try:
        pt = mapper[conf]
    except KeyError:
        _warn(
            f"""There is no item about {COMMON_FILE_LINK_COLOR} \"{conf}\" {RESET} in {
                FG_YELLOW
            }map2{BG_BLUE}{BOLD}{type}{RESET}{FG_YELLOW}path.json{
                RESET
            } file, please check it."""
        )
        return None
    return os.path.normpath(pt)


def _get_paired_path(conf: str) -> list[Optional[str]]:
    local_path = _get_conf_path("local", conf)
    repo_path = _get_conf_path("repo", conf)
    if local_path == "." or local_path == "":
        local_path = None
    return [local_path, repo_path]


def _suffix():
    now = datetime.now()
    timestamp = now.strftime("%Y-%m%d-%H%M%S")
    return f".bak_ByDotFileManager_{timestamp}"


def _handle_exists_file(filename: str, del_exist: bool):
    if del_exist:
        if os.path.isdir(filename):
            shutil.rmtree(filename)
            _log(
                f"{FG_YELLOW}[RemoveDir]{RESET}: Delete {COMMON_FILE_LINK_COLOR}{filename}{RESET}"
            )
        elif os.path.islink(filename):
            os.unlink(filename)
            _log(
                f"{FG_YELLOW}[RemoveLink]{RESET}: Delete {COMMON_FILE_LINK_COLOR}{filename}{RESET}"
            )
        else:
            os.remove(filename)
            _log(
                f"{FG_YELLOW}[RemoveFile]{RESET}: Delete {COMMON_FILE_LINK_COLOR}{filename}{RESET}"
            )
    else:
        new_name = f"{filename}{_suffix()}"
        os.rename(filename, new_name)
        _log(
            f"{FG_GREEN}[Rename]{RESET}: {COMMON_FILE_LINK_COLOR}{filename}{RESET} => {COMMON_FILE_LINK_COLOR}{new_name}{RESET}"
        )


def _make_link(repo_source: Optional[str], local_link: Optional[str], del_exist=False):
    # check repo
    if repo_source is None or not os.path.exists(repo_source):
        _warn(
            f"""{FG_YELLOW}[CONF-MAPPED,REPO-MISS]{RESET}: {COMMON_FILE_LINK_COLOR}{
                repo_source
            }{RESET} unexists, skip create this file's symbolink to {
                COMMON_FILE_LINK_COLOR
            }{local_link}{RESET}"""
        )
        return

    # check local
    if local_link is None:
        _warn(
            f"{FG_YELLOW}[REPO-HAS,LOCAL-UNMAPPED]{RESET}: {COMMON_FILE_LINK_COLOR}{repo_source}{RESET} don't have mapped path in your os"
        )
        return

    if os.path.islink(local_link):
        old_target = os.readlink(local_link)
        if os.path.exists(old_target) and os.path.samefile(old_target, repo_source):
            _log(
                f"{FG_GREEN}[Link exist]{RESET} {SUCCESS_FILE_LINK_COLOR}{local_link}{RESET} => {SUCCESS_FILE_LINK_COLOR}{old_target}{RESET}"
            )
            return
        else:
            _handle_exists_file(local_link, del_exist)
    else:
        if os.path.exists(local_link):
            _handle_exists_file(local_link, del_exist)
        else:
            par = Path(local_link).parent
            if not os.path.exists(par):
                os.makedirs(par)

    # make link
    try:
        is_dir = os.path.isdir(repo_source)
        os.symlink(repo_source, local_link, target_is_directory=is_dir)
        ## make sure that the creatation done successfully
        if os.path.exists(os.readlink(local_link)) and os.path.samefile(
            os.readlink(local_link), repo_source
        ):
            _log(
                f"{BG_GREEN}[SUCCESS]{RESET} {SUCCESS_FILE_LINK_COLOR}{local_link}{RESET} => {SUCCESS_FILE_LINK_COLOR}{repo_source}{RESET} DONE!"
            )
        else:
            _warn(
                f"{BG_RED}[FAILED, BROKEN SYMBOLIC]{RESET} {COMMON_FILE_LINK_COLOR}{local_link}{RESET} => {BG_YELLOW}{os.readlink(local_link)}{RESET}, should be =>> {COMMON_FILE_LINK_COLOR}{repo_source}{RESET}"
            )
    except OSError as e:
        _warn(
            f"""{FG_RED}[Exception]{RESET}: Please check if you have {BOLD}sudo mode{
                RESET
            } to create symbollink.\n\t {type(e).__name__} Occurrs when create link at {
                COMMON_FILE_LINK_COLOR
            }{local_link}{RESET}\n\tDetail:{e}"""
        )
        return
    except Exception as e:
        _warn(
            f"{FG_RED}[Exception]{RESET}: {type(e).__name__} while link {COMMON_FILE_LINK_COLOR}{local_link}{RESET} to {COMMON_FILE_LINK_COLOR}{repo_source}{RESET}"
        )
        return


def link_to_repo(conf_list: list[str], del_exist=False):
    for conf in conf_list:
        local_path, repo_path = _get_paired_path(conf)
        _make_link(repo_path, local_path, del_exist)


if __name__ == "__main__":
    all_supported_dotfile = _get_all_supported_conf()
    want_update = [
        "vim",
        "nvim",
        "bash_alias",
    ]

    link_to_repo(all_supported_dotfile, True)
