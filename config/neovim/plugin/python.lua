local system = vim.g.system

-- vim.notify = require("notify")

local function set_python_host_prog(path)
    if vim.fn.filereadable(path) == 1 then
        vim.g.python3_host_prog = path
    else
        vim.notify(
            "Python host path not found: '" .. path .. "'",
            "warn",
            { title = "Python setup" }
        )
    end
end

if system == "ONERA_workstation" then
    set_python_host_prog("/opt/tools/python/3.12.2-gnu850/bin/python3")
else
    vim.notify(
        "Unknown system. Please set `g:python3_host_prog` manually",
        "warn",
        { title = "Python setup" }
    )
end
