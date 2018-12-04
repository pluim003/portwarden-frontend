<template>
  <v-app dark>
    <v-content>
      <v-container 
        fluid >
        <v-layout
          row
          wrap
          justify-center>
          <v-flex xs12>
            <div class="display-3">
              Portwarden
            </div>
            <div class="subheading mt-2">
              🔥 Automatic Backup Bitwarden Vault to Your Google Drive 🔥
            </div>
          </v-flex>
          <v-flex 
            xs12 
            md6
            class="my-4">
            <v-text-field
              :value="$store.state.serverUrl"
              label="Enter Your Portwarden URL"
              required
              color="green"
              autofocus
              @input="updateMessage"
            />
          </v-flex>
          <v-flex xs12>
            <div class="mt-5">
              <v-btn 
                class="grey" 
                large
                href="https://github.com/vwxyzjn/portwarden">&nbsp;&nbsp;&nbsp;&nbsp;Github&nbsp;&nbsp;&nbsp;&nbsp;</v-btn>
              <v-btn 
                class="green"
                large
                @click="loginThroughGoogle">Get Started</v-btn>
            </div>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import axios from 'axios'
import Vue from 'vue'
export default Vue.extend({
  data() {
    return {
      loginUrl: ""
    }
  },
  created () {
    axios.defaults.baseURL = this.$store.state.serverUrl
  },
  methods: {
    loginThroughGoogle(){
      let self = this
      axios({
        method: 'get',
        url: '/gdrive/loginUrl',
      })
        .then(function (response) {
          // handle success
          console.log(response)
          self.loginUrl = response.data.login_url
          document.location.href=self.loginUrl
        })
        .catch(function (response) {
          // handle error
          console.log(response)
        })
      console.log(this.loginUrl)
    },
    updateMessage (e) {
      this.$store.commit('updateMessage', e.target.value)
    }
  },
})
</script>

<style>

.container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family: 'Quicksand', 'Source Sans Pro', -apple-system, BlinkMacSystemFont,
    'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.links {
  padding-top: 15px;
}
</style>
