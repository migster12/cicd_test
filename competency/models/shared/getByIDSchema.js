const getByIDSchema =
{
    title: "getByIDSchema",
    type: "object",
    required:["id"],
    properties: {

        id: {
            type: "string",
            pattern: "^[0-9]+$"
        },
    }
};

module.exports = getByIDSchema;