const registerSchema =
{
    title: "Register Schema",
    type: "object",
    required:["username", "password"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        password: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        }
    }
};

module.exports = registerSchema;