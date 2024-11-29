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

-- CMAKE 运行当前文件同名的 target， 会重新配置cmake
function CMakeRunTarget()
    local targetName = vim.fn.expand("%:p:t:r")
    local cmakeRoot = FindCMakeRoot()
    local buildDir = cmakeRoot .. "/build"
    vim.cmd("w")
    vim.cmd(
        string.format(
            "FloatermNew --title=CMakeRunTarget:%s --autoclose=0 %s",
            targetName,
            string.format(
                "rm -rf %s ; mkdir %s ; cd %s && cmake .. -DCMAKE_BUILD_TYPE=Release && cmake --build . --target=%s && clear && bin/%s",
                buildDir,
                buildDir,
                buildDir,
                targetName,
                targetName
            )
        )
    )
end

-- CMAKE 调试当前文件同名的 target， 会重新配置cmake
function CMakeDebugTarget()
    local targetName = vim.fn.expand("%:p:t:r")
    local cmakeRoot = FindCMakeRoot()
    local buildDir = cmakeRoot .. "/build"
    vim.cmd("w")
    vim.cmd(
        string.format(
            "FloatermNew --autoclose=1 --title=CMakeDebugTarget:%s --width=0.9 --height=0.85 %s",
            targetName,
            string.format(
                "rm -rf %s ; mkdir %s ; cd %s && cmake .. -DCMAKE_BUILD_TYPE=Debug && cmake --build . --target=%s && clear && cgdb bin/%s",
                buildDir,
                buildDir,
                buildDir,
                targetName,
                targetName
            )
        )
    )
end

-- CMAKE 运行当前文件同名的 target，不会重新配置cmake
function CMakeRunTargetNonClean()
    local targetName = vim.fn.expand("%:p:t:r")
    local cmakeRoot = FindCMakeRoot()
    local buildDir = cmakeRoot .. "/build"
    vim.cmd("w")
    vim.cmd(
        string.format(
            "FloatermNew --title=CMakeRunTarget:%s --autoclose=0 %s",
            targetName,
            string.format("cd %s && cmake --build . --target=%s && clear && bin/%s", buildDir, targetName, targetName)
        )
    )
end

-- CMAKE 调试当前文件同名的target，不会重新配置cmake
function CMakeDebugTargetNonClean()
    local targetName = vim.fn.expand("%:p:t:r")
    local cmakeRoot = FindCMakeRoot()
    local buildDir = cmakeRoot .. "/build"
    vim.cmd("w")
    vim.cmd(
        string.format(
            "FloatermNew --autoclose=1 --title=CMakeDebugTarget:%s --width=0.9 --height=0.85 %s",
            targetName,
            string.format(
                "cd %s && cmake --build . --target=%s && clear && cgdb bin/%s",
                buildDir,
                targetName,
                targetName
            )
        )
    )
end
