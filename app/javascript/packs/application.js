// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require action_cable
//= require_tree .

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
importAll(require.context("../../assets/javascripts/", true, /\.js$/))
require("jquery")
require("@nathanvda/cocoon")
require("gist-embed/dist/gist-embed.min.js")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

function importAll(r) {
  r.keys().forEach(r);
}