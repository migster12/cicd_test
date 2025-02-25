const addUserSchema = {
    title: "addUserSchema",
    type: "object",
    required: [
        "username", "name", "email", "user_type", "education", "mobile_number",
        "position", "sex", "date_of_birth", "place_of_birth", "address"
    ],
    properties: {
        username: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        name: {
            type: "string",
            minLength: 2,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        email: {
            type: "string",
            minLength: 5,
            maxLength: 255,
            pattern: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$`
        },
        region_id: {
            type: "string",
            pattern: `^[0-9]*$`,
            minLength: 0
        },
        user_type: {
            type: "string",
            minLength: 1,
            maxLength: 50,
            pattern: `[^<>"']+$`
        },
        education: {
            type: "string",
            minLength: 1,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        mobile_number: {
            type: "string",
            pattern: `^[0-9]{10,15}$`
        },
        division_id: {
            type: "string",
            pattern: `^[0-9]*$`,
            minLength: 0
        },
        position: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        sex: {
            type: "string",
            enum: ["male", "female"]
        },
        date_of_birth: {
            type: "string",
            minLength: 1,
            maxLength: 100,
            pattern: `[^<>"']+$`
        },
        province_or_huc_id: {
            type: "string",
            pattern: `^[0-9]*$`,
            minLength: 0
        },
        place_of_birth: {
            type: "string",
            minLength: 1,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        address: {
            type: "string",
            minLength: 1,
            maxLength: 255,
            pattern: `[^<>"']+$`
        },
        municipality_id: {
            type: "string",
            pattern: `^[0-9]*$`,
            minLength: 0
        },
        scc_id: {
            type: "string",
            pattern: `^[0-9]*$`,
            minLength: 0
        },
        remarks: {
            type: "string",
            minLength: 1,
            maxLength: 255,
            pattern: `[^<>"']+$`
        }
    }
};

module.exports = addUserSchema;
