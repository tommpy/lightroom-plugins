return {
    metadataFieldsForPhotos = {
        {
            id = 'Club',
            title = LOC "$$$/TeamGym/Fields/Club=Club",
            searchable = true,
			browsable = true,
            dataType = 'string',
        },
        {
            id = 'Gender',
            title = LOC "$$$/TeamGym/Fields/Section=Section",
            searchable = true,
			browsable = true,
            dataType = 'enum',
            values = {
                {
                value = Nil,
                title = LOC "$$$/TeamGym/Fields/Section/Unset=Unset",
                },
                {
                value = 'Men',
                title = LOC "$$$/TeamGym/Fields/Section/Men=Men",
                },
                {
                value = 'Women',
                title = LOC "$$$/TeamGym/Fields/Section/Women=Women",
                },
                {
                value = 'Mixed',
                title = LOC "$$$/TeamGym/Fields/Section/Mixed=Mixed",
                },
            },
        },
        {
            id = 'Age',
            title = LOC "$$$/TeamGym/Fields/AgeGroup=AgeGroup",
            searchable = true,
			browsable = true,
            dataType = 'enum',
            values = {
                {
                value = 'Junior',
                title = LOC "$$$/TeamGym/Fields/AgeGroup/Junior=Junior",
                },
                {
                value = 'Senior',
                title = LOC "$$$/TeamGym/Fields/AgeGroup/Senior=Senior",
                },
                {
                value = Nil,
                title = LOC "$$$/TeamGym/Fields/AgeGroup/Unset=Unset",
                },
            },
        },
        {
            id = 'Competition',
            title = LOC "$$$/TeamGym/Fields/Competition=Competition",
            searchable = true,
			browsable = true,
            dataType = 'string',
        },
        {
            id = 'Apparatus',
            title = LOC "$$$/TeamGym/Fields/Apparatus=Apparatus",
            searchable = true,
			browsable = true,
            dataType = 'enum',
            values = {
                {
                value = Nil,
                title = LOC "$$$/TeamGym/Fields/Apparatus/Unset=Unset",
                },
                {
                value = 'Tumble',
                title = LOC "$$$/TeamGym/Fields/Apparatus/Tumble=Tumble",
                },
                {
                value = 'Trampet',
                title = LOC "$$$/TeamGym/Fields/Apparatus/Trampet=Trampet",
                },
                {
                value = 'Floor',
                title = LOC "$$$/TeamGym/Fields/Apparatus/Floor=Floor",
                },
            }
        },
    },
    schemaVersion = 2,
}
