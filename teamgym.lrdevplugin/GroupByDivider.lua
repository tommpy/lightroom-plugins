local LrApplication = import "LrApplication"
local LrDialogs = import "LrDialogs"
local LrTasks = import "LrTasks"
local LrLogger = import "LrLogger"
local LrDate = import "LrDate"
require "PhotoUtils"

local logger = LrLogger('teamgymlogger')
logger:enable( "logfile" )

local function groupIntoCollections()
    local photos = PhotoUtils:getSelectedPhotos()
    local collectionCount = 1
    local rootSet = LrApplication.activeCatalog():createCollectionSet("Sorted", nil, true)

    local collectionPhotos = {}
    
    for i, photo in ipairs(photos) do
        logger:info(photo:getFormattedMetadata("fileName"))

        if(photo:getFormattedMetadata("dimensions") == "640 x 480") then
            logger:info("Divider")
            local collection = LrApplication.activeCatalog():createCollection("Group " .. collectionCount, rootSet, true)
            collection:addPhotos(collectionPhotos)

            collectionCount = collectionCount + 1
            collectionPhotos = {}
        else
            logger:info("Vanilla")
            table.insert(collectionPhotos, photo)
        end
    end

    return collectionCount
end

local function doSort()
    LrTasks.startAsyncTask(function ()
        LrApplication.activeCatalog():withWriteAccessDo("Group by Dividers",
            function (context)
                groupIntoCollections()
            end,
            {
                timeout = 5
            }
        )
    end
)
end

doSort()