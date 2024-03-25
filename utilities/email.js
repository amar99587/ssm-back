const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
    service: process.env.email_provider,
    auth: {
      user: process.env.email_user,
      pass: process.env.email_password
    }
});

const options = (email) => { return {
  from: process.env.email_user,
  to: email.to,
  subject: email.title,
  html: email.html || `
  <!DOCTYPE html>
  <html lang="en">
    <body>
        <h3>${email.content}</h3>
    </body>
  </html>`
}};

const template = (type, email, value) => {
  if (type == 'OTP') {
    return {
      to: email,
      title: "OTP code to verify email",
      content: `your OTP code is ${value}`
    }
  } else if (type == 'payment') {
    return {
      to: email,
      title: `Payment Received: ${value.total} DZD for Course ${value.course_name} at ${value?.school_name}`,
      html: `
      <!DOCTYPE html>
      <html lang="en">
        <body>
          <h3>Dear School Owner,</h3>
          <h4>
            We are pleased to inform you that a new payment has been
            received for the course "${value.course_name}" at your school. <br>
            Here are the details: 
          </h4>
          <p>
            Course Name : ${value.course_name} <br>
            Price : ${value.price} DZD <br>
            Quantity : ${value.quantity} <br>
            Total : <a style="text-decoration: underline;font-weight: 700;">${value.total} DZD</a><br>
            User Name : ${value.user_name} <br>
            User Code : ${value.user_code} <br>
            Payment Date : ${value.created_at}
          </p>
          <h4>Thank you for your continued partnership.</h4>
          <h4>Best regards.</h4>
        </body>
      </html>`
    }
  } else {
    return {
      to: email,
      title: value.title,
      content: value.content
    }
  }
};

const result = (email) => new Promise((resolve, reject) => {
  transporter.sendMail(options(email), (error, info) => error ? reject(error) : resolve(info.response));
});

exports.send = async (type, email, value) => await result(template(type, email, value));