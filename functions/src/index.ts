import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp(functions.config().firebase);

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});


export const helloWorld2 = functions.https.onCall((data, context) => {
  //functions.logger.info("Hello logs!", {structuredData: true});
  //response.send("Hello from Firebase!");
  return {data: "Hellow from Cloud Functions"};
});

export const getUserData = functions.https.onCall( async (data, context) => {
  if(!context.auth){
      return { "data": "Nenhum usuario logado"}
  }

  console.log(context.auth.uid);

  const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();

  console.log(snapshot.data());

  return {"data": snapshot.data()};
});

export const addMessage = functions.https.onCall(async (data, context) => {
  console.log(data);

  const snapshot = await admin.firestore().collection("messages").add(data);

  //return {"success": "Success"}
  return {"success": snapshot.id}
});

export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate((snapshot, context) => {
  const orderId = context.params.orderId;
  console.log(orderId);
});