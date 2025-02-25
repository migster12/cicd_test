const addMessageSchema =
{
    title: "addMessageSchema",
    type: "object",
    required:["message"],
    properties: {
        message: {
            type: "string",
            minLength: 1,
            maxLength: 5000,
            pattern: `[^<>"']+$`
        },
    }
};

module.exports = addMessageSchema;