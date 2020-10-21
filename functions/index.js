// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require("firebase-functions"); // The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const sendgridemail = require("@sendgrid/mail");
const MY_SENDGRID_API_KEY =
  "";
sendgridemail.setApiKey(MY_SENDGRID_API_KEY);

exports.sendEmail = functions.https.onRequest((request, response) => {
  const msgbody = {
    to: request.body.email,
    from: "email.mail@gmail.com",
    subject: "Email - Teste",
    templateId: "",
    substitutionWrappers: ["{{", "}}"],
    substitutions: {
      name: request.body.nome
    }
  };
  sendgridemail.send(msgbody).then(
    ok => {
      response.send(ok);
    },
    error => {
      response.send(error.response);
    }
  );
});

const accountSid = "";
const authToken = "";
const client = require("twilio")(accountSid, authToken);
exports.sendWhatsApp = functions.https.onRequest((request, response) => {
  var number = request.body.telefone;

  client.messages
    .create({
      from: "whatsapp:+99999999999",
      body: request.body.text,
      to: `whatsapp:+${number}`
    })
    .done();
});

var clientSms = new require("twilio")(accountSid, authToken);
exports.sendSms = functions.https.onRequest((request, response) => {
  var number = request.body.telefone;

  const textMessage = {
    body: request.body.text,
    to: number, // Text to this number
    from: "+99999999999" // From a valid Twilio number
  };

  return clientSms.messages.create(textMessage);
});
