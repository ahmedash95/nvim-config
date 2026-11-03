local inlay = {
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    variableTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    enumMemberValues = { enabled = true },
}

local lang = {
    updateImportsOnFileMove = { enabled = "always" },
    suggest = { completeFunctionCalls = true },
    inlayHints = inlay,
    preferences = { importModuleSpecifier = "non-relative" },
}

return {
    settings = {
        complete_function_calls = true,
        vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true, -- use the project's node_modules/typescript
            experimental = {
                maxInlayHintLength = 30,
                completion = { enableServerSideFuzzyMatch = true },
            },
        },
        typescript = vim.tbl_extend("force", lang, { tsserver = { maxTsServerMemory = 8192 } }),
        javascript = lang,
    },
}
