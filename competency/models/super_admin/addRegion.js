const addRegionSchema =
{
    title: "Add Region Schema",
    type: "object",
    required:["username", "regionName"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        regionName: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        regionDirector: {
            type: "string",
            pattern: `[^<>"']+$`
        }
    }
};

module.exports = addRegionSchema;