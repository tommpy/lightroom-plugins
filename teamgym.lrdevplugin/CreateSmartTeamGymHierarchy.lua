local LrApplication = import "LrApplication"
local LrTasks = import "LrTasks"
local LrDialogs = import "LrDialogs"
local LrLogger = import "LrLogger"
local LrView = import "LrView"
local LrBinding = import "LrBinding"

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

local function searchCriteria(competition, phase, age, section, apparatus, club, nationality, min_rating)
    
    local fields = {
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
			criteria = "sdk:com.teamgymphotos.teamgym.Nationality",
            operation = "==",
			value = nationality,
		},
		{
			criteria = "pick",
			operation = "!=",
			value = -1,
		},
    }

    if(min_rating ~= nil) then
        table.insert(fields, {
            criteria = "rating",
            operation = ">=",
            value = min_rating,
        })    
    end

    fields.combine = "intersect"

    return fields
end

local function createSmartCollection(data)
    local criteria = searchCriteria(data.competition, data.phase, data.age, data.section, data.apparatus, data.club, data.nationality, data.min_rating)
    LrApplication.activeCatalog():createSmartCollection(data.name, criteria, data.root, true)
end

local function nations()
    local nationGroups = {}
    for age, _ in pairs(findAttributes("Age")) do
        for section, _ in pairs(findAttributes("Section")) do
            for nationality, _ in pairs(findAttributes("Nationality")) do
                table.insert(nationGroups, {
                    nationality = nationality,
                    age = age,
                    section = section
                })
            end
        end
    end

    return nationGroups
end

local function clubs()
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

local function createApparatus(root, settings, phase, age, section, club, nationality, min_rating)
    local apparatuses = findAttributes("Apparatus")
    for apparatus, _ in pairs(apparatuses) do

        createSmartCollection{
            competition = settings.competition,
            root = root,
            phase = phase,
            name = apparatus,
            section = section,
            club = club,
            age = age,
            apparatus = apparatus,
            nationality = nationality,
            min_rating = min_rating
        }
    end
end

local function createTeam(root, settings, phase, age, section, club, nationality, min_rating)
    local teamSet
    if(nationality == nil) then
        teamSet = LrApplication.activeCatalog():createCollectionSet(club, root, true)
    else 
        teamSet = LrApplication.activeCatalog():createCollectionSet(nationality, root, true)
    end
    
    createApparatus(teamSet, settings, phase, age, section, club, nationality, min_rating)

    createSmartCollection {
        competition = settings.competition,
        root = teamSet,
        phase = phase,
        name = "Random",
        section = section,
        club = club,
        age = age,
        nationality = nationality,
        min_rating = min_rating
    }
end

local function createSection(root, settings, phase, age, section, min_rating)
    local sectionSet = LrApplication.activeCatalog():createCollectionSet(section, root, true)
    
    if(settings.competition_type == "international") then
        local seenNationalities = {}
        for _, team in pairs(nations()) do
            if(team.section == section and team.age==age) then
                if seenNationalities[team.nationality] == nil then
                    createTeam(sectionSet, settings, phase, age, section, nil, team.nationality, min_rating)
                    seenNationalities[team.nationality] = true
                end
            end
        end
    else
        local seenClubs = {}
        for _, team in pairs(clubs()) do
            if(team.section == section and team.age==age) then
                if seenClubs[team.club] == nil then
                    createTeam(sectionSet, settings, phase, age, section, team.club, nil, min_rating)
                    seenClubs[team.club] = true
                end
            end
        end
    end
    
    

    createSmartCollection{
        competition = settings.competition,
        root = sectionSet,
        phase = phase,
        name = "Random",
        section = section,
        age = age,
        min_rating = min_rating
    }
end

local function createAge(root, settings, phase, age, min_rating)
    local ageSet = LrApplication.activeCatalog():createCollectionSet(age, root, true)

    local sections = {}
    for _, team in pairs(settings.teams) do
        if(team.age == age) then
            if sections[team.section] == nil  then
                createSection(ageSet, settings, phase, age, team.section, min_rating)
                sections[team.section] = true
            end
        end
    end

    createSmartCollection{
        competition = settings.competition,
        root = ageSet,
        phase = phase,
        name = "Random",
        age = age,
        min_rating = min_rating
    }
end

local function createTeams(root, settings, phase, min_rating)
    local ages = {}
    for _, team in pairs(settings.teams) do
        if ages[team.age] == nil then
            createAge(root, settings, phase, team.age, min_rating)
            ages[team.age] = true
        end
    end

    createSmartCollection{
        competition = settings.competition,
        root = root,
        phase = phase,
        name = "Random",
        min_rating = min_rating
    }
end

