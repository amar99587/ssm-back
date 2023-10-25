const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "laziri.com@gmail.com",
      pass: "kekkqzxpikcmogux"
    }
});

const options = (email) => { return {
  from: "laziri.com@gmail.com",
  to: email.to,
  subject: email.title,
  html: email.html || `
  <!DOCTYPE html>
  <html lang="en">
    <body>
        <h3 style="width: 100%;text-align: center;color: white;padding: 20px;margin: 20px;background: #0085ff;">
          ${email.content}
        </h3>
    </body>
  </html>`
}};

const OTP = (email, value) => {
  return {
    to: email,
    title: "OTP code to verify email",
    content: `your OTP code is ${value}`
  }
};

const result = (email) => new Promise((resolve, reject) => {
  transporter.sendMail(options(email), (error, info) => error ? reject(error) : resolve(info.response));
});

exports.send = {
  OTP: async (email, value) => { return await result(OTP(email, value)); },
};