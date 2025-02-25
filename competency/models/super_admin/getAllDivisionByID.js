const getDivisionByIDSchema =
{
    title: "getDivisionByIDSchema",
    type: "object",
    required:["divisionID"],
    properties: {
        divisionID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
}

module.exports = getDivisionByIDSchema;