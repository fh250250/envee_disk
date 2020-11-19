import '../styles/application'

import 'bootstrap'
import $ from 'jquery'
import Rails from '@rails/ujs'

Rails.start()

setTimeout(() => {
  $('.flash-messages .alert').alert('close')
}, 3000)
