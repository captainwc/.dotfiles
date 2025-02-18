-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- 朴素的执行命令
function RunCommand()
    local currDir = vim.fn.getcwd()
    local command = vim.fn.input("[" .. currDir .. "]$ ")
    if command ~= "" then
        -- vim.cmd(command)
        vim.cmd(string.format("FloatermNew --autoclose=0 --title=COMMANDLINE %s", command))
    end
end

-- 判断操作系统
function OsIsWindows()
    -- return package.config:sub(1, 1) == "\\"
    return jit.os == "Windows"
end

-- 包装命令以适应不同平台
function WrapCommandForDiffOS(cmd)
    local tool_mapping = {
        gdb = { windows = "gdb", linux = "cgdb" },
        pdb = { windows = "pdb", linux = "pudb" },
    }
    local is_win = OsIsWindows()
    -- 命令映射
    if tool_mapping[cmd] then
        return is_win and tool_mapping[cmd].windows or tool_mapping[cmd].linux
    end
    -- 其余的，linux上加上 ./
    return is_win and cmd or "./" .. cmd
end

-- 规则化路径分隔符
function NormalizePath(path)
    local sep = "/"
    if OsIsWindows() then
        sep = "\\"
    else
        sep = "/"
    end
    local normalPath = path:gsub("[/\\]", sep)
    return normalPath
end

-- toggleFT func: 存在对应名称的窗口则toggle，否则新建
function ToggleFT(name, cmd)
    if vim.fn["floaterm#terminal#get_bufnr"](name) ~= -1 then
        vim.cmd(string.format('exec "FloatermToggle %s"', name))
    else
        vim.cmd(string.format("FloatermNew --name=%s %s", name, cmd))
    end
end

function GetCompileOptions(type)
    local defaultOptionsMap = {
        CPP = "-std=c++20 ",
        CPP_Debug = "-g -O0 -std=c++20 ",
        C = "",
        C_Debug = "-g ",
    }

    local compileOptions = vim.fn.input("[" .. type .. "] Compile Options", defaultOptionsMap[type])
    return compileOptions
end

-- Run File
function RunFile()
    vim.cmd("w")
    local ft = vim.bo.filetype
    local run_cmd =
        { javascript = "node", typescript = "ts-node", python = "python", go = "go run", sh = "bash", lua = "lua" }
    if run_cmd[ft] then
        ToggleFT("RUN", run_cmd[ft] .. " %")
    elseif ft == "c" then
        ToggleFT("RUN", "gcc % " .. GetCompileOptions("C") .. " -o %< && " .. WrapCommandForDiffOS("%<") .. " && rm %<")
    elseif ft == "cpp" then
        ToggleFT(
            "RUN",
            "g++ % -o %< " .. GetCompileOptions("CPP") .. " && " .. WrapCommandForDiffOS("%<") .. " && rm %<"
        )
    elseif ft == "java" then
        ToggleFT("RUN", "javac % && java %<")
    end
end

-- Debug File
function DebugFile()
    vim.cmd("w")
    local ft = vim.bo.filetype
    if ft == "c" then
        vim.cmd(
            string.format(
                "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
                "DEBUG",
                string.format(
                    "bash -c 'gcc %% -o %%< %s && %s -q %%< && rm %%<'",
                    GetCompileOptions("C_Debug"),
                    WrapCommandForDiffOS("gdb")
                )
            )
        )
    elseif ft == "cpp" then
        vim.cmd(
            string.format(
                "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
                "DEBUG",
                string.format(
                    "bash -c 'g++ %% -o %%< %s && %s -q %%< && rm %%<'",
                    GetCompileOptions("CPP_Debug"),
                    WrapCommandForDiffOS("gdb")
                )
            )
        )
    elseif ft == "python" then
        vim.cmd(
            string.format(
                "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
                "DEBUG",
                string.format("bash -c '%s %%'", WrapCommandForDiffOS("pdb"))
            )
        )
    elseif ft == "go" then
        local title = "DEBUG"
        local dirname = vim.fn.expand("%:p:h")
        local fileBaseName = vim.fn.expand("%:t")
        local baseNameNoExt = vim.fn.expand("%:t:r")
        local flags = "-gcflags='-N -l' -o"
        local suffix = string.format("&& cgdb -q %s && rm %s", baseNameNoExt, baseNameNoExt)
        local command = string.format(
            'bash -c "cd %s && go build %s %s %s %s"',
            dirname,
            flags,
            baseNameNoExt,
            fileBaseName,
            suffix
        )
        vim.cmd(string.format("FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s", title, command))
    end
end

