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
              <v-card-text v-if="!pu.backup_setting.will_setup_backup">
                <v-text-field
                  :value="$store.state.serverUrl"
                  label="Enter Your Portwarden URL"
                  required
                  color="green"
                  autofocus
                  @input="updateMessage"
                />
                <v-subheader class="pa-0">Welcome user {{ pu.email }}. Please Enter Your Bitwarden Credentials</v-subheader>
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
                <v-select
                  :items="twofa_options"
                  v-model="pu.bitwarden_login_credentials.method"
                  item-text="method"
                  item-value="code"
                  label="2FA Options"
                />
                <v-text-field
                  v-model="pu.bitwarden_login_credentials.code"
                  label="2FA Code"
                  required
                  color="red"
                />
                <v-btn  
                  color="red"
                  block
                  @click="setupAutomaticBackup()">Setup Automatic Backup</v-btn>
              </v-card-text>
              <v-card-text v-else>
                <v-subheader class="pa-0 mb-4">
                  Greetings User {{ pu.email }}. You have already registered with our system. 
                  You may cancel the automatic backup by clicking the button below.
                </v-subheader>
                <v-btn  
                  color="red"
                  block
                  @click="cancelAutomaticBackup()">Cancel My Automatic Backup</v-btn>
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
        method:   "100",
        code:     "",
    },
    backup_setting:              {
      passphrase:               "",
      backup_frequency_seconds: 60,
      will_setup_backup:        false,
  }
}

import axios from 'axios'
import Vue from 'vue'
export default Vue.extend({
  data() {
    return {
      pu: pu,
      access_token: "",
      twofa_options: [
        {
          method: 'None',
          code: '100'
        },
        {
          method: 'Authenticator',
          code: '0'
        },
        {
          method: 'Email',
          code: '1'
        },
        {
          method: 'Yubikey',
          code: '3'
        }
      ],
      twofa_code: ""
    }
  },
  created () {
    axios.defaults.baseURL = this.$store.state.serverUrl
  },
  mounted() {
    let urlParams = new URLSearchParams(window.location.search);
    this.access_token = urlParams.get('access_token');
    this.pu.email = urlParams.get('email');
    this.pu.backup_setting.will_setup_backup = (urlParams.get('will_setup_backup') == 'true')
    console.log(this.access_token)
    console.log(this.pu)
  },
  methods: {
    setupAutomaticBackup(){
      let self = this
      self.pu.bitwarden_login_credentials.method = parseInt(self.pu.bitwarden_login_credentials.method)
      let pu_copy = JSON.parse(JSON.stringify(self.pu))
      pu_copy.backup_setting.will_setup_backup = true
      
      let authString = 'Bearer '.concat(self.access_token)
      var xhr = new XMLHttpRequest();
      xhr.open("POST", self.$store.state.serverUrl+'/encrypt', true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('Authorization', authString);
      xhr.send(JSON.stringify(pu_copy));
      console.log(xhr)
      xhr.onreadystatechange = function () {
        if(xhr.readyState === 4) {
          if (xhr.status === 200) {
            alert("successfully setup backup");
            self.pu.backup_setting.will_setup_backup = true
          } else {
            alert("something went wrong")
          }
        }
      };
    },
    cancelAutomaticBackup(){
      let self = this
      let pu_copy = JSON.parse(JSON.stringify(self.pu))
      pu_copy.backup_setting.will_setup_backup = false
      pu_copy.bitwarden_login_credentials.method = parseInt(pu_copy.bitwarden_login_credentials.method)
      
      let authString = 'Bearer '.concat(self.access_token)
      var xhr = new XMLHttpRequest();
      xhr.open("POST", self.$store.state.serverUrl+'/encrypt/cancel', true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('Authorization', authString);
      xhr.send(JSON.stringify(pu_copy));
      console.log(xhr)
      xhr.onreadystatechange = function () {
        if(xhr.readyState === 4 && xhr.status === 200) {
          alert(xhr.responseText);
          document.location.href="/";
        }
      };
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
