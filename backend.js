//@ts-check
import { initializeApp } from 'firebase/app'
import {
  browserLocalPersistence,
  getAuth,
  setPersistence,
  signInWithEmailAndPassword,
  signOut,
} from 'firebase/auth'
import {
  enableIndexedDbPersistence,
  getFirestore,
  collection,
  query,
  where,
  onSnapshot,
  doc,
  addDoc,
  deleteDoc,
  updateDoc,
} from 'firebase/firestore'

const USER_ID = 'userId'

export const getUserId = () => {
  return window.localStorage.getItem(USER_ID)
}

/**
 * @typedef {Object} AddNotePayload
 * @property {string} title
 * @property {string} text
 * @property {number} version 
 */

/**
 * @typedef {AddNotePayload & {id: string}} Note 
 */

const firebaseConfig = {
  apiKey: "AIzaSyBenlzLRgjVQHnt4uQwqMGE1O7q3mcKhMo",
  authDomain: "notebook-elm.firebaseapp.com",
  projectId: "notebook-elm",
  storageBucket: "notebook-elm.appspot.com",
  messagingSenderId: "1057896746277",
  appId: "1:1057896746277:web:fb294ac1340bb5a4df9ecc"
}

const app = initializeApp(firebaseConfig)
const auth = getAuth(app)

export const initAuth = setPersistence(auth, browserLocalPersistence).then(() => auth)

export const db = getFirestore(app)

enableIndexedDbPersistence(db).catch(err => {
  if (err.code === 'failed-precondition') {
    // Multiple tabs open, persistence can only be enabled
    // in one tab at a a time.
    console.error(
      'Fail to enable persistence, due to a missing precondition (e.g. multiple tabs open)',
    )
  } else if (err.code === 'unimplemented') {
    // The current browser does not support all of the
    // features required to enable persistence
    console.error('Fail to enable persistence, due to a lack of browser support')
  }
})

/**
 * 
 * @param {{ email: string; password: string }} params 
 * @returns {Promise<{
 *  id: string
 *  username: string
 * }>}
 */
export const loginBe = async ({ email, password }) => {
  const auth = getAuth(app)
  await setPersistence(auth, browserLocalPersistence)
  const response = await signInWithEmailAndPassword(auth, email, password)
  return {
    id: response.user.uid,
    username: response.user.providerData[0].uid,
  }
}

export const logoutBe = async () => {
  const auth = getAuth(app)

  signOut(auth).then(() => {
    return true
  })
}

const NOTES_COLLECTION_NAME = 'notes'

const baseNote = {
  text: '',
  todos: [],
  version: 1,
  archived: false,
  createdAt: 0,
}

/**
 * 
 * @param {(notes: Note[]) => void} sendNotes 
 */
export const getNotes = async (sendNotes) => {
  const userId = getUserId()
  if (!userId) {
    throw new Error('user is not logged in')
  }

  const q = query(collection(db, NOTES_COLLECTION_NAME), where('userId', '==', userId))
  onSnapshot(q, querySnapshot => {
    /**
     * @type {Note[]}
     */
    const updatedNotes = []
    querySnapshot.forEach(doc => {
      const note = /** @type {Note} */ (doc.data())
      updatedNotes.push({
        ...baseNote,
        ...note,
        id: doc.id,
      })
    })
    sendNotes(updatedNotes)
  })
}

/**
 * 
 * @param {{
 *  id: string, 
 *  version?: number,
 *  sendNote: (note: Note) => void, 
 *  forceUpdate: boolean
 * }} params  
 */
export const getNote = async ({id, version, sendNote, forceUpdate}) => {
  const userId = getUserId()
  const q = query(
    collection(db, NOTES_COLLECTION_NAME),
    where('__name__', '==', id),
    where('userId', '==', userId),
  )
  onSnapshot(q, querySnapshot => {
    /**
     * @type {Note[]}
     */
    const updatedNotes = []
    querySnapshot.forEach(doc => {
      updatedNotes.push({
        ...baseNote,
        .../** @type {Note} */(doc.data()),
        id: doc.id,
      })
    })
    const updatedNote = updatedNotes[0]
    const newData = updatedNote && updatedNote.version > (version || -1)
    if (forceUpdate || newData) {
      sendNote(updatedNote)
    }
  })
}

/**
 * 
 * @param {Omit<Note, 'createdAt' | 'id'>} note 
 * @returns 
 */
export const addNote = async (note) => {
  const userId = getUserId()

  const timestamp = new Date().getTime()

  try {
    const docRef = await addDoc(collection(db, NOTES_COLLECTION_NAME), {
      userId,
      createdAt: timestamp,
      updatedAt: timestamp,
      ...note,
    })
    return docRef.id
  } catch (err) {
    throw err
  }
}

/**
 * 
 * @param {Note | null} note 
 * @returns 
 */
export const updateNote = async (note) => {
  if (!note) {
    return
  }

  const timestamp = new Date().getTime()

  try {
    console.log('updating note', note.id)
    const docRef = doc(db, NOTES_COLLECTION_NAME, note.id)
    await updateDoc(docRef, {
      ...note,
      updatedAt: timestamp,
    })
  } catch (err) {
    console.error(JSON.stringify(err))
  }
}

/**
 * 
 * @param {string} id 
 * @returns 
 */
export const deleteNote = (id) => deleteDoc(doc(db, NOTES_COLLECTION_NAME, id))

export const deleteData = () => {
  return new Promise((res, rej) => {
    getNotes(notes => {
      Promise.all(notes.map(note => deleteNote(note.id))).then(res).catch(rej)
    }).catch(rej)
  })
  
}
