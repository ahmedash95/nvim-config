local auto_dark_mode = require('auto-dark-mode')

-- Keep the colorscheme's syntax colors but swap its background for the
-- terminal's (queried via OSC 11), so nvim blends with neighbouring cmux panes.
-- Groups whose bg sits close to Normal's (floats, sidebars, cursorline) are
-- shifted by the same offset to keep their relative contrast.

local NEAR_NORMAL = 0x20

local term_bg

local function split_rgb(c)
    return bit.rshift(c, 16), bit.band(bit.rshift(c, 8), 0xff), bit.band(c, 0xff)
end

local function join_rgb(r, g, b)
    local function clamp(v) return math.max(0, math.min(255, v)) end
    return clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b)
end

local function parse_osc11(seq)
    local r, g, b = seq:match('^\027%]11;rgba?:(%x+)/(%x+)/(%x+)')
    if not r then return nil end
    local function to8(h) return math.floor(tonumber(h, 16) / (16 ^ #h - 1) * 255 + 0.5) end
    return join_rgb(to8(r), to8(g), to8(b))
end

local function apply_term_bg()
    if not term_bg then return end
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    if not normal.bg or normal.bg == term_bg then return end

    local nr, ng, nb = split_rgb(normal.bg)
    local tr, tg, tb = split_rgb(term_bg)

    for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
        if hl.bg and not hl.link then
            local r, g, b = split_rgb(hl.bg)
            if math.abs(r - nr) <= NEAR_NORMAL and math.abs(g - ng) <= NEAR_NORMAL and math.abs(b - nb) <= NEAR_NORMAL then
                hl.bg = join_rgb(tr + r - nr, tg + g - ng, tb + b - nb)
                vim.api.nvim_set_hl(0, name, hl)
            end
        end
    end
end

local function query_term_bg()
    if #vim.api.nvim_list_uis() > 0 then
        vim.api.nvim_ui_send('\027]11;?\007')
    end
end

local group = vim.api.nvim_create_augroup('TerminalBackground', { clear = true })

vim.api.nvim_create_autocmd('TermResponse', {
    group = group,
    callback = function(ev)
        local seq = type(ev.data) == 'table' and ev.data.sequence or ev.data
        local bg = seq and parse_osc11(seq)
        if bg then
            term_bg = bg
            apply_term_bg()
        end
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = apply_term_bg,
})

local function set_theme(background, colorscheme)
    vim.api.nvim_set_option_value('background', background, {})
    vim.cmd.colorscheme(colorscheme)
    -- cmux may switch its theme slightly after macOS does
    vim.defer_fn(query_term_bg, 300)
end

auto_dark_mode.setup({
    update_interval = 1000,
    set_dark_mode = function()
        set_theme('dark', 'tokyonight-moon')
    end,
    set_light_mode = function()
        set_theme('light', 'github_light')
    end,
})

query_term_bg()
