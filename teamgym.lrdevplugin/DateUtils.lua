local time = require "Time"

DateUtils = {}

function DateUtils:parseDate(input)
    time.date(input)
    return 1
end