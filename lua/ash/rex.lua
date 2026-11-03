-- Open commands in Rex floating panes (layers) instead of nvim floating windows.
local M = {}

M.blocks = {}

function M.available()
    return vim.env.TERM_PROGRAM == "rex" and vim.env.REX_SESSION ~= nil and vim.fn.executable("rex") == 1
end

local function api(method, args, on_done)
    vim.system({ "rex", "api", "call", "-s", vim.env.REX_SESSION, method, vim.json.encode(args) }, { text = true },
        function(res)
            local ok, decoded = false, nil
            if res.code == 0 then
                ok, decoded = pcall(vim.json.decode, res.stdout)
            end
            if on_done then
                vim.schedule(function() on_done(ok and decoded or nil, res) end)
            end
        end)
end

local function create(name, command, opts)
    opts = opts or {}
    api("session.new_layer", {
        bounds = opts.bounds or { 0.05, 0.05, 0.9, 0.9 },
        focus = true,
        layout = {
            block = {
                flavor = "com.superlogical.terminal.shell",
                label = name,
                options = { command = command, cwd = opts.cwd or vim.fn.getcwd() },
            },
        },
    }, function(out, res)
        if not out then
            if opts.fallback then return opts.fallback() end
            vim.notify("rex: failed to open " .. name .. ": " .. (res.stderr or ""), vim.log.levels.ERROR)
            return
        end
        local block_id = out.block_ids[1]
        M.blocks[name] = block_id
        vim.system({ "rex", "wait", block_id }, {}, function()
            vim.schedule(function()
                if M.blocks[name] == block_id then M.blocks[name] = nil end
                if opts.on_exit then opts.on_exit() end
            end)
        end)
    end)
end

-- Focus the existing float named `name`, or create it running `command`.
function M.float(name, command, opts)
    local existing = M.blocks[name]
    if not existing then
        return create(name, command, opts)
    end
    api("session.focus_block", { block_id = existing }, function(out)
        if not out then
            M.blocks[name] = nil
            create(name, command, opts)
        end
    end)
end

function M.lazygit()
    if not M.available() then
        return vim.cmd("LazyGit")
    end
    M.float("lazygit", { "lazygit" }, {
        fallback = function() vim.cmd("LazyGit") end,
        on_exit = function()
            vim.cmd("checktime")
            pcall(function() require("gitsigns").refresh() end)
        end,
    })
end

return M
