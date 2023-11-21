return {
    metadataFieldsForPhotos = {
        {
            id = 'Section',
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
        {
            id = 'Phase',
            title = LOC "$$$/TeamGym/Fields/Phase=Phase",
            searchable = true,
			browsable = true,
            dataType = 'enum',
            version = 2,
            values = {
                {
                value = Nil,
                title = LOC "$$$/TeamGym/Fields/Phase/Unset=Unset",
                },
                {
                value = 'Travelling',
                title = LOC "$$$/TeamGym/Fields/Phase/Travelling=Travelling",
                },
                {
                value = 'PodiumTraining',
                title = LOC "$$$/TeamGym/Fields/Phase/PodiumTraining=Podium Training",
                },
                {
                value = 'Competition',
                title = LOC "$$$/TeamGym/Fields/Phase/Competition=Competition",
                },
                {
                value = 'CompetitionWarmup',
                title = LOC "$$$/TeamGym/Fields/Phase/CompetitionWarmUp=Competition Warm Up",
                },
                {
                value = 'Awards',
                title = LOC "$$$/TeamGym/Fields/Phase/Awards=Awards",
                },
                {
                value = 'Banquet',
                title = LOC "$$$/TeamGym/Fields/Phase/Banquet=Banquet",
                }
            }
        },
        {
            id = 'Club',
            title = LOC "$$$/TeamGym/Fields/Club=Club",
            searchable = true,
			browsable = true,
            dataType = 'enum',
            version = 2,
            values = {
                {
                value = Nil,
                title = LOC "$$$/TeamGym/Fields/Club/Unset=Unset",
                },
                {
                value = 'Bracknell',
                title = LOC "$$$/TeamGym/Fields/Club/Bracknell=Bracknell",
                },
                {
                value = 'Majestic',
                title = LOC "$$$/TeamGym/Fields/Club/Majestic=Majestic",
                },
                {
                value = 'Crewe',
                title = LOC "$$$/TeamGym/Fields/Club/Crewe=Crewe",
                },
                {
                value = 'Portsmouth',
                title = LOC "$$$/TeamGym/Fields/Club/Portsmouth=Portsmouth",
                },
                {
                value = 'Hawth',
                title = LOC "$$$/TeamGym/Fields/Club/Hawth=Hawth",
                },
                {
                value = 'Newcastle',
                title = LOC "$$$/TeamGym/Fields/Club/Newcastle=Newcastle",
                },
                {
                value = 'Scarborough',
                title = LOC "$$$/TeamGym/Fields/Club/Scarborough=Scarborough",
                },
            }
        },
    },
    schemaVersion = 2,
}
