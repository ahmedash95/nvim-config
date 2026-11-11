require("leetcode").setup({
    lang = "java",
    image_support = true,
    hooks = {
        -- Cloudflare blocks curl's HTTP/2 fingerprint on run/submit (kawre/leetcode.nvim#167).
        -- Remove once kawre/leetcode.nvim#234 is merged.
        ["enter"] = {
            function()
                local api_utils = require("leetcode.api.utils")
                if api_utils.http1_patched then
                    return
                end
                api_utils.http1_patched = true

                local curl = api_utils.curl
                api_utils.curl = function(method, params)
                    params = vim.tbl_deep_extend("force", params or {}, { raw = { "--http1.1" } })
                    return curl(method, params)
                end
            end,
        },
    },
})
