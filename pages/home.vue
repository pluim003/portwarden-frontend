<template>
  <v-app dark>
    <v-content>
      <v-container 
        fluid >
        <v-layout
          row
          wrap
          justify-center>
          <v-flex 
            xs12 
            md6>
            <v-card>
              <v-card-title class="headline font-weight-regular red white--text">Portwarden</v-card-title>
              <v-card-text>
                <v-subheader class="pa-0">Please Enter Your Bitwarden Credentials</v-subheader>
                <v-text-field
                  v-model="pu.bitwarden_login_credentials.email"
                  label="E-mail"
                  required
                  color="red"
                />
                <v-text-field
                  v-model="pu.bitwarden_login_credentials.password"
                  label="Password"
                  required
                  color="red"
                />
                <v-divider class="mt-4"/>
                <v-subheader class="pa-0">Please Enter Your Backup Preferences</v-subheader>
                <v-text-field
                  v-model="pu.backup_setting.passphrase"
                  label="Passphrase (to encrypt the backups)"
                  required
                  color="red"
                />
              </v-card-text>
            </v-card>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
var pu = {
    email: "",
    bitwarden_login_credentials: {
        email:    "",
        password: "",
        method:   0,
        code:     "",
    },
    backup_setting:              {
      passphrase:               "",
      backup_frequency_seconds: 0,
      will_setup_backup:        false,
  }
}

import axios from 'axios'
import Vue from 'vue'
export default Vue.extend({
  data() {
    return {
      pu: pu,
      access_token: ""
    }
  },
  created () {
    axios.defaults.baseURL = this.$store.state.serverUrl
  },
  mounted() {
    let urlParams = new URLSearchParams(window.location.search);
    this.access_token = urlParams.get('access_token');
    this.pu.email = urlParams.get('email');
    console.log(this.pu)
  },
  methods: {
    loginThroughGoogle(){
      axios({
        method: 'get',
        url: '/gdrive/loginUrl',
      })
        .then(function (response) {
          // handle success
          console.log(response)
        })
        .catch(function (response) {
          // handle error
          console.log(response)
        })
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
