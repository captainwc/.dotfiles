# Shuaikai's Dotfiles

## 描述

`dot_manager.py`: 具体的dotfile管理逻辑，

                - 主要作用就是根据json文件中映射的路径，在本地位置创建一个指向仓库文件的软链接

                - 会自动新建、覆盖、跳过，因此不要担心多次运行会破坏之前的软连接

                - 可以指定对于原有的配置文件是直接删除（默认）还是备份一下（直接修改代码里的bool值吧）

`map2local.json`: 配置名：本地存放位置（可以是文件或者文件夹）

`map2repo.josn`:  配置名：仓库中对应的文件

`run.sh/run.cmd`: 运行

## 用法

`./run.sh` or `run.cmd`(会自动问你要管理员权限)

如果你想添加或者自定义dotfile位置，只需要编辑两个json文件即可。即指定好本地的dotfiles位置和对应仓库中的哪个文件即可

## Description

`dot_manager.py`: This script contains the specific logic for managing dotfiles,

                - Its main function is to create symbolic links pointing to repository files at specified local paths based on mappings in a JSON file.

                - It automatically creates, overwrites, or skips existing symlinks, so there's no need to worry about multiple runs disrupting previous configurations.

                - You can specify whether to delete (default) or back up original configuration files by modifying a boolean value in the code.

`map2local.json`: Configuration name: Local storage location (can be a file or directory)

`map2repo.json`: Configuration name: Corresponding file in the repository

`run.sh/run.cmd`: Execution scripts

## Usage

Run ./run.sh or run.cmd (it will prompt you for administrative permissions if needed).

If you want to add or customize dotfile locations, simply edit the two JSON files. That's to say, just specify the desired local dotfile locations and their corresponding files in the repository.
