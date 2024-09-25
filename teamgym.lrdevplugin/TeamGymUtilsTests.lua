lu = require "luaunit"
require "TeamGymUtils"

function testSortMicroOdd()
    local teams = {"Team A", "Team B", "Team C", "Team D", "Team E"}
    local expected = {
        {app = "Tumble", team = "Team A"},
        {app = "Trampet", team = "Team B"},
        {app = "Tumble", team = "Team C"},
        {app = "Trampet", team = "Team D"},
        {app = "Tumble", team = "Team E"},
        {app = "Trampet", team = "Team A"},
        {app = "Tumble", team = "Team B"},
        {app = "Trampet", team = "Team C"},
        {app = "Tumble", team = "Team D"},
        {app = "Trampet", team = "Team E"},
    }

    local result = TeamGymUtils:sortMicroGroups(teams)

    lu.assertEquals( result, expected )
end


function testSortMicroEven()
    local teams = {"Team A", "Team B", "Team C", "Team D"}
    local expected = {
        {app = "Tumble", team = "Team A"},
        {app = "Trampet", team = "Team B"},
        {app = "Tumble", team = "Team C"},
        {app = "Trampet", team = "Team D"},
        {app = "Tumble", team = "Team B"},
        {app = "Trampet", team = "Team A"},
        {app = "Tumble", team = "Team D"},
        {app = "Trampet", team = "Team C"}
    }

    local result = TeamGymUtils:sortMicroGroups(teams)

    lu.assertEquals( result, expected )
end

os.exit( lu.LuaUnit.run() )