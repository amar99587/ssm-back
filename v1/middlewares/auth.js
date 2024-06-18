const cookies = require("../utilities/cookies");

exports.verifyAuth = async (req, res, next) => {
    // const origin = req.headers.origin;
    // if(origin == process.env.cors_origin) {
        try {
            const user = await cookies.read(req.cookies.cookie);
            // const school = await cookies.read(req.cookies.cookie2);
            req.time = Date.now();
            req.user = user.code && user;
            // req.school = school.code && school;
            if (process.env.app_env.endsWith('development')) {
                console.log(`\n -----[ ${ new Date().toLocaleString() } ]-----[ ${req.ip} ]-----[ ${req.url} ]-----[ ${req.user?.email} ]----- \n`);
            }
        } catch (error) {
            console.log(error.name, ' => ', error.message);
        }
        res.setHeader("Cache-Control", "no-store");
        next();
    // } else {
    //     res.status(403).json({ message: 'Access Denied' });
    // }
};

exports.require = (req, res, next) => req.user ? next() : res.status(401).json({ message: 'Unauthorized' });
exports.refuse = (req, res, next) => !req.user ? next() : res.status(403).json({ message: 'Access Denied' });
