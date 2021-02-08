// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require("firebase-functions"); // The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const sendgridemail = require("@sendgrid/mail");
const MY_SENDGRID_API_KEY =
  "SEND GRID KEY";
sendgridemail.setApiKey(MY_SENDGRID_API_KEY);

exports.sendEmail = functions.https.onRequest((request, response) => {
  sendgridemail.setSubstitutionWrappers("{{", "}}");
  const msgbody = {
    to: request.body.email,
    from: "jailson.panizzon@outlook.com",
    subject: "HYPR - Conectando as pessoas",
    templateId: "",
    dynamicTemplateData: {
      mensagem: request.body.mensagem,
    },
  };
  sendgridemail.send(msgbody).then(
    (ok) => {
      response.send(ok);
    },
    (error) => {
      response.send(error.response);
    }
  );
});

exports.sendWhatsApp = functions.https.onRequest((request, response) => {
  let getMessage = request.params.text,
    getPhoneTo = `+${request.body.telefone}`,
    getPhoneFrom = "+1 847 865 9862",
    accountSid = "",
    authToken = "";

  //require the Twilio module and create a REST client
  var client = require("twilio")(accountSid, authToken);

  client.messages
    .create({
      from: `whatsapp:${getPhoneFrom}`,
      body: request.body.text,
      to: `whatsapp:+${getPhoneTo}`,
    })
    .then(function (results) {
      response.send(results.sid);
    })
    .catch(function (error) {
      response.send(error);
    });
});

exports.sendSms = functions.https.onRequest((request, response) => {
  let getMessage = request.body.text,
    getPhoneTo = `+${request.body.telefone}`,
    getPhoneFrom = "+1 847 865 9862",
    accountSid = "",
    authToken = "";

  //require the Twilio module and create a REST client
  var client = require("twilio")(accountSid, authToken);

  client.messages
    .create({
      body: getMessage, // Any number Twilio can deliver to
      from: getPhoneFrom, // A number you bought from Twilio and can use for outbound communication
      to: getPhoneTo, // body of the SMS message
    })
    .then(function (results) {
      response.send(results.sid);
    })
    .catch(function (error) {
      response.send(error);
    });
});
