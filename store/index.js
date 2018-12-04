import Vuex from 'vuex'

const createStore = () => {
  return new Vuex.Store({
    state: () => ({
      serverUrl: 'http://192.168.0.164:32222'
    }),
    mutations: {
      increment (state) {
        state.counter++
      }
    }
  })
}

export default createStore