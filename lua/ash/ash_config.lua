local function read() local project_root = vim.fn.getcwd()
    local file = io.open(project_root .. '/.ash.json', 'r')
    if file == nil then
        return {}
    end
    local content = file:read('*all')
    file:close()

    local success, result = pcall(vim.fn.json_decode, content)
    if success then
        return result
    else
        print("Failed to decode JSON: " .. result)
        return {}
    end
end

local function dump(value, depth)
    if depth == nil then depth = 0 end
    local indent = string.rep("  ", depth)

    if type(value) == "table" then
        local s = "{\n"
        for k, v in pairs(value) do
            s = s .. indent .. "  " .. tostring(k) .. " = " .. dump(v, depth + 1) .. ",\n"
        end
        return s .. indent .. "}"
    else
        return tostring(value)
    end
end

return {
    read = read,
    dump = dump
}
