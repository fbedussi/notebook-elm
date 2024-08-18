import {handleDialog} from './dialog.js'

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
