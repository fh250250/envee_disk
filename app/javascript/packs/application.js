import '../styles/application'

import 'bootstrap'
import $ from 'jquery'
import Rails from '@rails/ujs'
import Vue from 'vue'

Rails.start()

// flash messages 自动消失
setTimeout(() => {
  $('.flash-messages .alert').alert('close')
}, 3000)

// 初始化上传表单
;(function () {
  const ele = $('#upload_form').get(0)

  if (!ele) return

  new Vue({
    propsData: {
      submit_url: $(ele).find('[name=submit_url]').val(),
      back_url: $(ele).find('[name=back_url]').val()
    },
    ...require('../forms/upload_form').default
  }).$mount(ele)
})();
