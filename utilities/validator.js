const PostgresError = require("./PostgresError.json");

exports.avalide = {
  email: (email) => (/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/).test(email),
  password: (password) => (/^.{8,100}$/).test(password),
};

exports.generateOTP = (length = 6) => {
  const digits = '0123456789';
  let OTP = '';
  for (let i = 0; i < length; i++) {
    OTP += digits[Math.floor(Math.random() * digits.length)];
  }
  return OTP;
};

exports.handleDbError = error => {
  if (error.severity == "ERROR") {
    for (const key in PostgresError) {
      if (error.code == key) {
        return {
          error: true,
          code: error.code,
          type: PostgresError[key],
          // error: error
        }
      }
    }
  } else {
    return error;
  }
};