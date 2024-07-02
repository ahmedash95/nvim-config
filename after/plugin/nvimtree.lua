require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 40,
        adaptive_size = false,
        auto_resize = false,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
        custom = {}, -- show ignored files
    },
    actions = {
        open_file = {
            resize_window = false, -- disaable resizing nvim-tree buffer when opneing new file
        }
    },
    git = {
        ignore = false, -- show git ignored files
    }
})