local function createAwards(root, settings, min_rating)
    local ages = {}
    createSmartCollection{
        competition = settings.competition,
        root = root,
        phase = "Awards",
        name = "Random",
        min_rating = min_rating
    }

    for _, team in pairs(settings.teams) do
        if(ages[team.age] == nil) then
            local ageSet = LrApplication.activeCatalog():createCollectionSet(team.age, root, true)
            
            createSmartCollection{
                age = team.age,
                competition = settings.competition,
                root = ageSet,
                phase = "Awards",
                name = "Random",
                min_rating = min_rating
            }

            local sections = {}
            for _, sectionTeam in pairs(settings.teams) do
                if(sectionTeam.age == team.age and sections[sectionTeam.section] == nil) then
                    local criteria = searchCriteria(settings.competition, "Awards", sectionTeam.age, sectionTeam.section, nil, nil, nil, min_rating)
                    LrApplication.activeCatalog():createSmartCollection(sectionTeam.section, criteria, ageSet, true)
                    sections[sectionTeam.section] = true
                end
            end
            ages[team.age] = true
        end
    end
 end

local function createPhases(root, settings, min_rating)
    local phases = findAttributes("Phase")
    for phase, title in pairs(phases) do
        
        if phase == "Competition" or phase == "PodiumTraining" or phase == "CompetitionWarmup" or phase == "Qualification" then
            local phaseSet = LrApplication.activeCatalog():createCollectionSet(title, root, true)
            createTeams(phaseSet, settings, phase, min_rating)
        elseif phase == "Awards" then
            local phaseSet = LrApplication.activeCatalog():createCollectionSet(title, root, true)
            createAwards(phaseSet, settings, min_rating)
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
                    value = settings.competition,
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
                    value = min_rating,
                },
                combine = "intersect",
            }
            LrApplication.activeCatalog():createSmartCollection(title, criteria, root, true)
        end
    end
       
    createSmartCollection{
        competition = settings.competition,
        root = root,
        name = "Random",
        min_rating = min_rating
    }
end

local function ratedGroups()
    return {
        {
            title = "Sorting",
            min_rating = 0,
        },
        {
            title = "Picked",
            min_rating = 1,
        },
        {
            title = "Edited",
            min_rating = 3,
        }
    }
end

local function createRootFolder(settings)
    local root = LrApplication.activeCatalog():createCollectionSet(settings.collection_name, nil, true)

    if(settings.sort_by_rating) then 
        for _, rating in pairs(ratedGroups()) do
            local ratingGroup = LrApplication.activeCatalog():createCollectionSet(rating.title, root, true)
            createPhases(ratingGroup, settings, rating.min_rating)
        end
    else
        createPhases(root, settings)
    end
end

local function teams(settings)
    if(settings.competition_type == "international") then
        return nations()
    else
        return clubs()
    end
end

local function showDialog(context)
    local f = LrView.osFactory()
    local properties = LrBinding.makePropertyTable(context)
    
    properties.competition = ""
    properties.competition_type = "international"
    properties.sort_by_rating = true
    properties.collection_name = ""

    local contents = f:view {
        bind_to_object = properties,
        f:group_box {
            title = "Collection Name",
            fill_horizontal = 1,
            f:edit_field {
                value = LrView.bind("collection_name")
            }
        },
        f:group_box {
            title = "Competition",
            fill_horizontal = 1,
            f:edit_field {
                value = LrView.bind("competition")
            }
        },
        f:group_box {
            title = "Competition Type",
            fill_horizontal = 1,
            f:view {
                spacing = f:control_spacing(),
                f:radio_button {
                    title = "International",
                    value = LrView.bind("competition_type"),
                    checked_value = "international"
                },
                f:radio_button {
                    title = "Club",
                    value = LrView.bind("competition_type"),
                    checked_value = "club"
                }
            }
        },
        f:group_box {
            title = "Sort by Rating",
            fill_horizontal = 1,
            f:view {
                spacing = f:control_spacing(),
                place = "horizontal",
                f:checkbox {
                    value = LrView.bind("sort_by_rating")
                },
                f:static_text {
                    title = "Sort by Rating"
                }
            }
            
        },
    }

    local result = LrDialogs.presentModalDialog(
        {
            title = "Create Smart Hierarchy",
            contents = contents
        }
    )

    if(result == "ok") then
        local settings = {
            competition = properties.competition,
            competition_type = properties.competition_type,
            sort_by_rating = properties.sort_by_rating,
            teams = teams(properties),
            collection_name = properties.collection_name
        }
        createRootFolder(settings)
    end
end

local function doCreate()
    LrTasks.startAsyncTask(function ()

        LrApplication.activeCatalog():withWriteAccessDo(
        "Create TeamGym Smart Folders",
        function (context)
            showDialog(context)
        end,
        {
            timeout = 60
        }
    )
    end
)
end

doCreate()