-- 设置透明背景 -> 改用插件 transparent.nvim
function Set_transparent_background()
    vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
    vim.cmd("highlight Normal guifg=#FFFFFFF")
    vim.cmd("highlight NonText guibg=NONE ctermbg=NONE")
    vim.cmd("highlight SignColumn guibg=NONE ctermbg=NONE")
    vim.cmd("highlight VertSplit guibg=NONE ctermbg=NONE")
    vim.cmd("highlight StatusLine guibg=NONE ctermbg=NONE")
    vim.cmd("highlight StatusLineNC guibg=NONE ctermbg=NONE")
    vim.cmd("highlight TabLine guibg=NONE ctermbg=NONE")
    vim.cmd("highlight TabLineFill guibg=NONE ctermbg=NONE")
    vim.cmd("highlight TabLineSel guibg=NONE ctermbg=NONE")
    vim.cmd("highlight NormalFloat guibg=NONE ctermbg=NONE")
    vim.cmd("highlight FloatBorder guibg=NONE ctermbg=NONE")
end

-- -- 自动执行每次颜色方案加载时设置透明背景
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     pattern = "*",
--     callback = Set_transparent_background,
-- })
-- 文件路径相关
function ShowPath()
    local fullpath = vim.fn.expand("%:p")
    local folder = vim.fn.expand("%:p:h")
    local filename = vim.fn.expand("%:p:t")
    local fullbase = vim.fn.expand("%:p:r")
    local extension = vim.fn.expand("%:p:e")
    print(NormalizePath(filename))
    print(NormalizePath(fullpath))
end

-- 寻找根CMakeLists.txt路径
function FindCMakeRoot()
    local path = vim.fn.expand("%:p:h") -- 获取当前文件所在目录
    local last_cmake_file = nil

    while true do
        if vim.fn.filereadable(path .. "/CMakeLists.txt") == 1 then
            last_cmake_file = path
        end
        local parent = vim.fn.fnamemodify(path, ":h")
        if parent == path then
            break
        end -- 如果没有更上层的目录了，退出循环
        path = parent
    end
    return NormalizePath(last_cmake_file) or nil
end

-- 获取target名称和路径相关的信息
function GetCMakeTargetInfo()
    local cmakeRoot = FindCMakeRoot()
    local buildDir = NormalizePath(cmakeRoot .. "/build")

    local defaultTargetName = vim.fn.expand("%:p:t:r")
    local userInput = vim.fn.input("Target('" .. defaultTargetName .. "'): ")
    local targetName = userInput ~= "" and userInput or defaultTargetName

    local targetPath = ""
    local binPath = NormalizePath(buildDir .. "/bin")
    if vim.fn.isdirectory(binPath) == 1 then
        targetPath = NormalizePath("bin/" .. targetName)
    else
        targetPath = NormalizePath(targetName)
    end

    return buildDir, targetName, targetPath
end

-- 生成cmake构建+执行target的命令
function ExecuteCMakeCommand(cmakeBuildType, isRebuildNeeded, isDebugTargetNeeded, isUseNinja)
    local buildDir, targetName, targetPath = GetCMakeTargetInfo()
    local para_nums = 8
    local cmakeGenerator = isUseNinja and '-G"Ninja"' or ""
    -- cmake 构建命令
    local cmakeBuildTargetCmd = ""
    if isRebuildNeeded then
        cmakeBuildTargetCmd = string.format(
            "((rm -rf %s && mkdir %s) || (mkdir %s)) && cd %s && cmake .. %s -DCMAKE_BUILD_TYPE=%s && cmake --build . --target=%s -j%s",
            buildDir,
            buildDir,
            buildDir,
            buildDir,
            cmakeGenerator,
            cmakeBuildType,
            targetName,
            para_nums
        )
    else
        cmakeBuildTargetCmd = string.format(
            -- "cd %s && cmake .. -DCMAKE_BUILD_TYPE=%s && cmake --build . --target=%s -j%s",
            "cd %s && cmake --build . --target=%s -j%s",
            buildDir,
            targetName,
            para_nums
        )
    end
    -- 运行target命令（run or debug)
    local runTargetCmd = ""
    if isDebugTargetNeeded then
        runTargetCmd = string.format("clear && %s %s", WrapCommandForDiffOS("gdb"), targetPath)
    else
        runTargetCmd = string.format("clear && %s", WrapCommandForDiffOS(targetPath))
    end
    -- 组合构建和执行命令
    local fullCommand = cmakeBuildTargetCmd .. " && " .. runTargetCmd
    -- 设置floatterm参数
    local floatermTitle = isDebugTargetNeeded and "CMakeDebugTarget" or "CMakeRunTarget"
    local floatermOptions = ""
    if isDebugTargetNeeded then
        floatermOptions = "--autoclose=1 --width=0.9 --height=0.85"
    else
        floatermOptions = "--autoclose=0"
    end

    vim.cmd("w")
    vim.cmd(string.format("FloatermNew --title=%s:%s %s %s", floatermTitle, targetName, floatermOptions, fullCommand))
end

function CMakeRunTarget()
    ExecuteCMakeCommand("Release", true, false, true)
end

function CMakeDebugTarget()
    ExecuteCMakeCommand("Debug", true, true, true)
end

function CMakeRunTargetNonClean()
    ExecuteCMakeCommand("Release", false, false, true)
end

function CMakeDebugTargetNonClean()
    ExecuteCMakeCommand("Debug", false, true, true)
end
