local LrDate = import "LrDate"
local LrLogger = import "LrLogger"
local LrApplication = import "LrApplication"

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

function PhotoUtils:getSelectedSource()
    local sources = LrApplication.activeCatalog():getActiveSources()

    local count = 0
    for _ in pairs(sources) do count = count + 1 end
    
    local searchDesc = {}
    local photos
    if count == 1 then
        return sources[1]
    else
        return nil
    end
end

function PhotoUtils:getSelectedPhotos()
    local activeSource = PhotoUtils:getSelectedSource()
    local photos
    if (activeSource:type() == "LrCollection") then
        photos = activeSource:getPhotos()
    elseif activeSource:type() == "LrFolder" then
        photos = activeSource:getPhotos(true)
    end
    return PhotoUtils:sortPhotos(photos)
end