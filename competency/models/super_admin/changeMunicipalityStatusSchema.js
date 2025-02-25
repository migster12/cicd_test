const changeMunicipalityStatusSchema =
{
    title: "changeMunicipalityStatusSchema",
    type: "object",
    required:["status"],
    properties: {
        status: {
            type: "string",
            enum: ["active", "inactive"],
        },
    }
};

module.exports = changeMunicipalityStatusSchema;