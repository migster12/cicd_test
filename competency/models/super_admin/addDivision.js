const addDivisionSchema =
{
    title: "addDivisionSchema",
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
            pattern: `[^<>"']+$`,
            minLength: 0
        },
        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = addDivisionSchema;