local LrApplication = import "LrApplication"
local LrTasks = import "LrTasks"

local Metadata = require("MyMetadataDefinitionFile")

local function findAttributes(id)
    for k, item in pairs(Metadata.metadataFieldsForPhotos) do
        if(item.id == id and item.dataType == "enum") then
            local values = {}
            for k, value in pairs(item.values) do
                if(value.value) then
                    values[value.value] = value.title
                end
            end
            return values
        end
    end
end

local function searchCriteria(competition, phase, age, section, apparatus, club)
    
    return {
        {
            criteria = "sdk:com.teamgymphotos.teamgym.Age",
            operation = "==",
            value = age
        },
        {
            criteria = "sdk:com.teamgymphotos.teamgym.Phase",
            operation = "==",
            value = phase
        },
        {
            criteria = "sdk:com.teamgymphotos.teamgym.Section",
            operation = "==",
            value = section
        },
        {
            criteria = "sdk:com.teamgymphotos.teamgym.Apparatus",
            operation = "==",
            value = apparatus
        },
        {
            criteria = "sdk:com.teamgymphotos.teamgym.Club",
            operation = "==",
            value = club
        },
		{
			criteria = "sdktext:com.teamgymphotos.teamgym.Competition",
			operation = "all",
			value = competition,
			value2 = "",
		},
		{
			criteria = "pick",
			operation = "!=",
			value = -1,
		},
        combine = "intersect",
    }
end

local function createSmartCollection(data)
    local criteria = searchCriteria(data.competition, data.phase, data.age, data.section, data.apparatus, data.club)
    LrApplication.activeCatalog():createSmartCollection(data.name, criteria, data.root, true)
end

local function teams()
    return {
        {
            club = "Newcastle",
            age = "Junior",
            section = "Women"
        },
        {
            club = "Bracknell",
            age = "Junior",
            section = "Women"
        },
        {
            club = "Hawth",
            age = "Junior",
            section = "Mixed"
        },
        {
            club = "Scarborough",
            age = "Junior",
            section = "Mixed"
        },
        {
            club = "Majestic",
            age = "Senior",
            section = "Women"
        },
        {
            club = "Portsmouth",
            age = "Senior",
            section = "Women"
        },
        {
            club = "Bracknell",
            age = "Senior",
            section = "Mixed"
        },
        {
            club = "Hawth",
            age = "Senior",
            section = "Mixed"
        },
        {
            club = "Crewe",
            age = "Senior",
            section = "Men"
        },
    }
end

local function createApparatus(root, competition, phase, age, section, club)
    local apparatuses = findAttributes("Apparatus")
    for apparatus, appTitle in pairs(apparatuses) do
        --local criteria = searchCriteria(competition, phase, age, section, apparatus, club)
        --LrApplication.activeCatalog():createSmartCollection(apparatus, criteria, root, true)

        createSmartCollection{
            competition = competition,
            root = root,
            phase = phase,
            name = apparatus,
            section = section,
            club = club,
            age = age,
            apparatus = apparatus
        }
    end
end

local function createTeam(root, competition, phase, age, section, club)
    local clubSet = LrApplication.activeCatalog():createCollectionSet(club, root, true)
    createApparatus(clubSet, competition, phase, age, section, club)

    createSmartCollection{
        competition = competition,
        root = clubSet,
        phase = phase,
        name = "Random",
        section = section,
        club = club,
        age = age
    }
end

local function createSection(root, competition, phase, age, section)
    local sectionSet = LrApplication.activeCatalog():createCollectionSet(section, root, true)
    local clubs = {}
    for _, team in pairs(teams()) do
        if(team.section == section and team.age==age) then
            if clubs[team.club] == nil then
                createTeam(sectionSet, competition, phase, age, section, team.club)
                clubs[team.club] = true
            end
        end
    end

    createSmartCollection{
        competition = competition,
        root = sectionSet,
        phase = phase,
        name = "Random",
        section = section,
        age = age
    }
end

local function createAge(root, competition, phase, age)
    local ageSet = LrApplication.activeCatalog():createCollectionSet(age, root, true)

    local sections = {}
    for _, team in pairs(teams()) do
        if(team.age == age) then
            if sections[team.section] == nil  then
                createSection(ageSet, competition, phase, age, team.section)
                sections[team.section] = true
            end
        end
    end

    createSmartCollection{
        competition = competition,
        root = ageSet,
        phase = phase,
        name = "Random",
        age = age
    }
end

local function createTeams(root, competition, phase)
    local ages = {}
    for _, team in pairs(teams()) do
        if ages[team.age] == nil then
            createAge(root, competition, phase, team.age)
            ages[team.age] = true
        end
    end

    createSmartCollection{
        competition = competition,
        root = root,
        phase = phase,
        name = "Random"
    }
end

local function createAwards(root, competition)
    local ages = {}
    createSmartCollection{
        competition = competition,
        root = root,
        phase = "Awards",
        name = "Random"
    }

    for _, team in pairs(teams()) do
        if(ages[team.age] == nil) then
            local ageSet = LrApplication.activeCatalog():createCollectionSet(team.age, root, true)
            
            createSmartCollection{
                age = team.age,
                competition = competition,
                root = ageSet,
                phase = "Awards",
                name = "Random"
            }

            local sections = {}
            for _, sectionTeam in pairs(teams()) do
                if(sectionTeam.age == team.age and sections[sectionTeam.section] == nil) then
                    local criteria = searchCriteria(competition, "Awards", sectionTeam.age, sectionTeam.section, nil, nil)
                    LrApplication.activeCatalog():createSmartCollection(sectionTeam.section, criteria, ageSet, true)
                    sections[sectionTeam.section] = true
                end
            end
            ages[team.age] = true
        end
    end
 end


local function createPhases(root, competition)
    local phases = findAttributes("Phase")
    for phase, title in pairs(phases) do
        
        if phase == "Competition" or phase == "PodiumTraining" or phase == "CompetitionWarmup" then
            local phaseSet = LrApplication.activeCatalog():createCollectionSet(title, root, true)
            createTeams(phaseSet, competition, phase)
        elseif phase == "Awards" then
            local phaseSet = LrApplication.activeCatalog():createCollectionSet(title, root, true)
            createAwards(phaseSet, competition)
        else
            local criteria = {
                {
                    criteria = "sdk:com.teamgymphotos.teamgym.Phase",
                    operation = "==",
                    value = phase,
                },
                {
                    criteria = "sdktext:com.teamgymphotos.teamgym.Competition",
                    operation = "all",
                    value = competition,
                    value2 = "",
                },
                {
                    criteria = "pick",
                    operation = "!=",
                    value = -1,
                },
                {
                    criteria = "rating",
                    operation = ">=",
                    value = 3,
                },
                combine = "intersect",
            }
            LrApplication.activeCatalog():createSmartCollection(title, criteria, root, true)
        end
    end
       
    createSmartCollection{
        competition = competition,
        root = root,
        name = "Random"
    }
end

local function createRootFolder(competition)
    local root = LrApplication.activeCatalog():createCollectionSet(competition, nil, true)
    createPhases(root, competition)
end

local function doCreate(competition)
    LrTasks.startAsyncTask(function ()

        LrApplication.activeCatalog():withWriteAccessDo(
        "Create TeamGym Smart Folders",
        function (context)
            createRootFolder(competition)
        end,
        {
            timeout = 5
        }
    )
    end
)
end

doCreate('Mech 2023')
