-- Liquid Glass support: options for transparent.nvim.
--
-- In Rex/Ghostty only cells using the terminal's *default* background show
-- the glass. Any cell with an explicit bg colour is painted opaque, so every
-- structural surface (editor, sidebars, bars, floats) must have bg = NONE.
-- Things that mark state (selection, search, diff, the mode/tab pills) keep a
-- colour on purpose: they are the only solid shapes on the glass.
--
-- Toggle with :TransparentToggle; tabline and lualine follow it.

local M = {}

-- Cleared on top of transparent.nvim's defaults (Normal, StatusLine,
-- SignColumn, CursorLine, LineNr, EndOfBuffer...). Missing groups are harmless.
local groups = {
    -- Floats: hover, which-key, lazy, mason, noice, cmp, telescope
    'NormalFloat', 'FloatBorder', 'FloatTitle', 'FloatFooter',
    'Pmenu', 'PmenuExtra', 'PmenuKind', 'PmenuMatch', 'PmenuBorder',
    'WhichKeyNormal', 'WhichKeyFloat', 'WhichKeyBorder',
    'LazyNormal', 'MasonNormal', 'LspInfoBorder',
    'CmpDocumentation', 'CmpDocumentationBorder',
    'NoiceCmdlinePopup', 'NoiceCmdlinePopupBorder', 'NoicePopup', 'NoicePopupBorder',
    'NoicePopupmenu', 'NoicePopupmenuBorder', 'NoiceMini', 'NoiceConfirm', 'NoiceConfirmBorder',
    'SnacksNormal', 'SnacksNormalNC', 'SnacksWinBar', 'SnacksBackdrop',
    'SnacksPickerInputBorder', 'SnacksPickerInputTitle', 'SnacksPickerBoxTitle',
    'TelescopeNormal', 'TelescopeBorder', 'TelescopeTitle',
    'TelescopePromptNormal', 'TelescopePromptBorder', 'TelescopePromptTitle',
    'TelescopeResultsNormal', 'TelescopeResultsBorder', 'TelescopeResultsTitle',
    'TelescopePreviewNormal', 'TelescopePreviewBorder', 'TelescopePreviewTitle',
    'TelescopePreviewMessage', 'TelescopePreviewMessageFillchar',

    -- Sidebars: tokyonight paints them darker (NormalSB), github_light lighter
    'NormalSB', 'SignColumnSB',
    'NvimTreeNormal', 'NvimTreeNormalNC', 'NvimTreeNormalFloat', 'NvimTreeEndOfBuffer',
    'NvimTreeSignColumn', 'NvimTreeWinSeparator', 'NvimTreeStatusLine', 'NvimTreeStatusLineNC',
    'DapUIFloatNormal', 'DapUIFloatBorder',

    -- Bars and gutters. The tabline's labels/pill are drawn by ash.tabline.
    'TabLine', 'TabLineFill', 'WinBar', 'WinBarNC', 'MsgArea', 'MsgSeparator',
    'WinSeparator', 'VertSplit', 'FoldColumn', 'CursorColumn', 'ColorColumn', 'Folded',

    -- Inline decorations that would otherwise render as solid chips
    'LspInlayHint', 'CocInlayHint',
    'DiagnosticVirtualTextError', 'DiagnosticVirtualTextWarn',
    'DiagnosticVirtualTextInfo', 'DiagnosticVirtualTextHint', 'DiagnosticVirtualTextOk',
    'TreesitterContext', 'TreesitterContextLineNumber',

    -- Toggleterm (horizontal split + float)
    'ToggleTerm1NormalFloat', 'ToggleTermNormal',
}

-- Every group starting with one of these is cleared too (each notifier level
-- has its own group, and the list differs between snacks versions).
local prefixes = { 'SnacksNotifier' }

local function extra_groups()
    local out = vim.deepcopy(groups)
    local all = vim.api.nvim_get_hl(0, {})
    for name in pairs(all) do
        for _, prefix in ipairs(prefixes) do
            if vim.startswith(name, prefix) then
                out[#out + 1] = name
            end
        end
    end
    return out
end

local function link_if_cleared(name, target)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if not hl.bg then
        vim.api.nvim_set_hl(0, name, { link = target })
    end
end

-- With CursorLine cleared, lists would lose their selected row (several
-- themes link these to CursorLine). Give them the popup-menu selection,
-- a colour each theme tunes to read as "selected".
local function restore_selections()
    link_if_cleared('TelescopeSelection', 'PmenuSel')
    link_if_cleared('NvimTreeCursorLine', 'PmenuSel')
    link_if_cleared('SnacksPickerListCursorLine', 'PmenuSel')
    -- The editor itself keeps no cursorline band; the number marks the row.
    local nr = vim.api.nvim_get_hl(0, { name = 'CursorLineNr', link = false })
    nr.bold = true
    vim.api.nvim_set_hl(0, 'CursorLineNr', nr)
end

M.opts = {
    extra_groups = extra_groups,
    on_clear = restore_selections,
}

return M
