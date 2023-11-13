const cookies = require("../utilities/cookies");

const time = () => {
    const now = new Date();
    const convert = (data) => { return String(data).padStart(2, '0') };
    const dd = convert(now.getDate());
    const mm = convert(now.getMonth() + 1); // January is 0!
    const hh = convert(now.getHours());
    const min = convert(now.getMinutes());
    const ss = convert(now.getSeconds());
  
    return `${dd}/${mm} ${hh}:${min}:${ss}`;
}

exports.verifyAuth = async (req, res, next) => {
    const user = await cookies.read(req.cookies.cookie);
    req.user = user.code && user;
    console.log(`\n -----[ ${time()} ]-----[ ${req.url} ]-----[ ${req.user?.email} ]----- \n`);
    res.setHeader("Cache-Control", "no-store");
    next();
};

exports.require = (req, res, next) => req.user && next();
exports.refuse = (req, res, next) => !req.user && next();