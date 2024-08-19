import { handleDialog } from './dialog.js'
import { handlePageChange } from './changePage.js'

const elmApp = Elm.Main.init();

handleDialog(elmApp)

handlePageChange(elmApp)

let notes = JSON.parse(window.localStorage.getItem('notes') || "[]")

elmApp.ports.getNotes.subscribe(() => {
  elmApp.ports.gotNotes.send(notes)
})

elmApp.ports.addNote.subscribe(newNoteData => {
  const timestamp = Date.now()
  notes.push({
    ...JSON.parse(newNoteData),
    id: crypto.randomUUID(),
    createdAt: timestamp,
    updatedAt: timestamp,
    version: 1,
  })
  window.localStorage.setItem('notes', JSON.stringify(notes))
  elmApp.ports.gotNotes.send(notes)
})

elmApp.ports.getNote.subscribe(noteId => {
  const note = notes.find(note => note.id === noteId)
  elmApp.ports.gotNote.send(note)
})

elmApp.ports.saveNote.subscribe(note => {
  notes = notes.map(n => n.id === note.id ? {...note, updatedAt: Date.now(), version: note.version + 1} : n)  
  window.localStorage.setItem('notes', JSON.stringify(notes))
  elmApp.ports.gotNote.send(note)
})
