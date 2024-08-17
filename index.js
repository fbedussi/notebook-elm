import {handleDialog} from './dialog.js'

// import { initializeApp } from "firebase/app";

// const firebaseConfig = {
//   apiKey: "AIzaSyBenlzLRgjVQHnt4uQwqMGE1O7q3mcKhMo",
//   authDomain: "notebook-elm.firebaseapp.com",
//   projectId: "notebook-elm",
//   storageBucket: "notebook-elm.appspot.com",
//   messagingSenderId: "1057896746277",
//   appId: "1:1057896746277:web:fb294ac1340bb5a4df9ecc"
// };

// const firebaseApp = initializeApp(firebaseConfig);

const elmApp = Elm.Main.init();

handleDialog(elmApp)

let notes = []
elmApp.ports.addNote.subscribe(newNoteData => {
  const timestamp = Date.now()
  notes.push({
    ...JSON.parse(newNoteData),
    id: crypto.randomUUID(),
    createdAt: timestamp,
    updatedAt: timestamp,
  })
  elmApp.ports.gotNotes.send(notes)
})
