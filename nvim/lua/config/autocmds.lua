-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- toggleFT func: 存在对应名称的窗口则toggle，否则新建
function ToggleFT(name, cmd)
    if vim.fn["floaterm#terminal#get_bufnr"](name) ~= -1 then
        vim.cmd(string.format('exec "FloatermToggle %s"', name))
    else
        vim.cmd(string.format("FloatermNew --name=%s %s", name, cmd))
    end
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
        ToggleFT("RUN", "gcc % -o %< && ./%< && rm %<")
    elseif ft == "cpp" then
        ToggleFT("RUN", "g++ % -o %< -std=c++20 -fmodules-ts && %< && rm %<")
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
                'bash -c "gcc % -o %< -g && cgdb -q %< && rm %<"'
            )
        )
    elseif ft == "cpp" then
        vim.cmd(
            string.format(
                "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
                "DEBUG",
                'bash -c "g++ % -o %< -g -std=c++20 -fmodules-ts && cgdb -q %< && rm %<"'
            )
        )
    elseif ft == "python" then
        vim.cmd(
            string.format(
                "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
                "DEBUG",
                'bash -c "pudb %"'
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

-- 设置透明背景
function Set_transparent_background()
    vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi NonText guibg=NONE ctermbg=NONE")
    vim.cmd("hi StatusLine guibg=NONE ctermbg=NONE")
    vim.cmd("hi VertSplit guibg=NONE ctermbg=NONE")
    vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
    vim.cmd("hi SignColumn guibg=NONE ctermbg=NONE")
end

-- 自动执行每次颜色方案加载时设置透明背景
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = Set_transparent_background,
})

-- 文件路径相关
function ShowFilePath()
    local fullpath = vim.fn.expand("%:p")
    local folder = vim.fn.expand("%:p:h")
    local filename = vim.fn.expand("%:p:t")
    local fullbase = vim.fn.expand("%:p:r")
    local extension = vim.fn.expand("%:p:e")
    print(
        string.format(
            "FULL: %s\nFolder: %s\nFilename: %s\nFullBase: %s\nEXT: %s\n",
            fullpath,
            folder,
            filename,
            fullbase,
            extension
        )
    )
end

function Log(any)
    print(any)
end

function Execute(cmd)
    -- ret = os.execute(cmd)
    -- return ret
    cmd = cmd:gsub("\\", "/")
    Log("[cmd]：" .. cmd .. "\n")
    local ret = os.execute(
        string.format('D:/env/msys2/usr/bin/bash -c "%s"', cmd)
        -- string.format(
        --     "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
        --     "ExecuteCommand",
        --     string.format('D:/env/msys2/usr/bin/bash -c "%s"', cmd)
        -- )
    )
    -- ToggleFT("CmakeBuild", cmd)
    Log("[cmd ret]: " .. ret)
    return ret
end

-- 寻找根CMakeLists.txt路径
function FindCMakeRoot()
    -- vim.ui.input({ prompt = "Enter your name:" }, function(input)
    --     print("[input]: " .. input)
    -- end)
    -- ShowFilePath()
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
    return last_cmake_file or nil
end

function CMakeRunTarget(targetName, buildType, clearCache)
    buildType = buildType or "Release"
    clearCache = clearCache or false

    -- (1) find cmake root dir
    local workDir = FindCMakeRoot()
    if not workDir then
        Log("Couldn't find CMakeLists in this folder and it's parent")
        return 1
    end

    -- (2) confirm build dir
    local buildDir = workDir .. "\\build"
    if vim.fn.isdirectory(buildDir) == 0 then
        local mkDirRet = Execute("mkdir -p " .. buildDir)
        if mkDirRet ~= 0 then
            Log("Make BuildDir Failed")
            return 1
        end
    end

    -- (3) whether need to clean the builddir
    if clearCache then
        local rmDirRet = Execute(string.format("rm -rf %s/*", buildDir))
        if rmDirRet ~= 0 then
            Log("Clean BuildDir Failed")
            return 1
        end
    end

    -- (4) Cmake Gen
    local cmakeRet = Execute(string.format("cd %s && cmake .. -DCAMKE_BUILD_TYPE=%s", buildDir, buildType))
    if cmakeRet ~= 0 then
        Log("Cmake Generate Failed")
        return 1
    end

    -- (5) Cmake Build Target
    local cmakeBuildRet = Execute(string.format("cd %s && cmake --build . --target=%s", buildDir, targetName))
    if cmakeBuildRet ~= 0 then
        Log("Cmake Build Target Failed")
        return 1
    end

    -- (6) Run Target
    -- Execute(string.format("cd bin && ./%s", targetName))
    ToggleFT("RUN", string.format("cd %s/bin && %s.exe", buildDir, targetName))
    -- vim.cmd(
    --     string.format(
    --         "FloatermNew --autoclose=1 --title=%s --width=0.9 --height=0.85 %s",
    --         "CMAKE RUN",
    --         string.format('D:/env/msys2/usr/bin/bash.exe -c "%s"', )
    --     )
    -- )
end

function Hello()
    local targetName = vim.fn.expand("%:p:t:r")
    CMakeRunTarget(targetName, "Debug", false)
end

-- 最大的问题是命令执行流不同步。要么合并为一条命令，要么用回调的方式规避异步
