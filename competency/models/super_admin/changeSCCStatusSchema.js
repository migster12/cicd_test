const changeSCCStatusSchema =
{
    title: "changeSCCStatusSchema",
    type: "object",
    required:["status"],
    properties: {
        status: {
            type: "string",
            enum: ["active", "inactive"],
        },
    }
};

module.exports = changeSCCStatusSchema;