local Path = require 'plenary.path' -- For manipulating paths
local ts_utils = require'nvim-treesitter.ts_utils' -- For syntax tree parsing

local P = function(x)
    print(vim.inspect(x))
end

projPath = Path:new('.')

-- Return a list of separated path dirs and the current file
cur_buf_path_list = function ()
    return Path:new(vim.api.nvim_buf_get_name(0)):_split()
end

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
    end

    method_name = ts_utils.get_node_text(expr:child(4))[1]

    -- Remove the Async suffix
    method_name = string.gsub(method_name, "Async", "")

    return method_name
end

switch_to_view = function ()
    local viewName = get_current_method_name()
    local controller_name = get_controller_name()
    -- Views/ControllerName/viewName.cshtml
    local viewPath = projPath:joinpath("Views"):joinpath(controller_name):joinpath(string.format("%s.cshtml", viewName))
    switch(viewPath, "vsplit")
end

-- Get the pure controller name
get_controller_name = function ()
    -- Currnet file name is the last element in list
    current_controller_name = cur_buf_path_list()[#cur_buf_path_list()]

    -- Delete Controller suffix and .cs
    current_controller_name = string.gsub(current_controller_name, "Controller", "")
    current_controller_name = string.gsub(current_controller_name, ".cs", "")

    return current_controller_name;
end

PosType = {
    UNDEFINED = -1,
    CONTROLLER = 1,
    VIEW = 2,
}

-- Get the currnet file position
-- Returns: Controller, View, Undefined
get_cur_pos = function ()
    local cur = cur_buf_path_list()
    if cur[#cur - 1] == "Controllers" then
        return PosType.CONTROLLER
    elseif cur[#cur - 2] == "Views" then
        return PosType.VIEW
    else
        return PosType.UNDEFINED
    end
end

Toggle = function ()
    -- Where we are now ? Controller or View.
    local cur_pos = get_cur_pos()

    if cur_pos == PosType.CONTROLLER then
        switch_to_view()
    end
end
