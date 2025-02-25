const getAllUserByRegIDAndMuniIDSchema =
{
    title: "getAllUserByRegIDAndMuniIDSchema",
    type: "object",
    required:["regionID", "municipalityID"],
    properties: {

        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        municipalityID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = getAllUserByRegIDAndMuniIDSchema;