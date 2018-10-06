function current_dir()
    return debug.getinfo(1, "S").source:match[[^@?(.*[\/])[^\/]-$]]
end

local completions_dir = current_dir()..'additional-clink-completions/'
for _,lua_module in ipairs(clink.find_files(completions_dir..'*.lua')) do
    local filename = completions_dir..lua_module
    -- use dofile instead of require because require caches loaded modules
    -- so config reloading using Alt-Q won't reload updated modules.
    dofile(filename)
end