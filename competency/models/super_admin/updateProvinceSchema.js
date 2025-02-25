const updateProvinceSchema =
{
    title: "updateProvinceSchema",
    type: "object",
    required:["username", "provinceName", "regionID"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        provinceName: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        provinceDirector: {
            type: "string",
            pattern: `[^<>"']+$`
        },
        regionID: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = updateProvinceSchema;