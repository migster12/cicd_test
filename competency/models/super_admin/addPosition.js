const addPositionSchema =
{
    title: "addPositionSchema",
    type: "object",
    required:["position_name"],
    properties: {
        position_name: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
    }
};

module.exports = addPositionSchema;