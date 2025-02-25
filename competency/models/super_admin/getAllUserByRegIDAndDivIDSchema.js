const getAllUserByRegIDAndDivIDSchema =
{
    title: "getAllUserByRegIDAndDivIDSchema",
    type: "object",
    required:["regionID", "divID"],
    properties: {

        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        divID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = getAllUserByRegIDAndDivIDSchema;