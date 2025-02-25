const changrRegionStatusSchema =
{
    title: "changrRegionStatusSchema",
    type: "object",
    required:["status"],
    properties: {
        status: {
            type: "string",
            enum: ["active", "inactive"],
        },
    }
};

module.exports = changrRegionStatusSchema;