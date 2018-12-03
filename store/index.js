import Vuex from 'vuex'

const createStore = () => {
  return new Vuex.Store({
    state: () => ({
      serverUrl: 'http://localhost:5000'
    }),
    mutations: {
      increment (state) {
        state.counter++
      }
    }
  })
}

export default createStore