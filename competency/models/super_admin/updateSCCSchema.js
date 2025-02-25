const updateSCCSchema =
{
    title: "updateSCCSchema",
    type: "object",
    required:["username", "scc_name", "type", "region_id", "province_or_city_id"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        scc_name: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        scc_head: {
            type: "string",
            pattern: `[^<>"']+$`
        },
        region_id: {
            type: "string",
            pattern: "^[0-9]+$"
        },
        type: {
            type: "string",
            enum: ["section", "city", "cluster"],
        },
        province_or_city_id: {
            type: "string",
            pattern: "^[0-9]+$"
        }
    }
};

module.exports = updateSCCSchema;