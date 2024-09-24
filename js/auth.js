import { loginBe } from './backend.js'

const USER_ID = 'userId'

/**
 * 
 * @param {string} userId 
 */
const setUserId = (userId) => {
  window.localStorage.setItem(USER_ID, userId)
}

export const getUserId = () => {
  return window.localStorage.getItem(USER_ID)
}

/**
 * 
 * @param {string} email 
 * @param {string} password 
 * @returns  {Promise<string>}
 */
export const authenticate = (email, password) => {
  return loginBe({ email, password }).then(res => {
    setUserId(res.id)
    return res.id
  })
}

export const protectedPage = () => {
  if (!getUserId()) {
    window.location.href = window.location.origin
  }
}
