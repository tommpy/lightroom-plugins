local LrApplication = import "LrApplication"
local LrDialogs = import "LrDialogs"
local LrTasks = import "LrTasks"
local LrLogger = import "LrLogger"
local LrDate = import "LrDate"
local LrView = import "LrView"
local LrBinding = import "LrBinding"
require "PhotoUtils"

local logger = LrLogger('teamgymlogger')
logger:enable( "logfile" )

local function showDialog(context)
    local textSpacerHeight = 5
    local fieldSpacerHeight = 15

    local f = LrView.osFactory()
    local properties = LrBinding.makePropertyTable(context)
    
    properties.collection_name = "Sorted"

    local contents = f:view {
        bind_to_object = properties,
        f:group_box {
            title = "Collection Name",
            fill_horizontal = 1,
            f:edit_field {
                value = LrView.bind("collection_name")
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
    }
end

local function groupIntoCollections(context)
    local params = showDialog(context)
    local photos = PhotoUtils:getSelectedPhotos()
    local collectionCount = 1
    local rootSet = LrApplication.activeCatalog():createCollectionSet(params.collection_name, nil, true)
    local dividedSet = LrApplication.activeCatalog():createCollectionSet("Grouped", rootSet, true)

    local collectionPhotos = {}
    
    for i, photo in ipairs(photos) do
        logger:info(photo:getFormattedMetadata("fileName"))

        if(photo:getFormattedMetadata("dimensions") == "640 x 480") then
            logger:info("Divider")
            local collection = LrApplication.activeCatalog():createCollection("Group " .. collectionCount, dividedSet, true)
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
                groupIntoCollections(context)
            end,
            {
                timeout = 5
            }
        )
    end
)
end

doSort()