// const { getUserBy } = require("../database/users");
const cookies = require("../utilities/cookies");

const time = () => {
    const now = new Date();
    const dd = String(now.getDate()).padStart(2, '0');
    const mm = String(now.getMonth() + 1).padStart(2, '0'); // January is 0!
    const hh = String(now.getHours()).padStart(2, '0');
    const min = String(now.getMinutes()).padStart(2, '0');
    const ss = String(now.getSeconds()).padStart(2, '0');
  
    return `${dd}/${mm} ${hh}:${min}:${ss}`;
}

exports.verifyAuth = async (req, res, next) => {
    const user = await cookies.read(req.cookies.cookie);
    req.user = user.uid && user;
    console.log(`\n -----[ ${time()} ]-----[ ${req.url} ]-----[ ${req.user?.email} ]----- \n`);
    // res.setHeader("Cache-Control", "no-store");
    next();
};

exports.require = (req, res, next) => req.user && next();
exports.refuse = (req, res, next) => !req.user && next();
