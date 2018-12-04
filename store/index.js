import Vuex from 'vuex'

const createStore = () => {
  return new Vuex.Store({
    state: () => ({
      serverUrl: 'http://localhost:5000'
    }),
    mutations: {
      updateMessage (state, message) {
        state.serverUrl = message
      }
    }
  })
}

export default createStore