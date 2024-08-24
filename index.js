import { handleDialog } from './dialog.js'
import { handlePageChange } from './changePage.js'
import {authenticate, getUserId} from './auth.js';
import {addNote, deleteNote, getNote, getNotes, updateNote} from './backend.js';

const basePath = new URL(document.baseURI).pathname;

const userId = getUserId() || ''
const elmApp = Elm.Main.init({flags: { basePath, userId }});

handleDialog(elmApp)

handlePageChange(elmApp)

elmApp.ports.getNotes.subscribe(async () => {
  getNotes(notes => elmApp.ports.gotNotes.send(notes))
})

elmApp.ports.addNote.subscribe(async newNoteData => {
  // const timestamp = Date.now()
  const newNote = {
    ...JSON.parse(newNoteData),
    // id: crypto.randomUUID(),
    // createdAt: timestamp,
    // updatedAt: timestamp,
    version: 1,
  }
  const noteId = await addNote(newNote)
  // notes.push(newNote)
  // window.localStorage.setItem('notes', JSON.stringify(notes))
  // elmApp.ports.gotNotes.send(notes)
  // elmApp.ports.gotNote.send(newNote)
})

elmApp.ports.getNote.subscribe(noteId => {
  getNote({
    id: noteId, 
    version: 1, 
    forceUpdate: true, 
    sendNote: note => elmApp.ports.gotNote.send(note)
  })  
})

elmApp.ports.saveNote.subscribe(note => {
  // notes = notes.map(n => n.id === note.id ? {...note, updatedAt: Date.now(), version: note.version + 1} : n)  
  // window.localStorage.setItem('notes', JSON.stringify(notes))
  // elmApp.ports.gotNote.send(note)
  updateNote(note)
})

elmApp.ports.delNote.subscribe(noteId => {
  // notes = notes.filter(note => note.id !== noteId)
  // window.localStorage.setItem('notes', JSON.stringify(notes))
  // elmApp.ports.gotNotes.send(notes)
  deleteNote(noteId)
})

elmApp.ports.login.subscribe(async ({username, password}) => {
  try {
    const userId = await authenticate(username, password)
    elmApp.ports.loggedIn.send(userId)
  } catch (err) {
    console.error(err)
  }
})
