const getSCCByIDSchema =
{
    title: "getSCCByIDSchema",
    type: "object",
    required:["id"],
    properties: {
        id: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
}

module.exports = getSCCByIDSchema;