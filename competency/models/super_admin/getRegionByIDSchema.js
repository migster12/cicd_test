const getRegionByIDSchema =
{
    title: "getRegionByIDSchema",
    type: "object",
    required:["regionID"],
    properties: {
        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
}

module.exports = getRegionByIDSchema;