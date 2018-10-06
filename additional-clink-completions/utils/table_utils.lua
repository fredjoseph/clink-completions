local exports = {}

---
 -- Create a table with the given values
 -- @param {array} elements to add in the table
 -- @return {table} The created table
---
exports.createTable = function (...)
    local table = {}
    local arg = {...}
    for _,v in ipairs(arg) do
        table[tostring(v)] = v
    end
    return table
end

---
 -- Check if the given table contains the given key
 -- @param {table} table - the table
 -- @param {object} key - the key
 -- @return {boolean} true if the table contains the key, otherwise false
---
exports.contains = function (table, key)
    return table[key] ~= nil
end

return exports