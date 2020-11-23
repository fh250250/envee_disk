<template>
<div class="upload-form">
  <div class="card mb-3">
    <div class="card-header">文件上传</div>
    <div class="card-body">
      <div class="row">
        <div class="col-4">
          <div class="custom-file">
            <input id="bs-file-input" type="file" class="custom-file-input" @change="handle_file_change">
            <label for="bs-file-input" class="custom-file-label text-truncate" data-browse="选择文件">{{ file.name }}</label>
          </div>
        </div>
        <div class="col-8 preview">
          preview
        </div>
      </div>
    </div>
  </div>
  <div class="d-flex">
    <div class="btn btn-primary mr-3" :class="{ disabled: !has_file }" @click="submit">保存</div>
    <a class="btn btn-secondary" :href="cancel_url">取消</a>
  </div>
</div>
</template>

<script>
export default {
  props: {
    submit_url: { type: String, required: true },
    cancel_url: { type: String, required: true }
  },

  data () {
    return {
      file: {
        name: null,
        size: 0,
        type: null
      }
    }
  },

  computed: {
    has_file () {
      return !!this.file.name
    }
  },

  methods: {
    handle_file_change (ev) {
      const file = ev.target.files[0]

      if (file) {
        this.file.name = file.name
        console.log(file)
      } else {
        this.file.name = null
      }
    },

    submit () {
      if (!this.has_file) { return }

      console.log('submit')
    }
  }
}
</script>

<style lang="scss" scoped>
.upload-form {}
</style>
