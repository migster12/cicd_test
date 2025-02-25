const addSCCSchema =
{
    title: "addSCCSchema",
    type: "object",
    required:["username", "sccName", "type", "regionID", "provinceID"],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        sccName: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        clusterHead: {
            type: "string",
            pattern: `[^<>"']+$`
        },
        type: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        regionID: {
            type: "string",
            pattern: `[^<>"']+$`
        },
        provinceID: {
            type: "string",
            pattern: `[^<>"']+$`
        }
    }
};

module.exports = addSCCSchema;