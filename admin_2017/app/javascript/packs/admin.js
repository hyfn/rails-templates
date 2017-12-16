import 'styles/admin.scss'
import $ from 'jquery'
import 'jquery-ujs'

import Turbolinks from 'turbolinks'

import 'bootstrap/js/dropdown'
import 'bootstrap/js/modal'
import 'bootstrap/js/tooltip'
import 'bootstrap/js/popover'
import 'bootstrap/js/alert'
import 'bootstrap/js/transition'
import 'bootstrap/js/carousel'
import 'bootstrap/js/collapse'

// TODO can delete me when unneeded...this is just for demo purposes
import 'images/test/1.jpg'
import 'images/test/2.jpg'

Turbolinks.start()

document.addEventListener('DOMContentLoaded', () => {
  // once ever
})

document.addEventListener('turbolinks:load', () => {
  // every page
})

global.jQuery = $

$(() => {
  // Stuff goes here
})
