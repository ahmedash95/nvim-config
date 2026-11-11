-- image.nvim integration for Zig: renders images whose paths appear in comments.
--   //! Example 1:  img/dijkstra-example-1.png
--   // see ./diagrams/foo.svg
-- Paths resolve relative to the .zig file (absolute and ~ paths also work).
local document = require("image/utils/document")

local exts = { png = true, jpg = true, jpeg = true, gif = true, webp = true, svg = true, avif = true }

return document.create_document_integration({
  name = "zig",
  default_options = {
    clear_in_insert_mode = false,
    download_remote_images = false,
    only_render_image_at_cursor = false,
    only_render_image_at_cursor_mode = "popup",
    floating_windows = false,
    filetypes = { "zig" },
  },
  query_buffer_images = function(buffer)
    local buf = buffer or vim.api.nvim_get_current_buf()
    local images = {}
    for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      local comment_col = line:find("//", 1, true)
      if comment_col then
        local init = comment_col
        while true do
          local s, e, path = line:find("([%w%._%-/~]+%.(%w+))", init)
          if not s then break end
          local ext = path:match("%.(%w+)$"):lower()
          if exts[ext] then
            table.insert(images, {
              node = nil,
              range = { start_row = row - 1, start_col = s - 1, end_row = row - 1, end_col = e },
              url = path,
            })
          end
          init = e + 1
        end
      end
    end
    return images
  end,
})
