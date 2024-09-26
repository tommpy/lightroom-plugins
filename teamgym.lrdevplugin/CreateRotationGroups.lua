require "PhotoUtils"
require "TeamGymUtils"

local LrApplication = import "LrApplication"
local LrDialogs = import "LrDialogs"
local LrTasks = import "LrTasks"
local LrLogger = import "LrLogger"
local LrView = import "LrView"
local LrBinding = import "LrBinding"

local logger = LrLogger('teamgymlogger')
logger:enable( "logfile" )

local function createCollections(groups, collection_name)
    local catalog = LrApplication.activeCatalog()
    local activeSource = PhotoUtils:getSelectedSource()

    local parent
    if(activeSource:type() == "LrCollection") then
        parent = activeSource:getParent()
        if parent ~= nil and parent:getName() == "Grouped" then
            parent = catalog:createCollectionSet(collection_name, parent:getParent())
        else
            parent = catalog:createCollectionSet(collection_name)
        end
    else
        parent = catalog:createCollectionSet(collection_name)
    end

    for team, apps in pairs(groups) do
        local teamCollection = catalog:createCollectionSet(team, parent)

        for app, photos in pairs(apps) do
            local appCollection = catalog:createCollection(app, teamCollection)

            appCollection:addPhotos(photos)
        end
    end
end

local function addIfNotNull(collection, key, destination)
    local value = collection[key]
    if(not(value == nill or value == '')) then
        table.insert(destination, value)
    end
end

local function extractTeams(inputs)
    local teams = {}
    for i = 1, 10, 1 do
        addIfNotNull(inputs, "team" .. i, teams)
    end

    return teams
end

local function showDialog(context)
    local textSpacerHeight = 5
    local fieldSpacerHeight = 15

    local f = LrView.osFactory()
    local properties = LrBinding.makePropertyTable(context)
    
    properties.collection_name = PhotoUtils:getSelectedSource():getName()
    properties.comp_type = "micro"
    properties.team1 = ""
    properties.team2 = ""
    properties.team3 = ""
    properties.team4 = ""
    properties.team5 = ""
    properties.team6 = ""
    properties.team7 = ""
    properties.team8 = ""
    properties.team9 = ""
    properties.team10 = ""

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
            title = "Competition Type",
            fill_horizontal = 1,
            f:view {
                spacing = f:control_spacing(),
                f:radio_button {
                    title = "Micros",
                    value = LrView.bind("comp_type"),
                    checked_value = "micro"
                },
                f:radio_button {
                    title = "Full",
                    value = LrView.bind("comp_type"),
                    checked_value = "full"
                }
            }
        },
        f:group_box {
            title = "Teams",
            fill_horizontal = 1,
            f:edit_field {
                value = LrView.bind("team1")
            },
            f:edit_field {
                value = LrView.bind("team2")
            },
            f:edit_field {
                value = LrView.bind("team3")
            },
            f:edit_field {
                value = LrView.bind("team4")
            },
            f:edit_field {
                value = LrView.bind("team5")
            },
            f:edit_field {
                value = LrView.bind("team6")
            },
            f:edit_field {
                value = LrView.bind("team7")
            },
            f:edit_field {
                value = LrView.bind("team8")
            },
            f:edit_field {
                value = LrView.bind("team9")
            },
            f:edit_field {
                value = LrView.bind("team10")
            }
        }
    } 

    local result = LrDialogs.presentModalDialog(
        {
            title = "Group by Rotation",
            contents = contents
        }
    )

    return {
        collection_name = properties.collection_name,
        comp_type = properties.comp_type,
        teams = extractTeams(properties)
    }
end

local function groupByRotations(context)
    local photos = PhotoUtils:getSelectedPhotos()
    local params = showDialog(context)
    
    local apps = {"Tumble", "Trampet"}

    local groups = {}
    for _, team in ipairs(params.teams) do
        local teamApps = {}
        for _, app in ipairs(apps) do
            teamApps[app] = {}
        end

        groups[team] = teamApps
    end

    local order = TeamGymUtils:sortMicroGroups(params.teams)
    local currentGroup = {}
    local i = 1

    for _, photo in ipairs(photos) do
        logger:info(photo:getFormattedMetadata("fileName"))
        table.insert(currentGroup, photo)

        if(photo:getRawMetadata("rating") == 1) then
            local team = order[i].team
            local app = order[i].app
            groups[team][app] = currentGroup
            
            logger:info("Create Group For " .. team .. "/" .. app)
                
            currentGroup = {}
            i = i + 1
        end
    end

    createCollections(groups, params.collection_name)
    return groups
end

local function doCreate()
    LrTasks.startAsyncTask(function ()
        LrApplication.activeCatalog():withWriteAccessDo(
        "Create Rotations",
        function (context)
            groupByRotations(context)
        end,
        {
            timeout = 5
        }
        )
        end
    )
end

doCreate()