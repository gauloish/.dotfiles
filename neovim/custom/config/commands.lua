---------- Commands ---------- 

-- Open Settings File
vim.api.nvim_create_user_command("NvSettings",
    function()
        local config = vim.fn.stdpath("config")

        vim.cmd("cd " .. config)
        vim.cmd("cd lua")
        vim.cmd("cd custom")
        vim.cmd("edit init.lua")
    end,
    {
        desc = "Open Settings File",
    }
)
