local exports = {}

---
 -- Returns the current folder path
 -- @return {string} Path of the current script
---
exports.current_dir = function ()
    return debug.getinfo(1, "S").source:match[[^@?(.*[\/])[^\/]-$]]
end

---
 -- Trim the extension of the given table's elements
 -- @param {table} table - the paths to trim
 -- @return {table} - the incoming table with paths trimmed
---
exports.trim_extensions = function (table)
	for k, v in pairs(table) do
		table[k] = string.match(v, '[%w-]*')
	end
	return table
end

return exports