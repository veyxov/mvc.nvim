local Path = require 'plenary.path' -- For manipulating paths
local ts_utils = require'nvim-treesitter.ts_utils' -- For syntax tree parsing

local P = function(x)
    print(vim.inspect(x))
end

projPath = Path:new('.')

-- Opens a file in the specified mode
-- Available modes: {new, split, vsplit}
switch = function (file, mode)
    mode = mode or "new" -- By default open in a new window

    -- Is this really needed ?
    if mode == "new" then
        mode = "edit"
    end

    vim.api.nvim_command(string.format("%s %s", mode, file))
end

-- TODO: Refactor this ASAP
get_current_method_name = function ()
    local current_node = ts_utils.get_node_at_cursor()

    local expr = current_node

    while expr do
        if expr:type() == "method_declaration" then
            break
        end
        expr = expr:parent()
        P(expr:type())
    end

    method_name = ts_utils.get_node_text(expr:child(4))[1]

    -- Remove the Async suffix
    method_name = string.gsub(method_name, "Async", "")
    
    return method_name
end

switch_to_view = function (file_name)
    local viewName = get_current_method_name()
    P(viewName)
    local viewPath = projPath:joinpath("Views"):joinpath(file_name):joinpath(string.format("%s.cshtml", viewName))
    switch(viewPath, "vsplit")
end
