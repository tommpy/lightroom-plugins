local LrDate = import "LrDate"
local LrLogger = import "LrLogger"

local date = require("date")
local logger = LrLogger('teamgymlog')
logger:enable( "logfile" )

PhotoUtils = {}

function PhotoUtils:photoDate(photo)
    local formattedDate = photo:getFormattedMetadata("dateCreated")
    local parsedDate = date(formattedDate)
    logger:info("Created=" .. photo:getFormattedMetadata("dateCreated") .. ", parsed=" .. parsedDate)

    return parsedDate
end

local function compareDates(photoA, photoB)
    return photoA["date"] < photoB["date"]
end

function PhotoUtils:sortPhotos(photos)
    local a = {}
    for _, p in ipairs(photos) do
        local v = {photo = p, date = PhotoUtils:photoDate(p)}
        table.insert(a, v)
    end
    table.sort(a, compareDates)

    local b = {}
    for _, p in ipairs(a) do
        logger:info("Name=" .. p["photo"]:getFormattedMetadata("fileName") .. ", date=" .. p["date"])
        table.insert(b, p["photo"])
    end
    
    return b
end

function PhotoUtils:getSelectedPhotos()
    local sources = LrApplication.activeCatalog():getActiveSources()

    local count = 0
    for _ in pairs(sources) do count = count + 1 end
    
    local searchDesc = {}
    if count == 1 then
        local activeSource = sources[1]
        if activeSource:type() == "LrCollectionSet" then
            return activeSource:getPhotos()
        elseif activeSource:type() == "LrFolder" then
            local photos = activeSource:getPhotos(true)
            local sortedPhotos = PhotoUtils:sortPhotos(photos)
            return sortedPhotos
        end
    end
end