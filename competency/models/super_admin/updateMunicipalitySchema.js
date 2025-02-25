const updateProvinceSchema =
{
    title: "updateProvinceSchema",
    type: "object",
    required:["username", "municipalityName"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        municipalityName: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        clusterID: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        provinceOrCityID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = updateProvinceSchema;