const changrDivisionStatusSchema =
{
    title: "changrDivisionStatusSchema",
    type: "object",
    required:["status"],
    properties: {
        status: {
            type: "string",
            enum: ["active", "inactive"],
        },
    }
};

module.exports = changrDivisionStatusSchema;