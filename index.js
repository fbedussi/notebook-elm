import { handleDialog } from './dialog.js'
import { handlePageChange } from './changePage.js'
import {authenticate, getUserId} from './auth.js';
import {addNote, deleteNote, getNote, getNotes, updateNote} from './backend.js';

const basePath = new URL(document.baseURI).pathname;

const userId = getUserId() || ''
const elmApp = Elm.Main.init({flags: { basePath, userId }});

handleDialog(elmApp)

handlePageChange(elmApp)

const MOCKED_USER = 'mock'

const MOCKED_NOTES_KEY = 'notes'
let mockedNotes = JSON.parse(window.localStorage.getItem(MOCKED_NOTES_KEY))

const withMockedBackend = ((mockedBackend, realBackend ) =>(...args) => {
  const userId = getUserId() || ''
  if (userId === MOCKED_USER) {
    if (!mockedNotes) {
      mockedNotes = [
        window.localStorage.setItem(MOCKED_NOTES_KEY, JSON.stringify([]))
      ]
    }
    return mockedBackend(...args)
  } else {
    return realBackend(...args)
  }
})

elmApp.ports.getNotes.subscribe(withMockedBackend(
    () => elmApp.ports.gotNotes.send(mockedNotes),
    () => getNotes(notes => elmApp.ports.gotNotes.send(notes))
  )
)

elmApp.ports.addNote.subscribe(withMockedBackend(
    async newNoteData => {
      const timestamp = Date.now()
      const newNote = {
        ...JSON.parse(newNoteData),
        id: crypto.randomUUID(),
        createdAt: timestamp,
        updatedAt: timestamp,
        version: 1,
      }
      mockedNotes.push(newNote)
      window.localStorage.setItem('notes', JSON.stringify(mockedNotes))
      elmApp.ports.gotNotes.send(mockedNotes)
      elmApp.ports.gotNote.send(newNote)
    },
    async newNoteData => {
      const newNote = {
        ...JSON.parse(newNoteData),
        version: 1,
      }
      addNote(newNote)
    }
  ))

elmApp.ports.getNote.subscribe(withMockedBackend(
  noteId => {
    const note = mockedNotes.find(note => note.id === noteId)
    elmApp.ports.gotNote.send(note)
  },
  noteId => {
    getNote({
      id: noteId, 
      version: 1, 
      forceUpdate: true, 
      sendNote: note => elmApp.ports.gotNote.send(note)
    })  
  })
)

elmApp.ports.saveNote.subscribe(withMockedBackend(
  note => {
    mockedNotes = mockedNotes.map(n => n.id === note.id ? {...note, updatedAt: Date.now(), version: note.version + 1} : n)  
    window.localStorage.setItem('notes', JSON.stringify(mockedNotes))
    elmApp.ports.gotNote.send(note)
  },
  note => {
    updateNote(note)
  })
)

elmApp.ports.delNote.subscribe(withMockedBackend(
    noteId => {
      mockedNotes = mockedNotes.filter(note => note.id !== noteId)
      window.localStorage.setItem('notes', JSON.stringify(mockedNotes))
      elmApp.ports.gotNotes.send(mockedNotes)
    }, 
    noteId => {
    deleteNote(noteId)
  })
)

const fakeAuthenticate = () => {
  window.localStorage.setItem('userId', MOCKED_USER)
  return MOCKED_USER
}

elmApp.ports.login.subscribe(async ({username, password}) => {
  try {
    const mockLogin = username === 'mock' && password === 'mock'
    const userId = await (mockLogin ? fakeAuthenticate() : authenticate(username, password))
    elmApp.ports.loggedIn.send(userId)
  } catch (err) {
    console.error(err)
  }
})
