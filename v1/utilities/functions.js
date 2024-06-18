exports.removeEmptyFromObject = (obj) => Object.entries(obj).reduce((acc, [key, value]) => {
    if (!["", null, undefined].includes(value)) {
        acc[key] = value;
    }
    return acc;
}, {});