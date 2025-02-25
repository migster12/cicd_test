const updateDivisionSchema =
{
    title: "updateDivisionSchema",
    type: "object",
    required:["username", "divisionName", "regionID"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        divisionName: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        divisionChief: {
            type: "string",
            pattern: `[^<>"']+$`
        },
        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = updateDivisionSchema;