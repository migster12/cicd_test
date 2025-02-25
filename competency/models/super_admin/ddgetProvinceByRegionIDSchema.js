const getProviceByregionIDSchema =
{
    title: "getProviceByregionIDSchema",
    type: "object",
    required:["rid"],
    properties: {
        rid: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
}

module.exports = getProviceByregionIDSchema;