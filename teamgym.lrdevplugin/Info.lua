return {
    LrSdkVersion = 5.0,
    LrToolkitIdentifier = 'com.teamgymphotos.teamgym',
    LrPluginName = LOC "$$$/TeamGym/PluginName=Team Gym Plugin",
    LrMetadataProvider = 'MyMetadataDefinitionFile.lua',
    LrMetadataTagsetFactory = 'MyMetadataTagset.lua',
	VERSION = { major=0, minor=0, revision=2, },
    LrExportMenuItems = {
        {
            title = 'Create Smart TeamGym Hierarchy',
            file = 'CreateSmartTeamGymHierarchy.lua'
        },
        {
            title = 'Count Dividers',
            file = 'CountDividerFrames.lua'
        },
        {
            title = 'Group by Divider',
            file = 'GroupByDivider.lua'
        },
        {
            title = 'Create Rotation Groups',
            file = 'CreateRotationGroups.lua'
        }
    }
}
