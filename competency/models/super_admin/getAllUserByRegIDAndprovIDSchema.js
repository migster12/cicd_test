const getAllUserByRegIDAndprovIDSchema =
{
    title: "getAllUserByRegIDAndprovIDSchema",
    type: "object",
    required:["regionID", "provID"],
    properties: {

        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        provID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = getAllUserByRegIDAndprovIDSchema;