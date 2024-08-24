import { handleDialog } from './dialog.js'
import { handlePageChange } from './changePage.js'

const basePath = new URL(document.baseURI).pathname;

const elmApp = Elm.Main.init({flags: { basePath }});

handleDialog(elmApp)

handlePageChange(elmApp)

let notes = JSON.parse(window.localStorage.getItem('notes') || "[]")

elmApp.ports.getNotes.subscribe(() => {
  elmApp.ports.gotNotes.send(notes)
})

elmApp.ports.addNote.subscribe(newNoteData => {
  const timestamp = Date.now()
  const newNote = {
    ...JSON.parse(newNoteData),
    id: crypto.randomUUID(),
    createdAt: timestamp,
    updatedAt: timestamp,
    version: 1,
  }
  notes.push(newNote)
  window.localStorage.setItem('notes', JSON.stringify(notes))
  elmApp.ports.gotNotes.send(notes)
  elmApp.ports.gotNote.send(newNote)
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

elmApp.ports.delNote.subscribe(noteId => {
  notes = notes.filter(note => note.id !== noteId)
  window.localStorage.setItem('notes', JSON.stringify(notes))
  elmApp.ports.gotNotes.send(notes)
})
