lu = require "luaunit"
require "DateUtils"

function testParseDate()
    local input = "2024-09-05T18:29:23.853+01:00"
    local expected = 1725557363853

    local result = DateUtils:parseDate(input)

    lu.assertEquals( result, expected )
end

os.exit( lu.LuaUnit.run() )