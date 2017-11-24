import 'styles/admin.scss'
import $ from 'jquery'
// TODO why this require and import mixing and matching
global.jQuery = $
require('jquery-ujs')
import Turbolinks from 'turbolinks'

require('bootstrap/js/dropdown')
require('bootstrap/js/modal')
require('bootstrap/js/tooltip')
require('bootstrap/js/popover')
require('bootstrap/js/alert')
require('bootstrap/js/transition')
require('bootstrap/js/carousel')

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
