const changeProvinceStatusSchema =
{
    title: "changeProvinceStatusSchema",
    type: "object",
    required:["status"],
    properties: {
        status: {
            type: "string",
            enum: ["active", "inactive"],
        },
    }
};

module.exports = changeProvinceStatusSchema;