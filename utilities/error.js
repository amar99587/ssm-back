exports.newError = (error) => { 
    console.log(error ? 1 : 0);
    throw new Error(
        JSON.stringify({
            code: error.code || 500, 
            id: error.id, 
            value: (typeof error == "string" ? error : error.message)
        })
    ); 
};

exports.resError = (res, error) => {
    console.log("message : ", error.message);
    error = typeof error.message == "string" ? error.message : JSON.parse(error.message);
    return res.status(error.code || 500).send(error);
};