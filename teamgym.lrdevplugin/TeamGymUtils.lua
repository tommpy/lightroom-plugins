TeamGymUtils = {}

local function swizzleTeams(teams)
    assert(#teams % 2 == 0)
    
    for i = 1, #teams, 2 do
        local tmp = teams[i]
        teams[i] = teams[i+1]
        teams[i+1] = tmp
    end
end

function TeamGymUtils:sortMicroGroups(teams)
    local microApps = {"Tumble", "Trampet"}
    local result = {}

    local a = 1
    local i = 1

    while i <= 2 do

        for _, team in ipairs(teams) do
            table.insert(result, {app = microApps[a], team = team})
            a = a+1

            if(a > #microApps) then a = 1 end
        end

        if(#teams % 2 == 0) then
            swizzleTeams(teams)
        end

        i = i +1
    end

    return result
end