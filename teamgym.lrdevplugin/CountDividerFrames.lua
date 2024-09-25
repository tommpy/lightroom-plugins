local LrApplication = import "LrApplication"
local LrDialogs = import "LrDialogs"
local LrTasks = import "LrTasks"

local function countDividersInFolder(folder)
    local photos = folder:getPhotos(true)
    local count = 0
    for i, photo in ipairs(photos) do
        if(photo:getFormattedMetadata("dimensions") == "640 x 480") then
            count = count + 1
        end
    end

    return count
end

local function countDividers()
    local sources = LrApplication.activeCatalog():getActiveSources()

    local count = 0
    for _ in pairs(sources) do count = count + 1 end
    
    if count == 1 then
        local activeSource = sources[1]
        if (type(activeSource) == "table") and (activeSource:type() == "LrCollectionSet") then
            local collectionSetName = activeSource:getName()

            LrDialogs.message("Collection Set " .. collectionSetName)
        elseif (type(activeSource) == "table") and (activeSource:type() == "LrFolder") then
            local count = countDividersInFolder(activeSource)
            LrDialogs.message("Total dividers: " .. count)
        end
    end
end

local function doCount()
    LrTasks.startAsyncTask(function ()
        LrApplication.activeCatalog():withWriteAccessDo(
        "Count Dividers",
        function (context)
            countDividers()
        end,
        {
            timeout = 5
        }
    )
    end
)
end

doCount()