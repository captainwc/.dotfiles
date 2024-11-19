import platform
import json
import os
from datetime import datetime
from typing import Optional
import shutil
from pathlib import Path

local_mapper = "dot_conf/map2localpath.json"
repo_mapper = "dot_conf/map2repopath.json"
local_conf = "dot_conf/local.json"
repo_path = os.getcwd()


def _error(msg: str):
    print(f"[ERROR]: {msg}")


def _log(msg: str):
    print(f"[LOG]: {msg}")


def _os_type() -> str:
    systype = platform.system()
    if systype == "Windows":
        return "win"
    else:
        return "linux"


def _mapper(type: str) -> json:
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

You should config your windows-user-home first!

By create a file named <<{local_conf}>> at the root of this git repo,
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
                    os.path.join(os.path.normpath(repo_path),
                                 os.path.normpath(val))
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
        _error(
            f'"{conf}" in supported list haven\'t specify the mapped path in map2{type}path.json file, please check it'
        )
        return None
    return os.path.normpath(pt)


def _get_paired_path(conf: str) -> list[str, str]:
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
            _log(f"[RemoveDir]: Delete {filename}")
        else:
            os.remove(filename)
            _log(f"[RemoveFile]: Delete {filename}")
    else:
        new_name = f"{filename}{_suffix()}"
        os.rename(filename, new_name)
        _log(f"[Rename]: {filename} => {new_name}")


def _make_link(repo_source: Optional[str], local_link: Optional[str], del_exist=False):
    # check repo
    if repo_source is None or not os.path.exists(repo_source):
        _error(
            f"[SKIP]: {repo_source} unexists, skip create this file's symbolink to {local_link}"
        )
        return

    # check local
    if local_link is None:
        _log(f"[SKIP]: {repo_source} don't have mapped path in your os")
        return

    if os.path.exists(local_link):
        if os.path.islink(local_link):
            old_target = os.readlink(local_link)
            if os.path.samefile(old_target, repo_source):
                return
            else:
                _handle_exists_file(local_link, del_exist)
        else:
            _handle_exists_file(local_link, del_exist)
    else:
        par = Path(local_link).parent
        if not os.path.exists(par):
            os.makedirs(par)

    # make link
    try:
        is_dir = os.path.isdir(repo_source)
        os.symlink(repo_source, local_link, target_is_directory=is_dir)
        _log(f"[SUCCESS] {local_link} => {repo_source} DONE!")
    except OSError:
        _error(
            "[SKIP]: Please check if you have sudo mode to create symbollink.\n Occurrs when create link at {link}"
        )
    except Exception as e:
        _error(
            f"[SKIP]: {type(e).__name__} while link {repo_source} to {local_link}")


def link_to_repo(conf_list, del_exist=False):
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

    print(_get_all_supported_conf())
