const updateRegionSchema =
{
    title: "updateRegionSchema",
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
        regionAdmin: {
            type: "string",
            pattern: `[^<>"']+$`
        }
    }
};

module.exports = updateRegionSchema;