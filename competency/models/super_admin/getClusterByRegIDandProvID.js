const getClusterByregIDandProvIDSchema =
{
    title: "getClusterByregIDandProvIDSchema",
    type: "object",
    required:["rid", "provID"],
    properties: {
        rid: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        provID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
}

module.exports = getClusterByregIDandProvIDSchema;