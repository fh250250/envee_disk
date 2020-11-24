<template>
<div class="upload-form">
  <div v-if="state === 'IDLE'" class="state-idle">
    <div class="row mb-3">
      <div class="col-6">
        <div class="card">
          <div class="card-header">文件上传</div>
          <div class="card-body">
            <div class="custom-file">
              <input id="bs-file-input" type="file" class="custom-file-input" @change="handle_file_change">
              <label for="bs-file-input" class="custom-file-label text-truncate" data-browse="选择文件">{{ filename }}</label>
            </div>
          </div>
        </div>
      </div>
      <div class="col-6" v-if="can_preview">
        <div class="card">
          <div class="card-header">预览</div>
          <div class="card-body">
            <img v-if="preview_type === 'IMAGE'" :src="preview_url" class="img-fluid">
            <video v-else-if="preview_type === 'VIDEO'" :src="preview_url" controls class="mw-100"></video>
            <audio v-else-if="preview_type === 'AUDIO'" :src="preview_url" controls class="mw-100"></audio>
          </div>
        </div>
      </div>
    </div>
    <div class="d-flex">
      <div class="btn btn-primary mr-3" :class="{ disabled: !filename }" @click="submit">保存</div>
      <a class="btn btn-secondary" :href="cancel_url">取消</a>
    </div>
  </div>

  <div v-else-if="state === 'HASHING'" class="state-hashing card w-50" >
    <div class="card-header">计算文件 SHA256 值</div>
    <div class="card-body">
      <div class="progress">
        <div class="progress-bar progress-bar-striped progress-bar-animated"
            :style="{ width: `${hashing_progress}%`, transition: 'none' }">
          {{ hashing_progress.toFixed(2) }}%
        </div>
      </div>
    </div>
  </div>

  <div v-else-if="state === 'ERROR'" class="state-error card w-50">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h5 class="text-danger mb-0">上传出错</h5>
      <div class="btn btn-primary btn-sm" @click="reupload">重新上传</div>
    </div>
    <div class="card-body">
      <div v-for="(msg, idx) of error_messages" :key="idx">{{ msg }}</div>
    </div>
  </div>
</div>
</template>

<script>
import axios from 'axios'
import { blob_sha256, csrf_token } from '../libs/helper'

const PART_SIZE = 4 * 1024 * 1024

const STATE = {
  IDLE: 'IDLE',
  HASHING: 'HASHING',
  UPLOADING: 'UPLOADING',
  ERROR: 'ERROR'
}

const PREVIEW_TYPE = {
  IMAGE: 'IMAGE',
  VIDEO: 'VIDEO',
  AUDIO: 'AUDIO',
  OTHER: 'OTHER'
}

export default {
  props: {
    submit_url: { type: String, required: true },
    cancel_url: { type: String, required: true }
  },

  data () {
    return {
      state: STATE.IDLE,

      filename: null,
      preview_type: PREVIEW_TYPE.OTHER,
      preview_url: null,

      hashing_progress: 0,

      error_messages: []
    }
  },

  computed: {
    can_preview () {
      return this.preview_type !== PREVIEW_TYPE.OTHER
    }
  },

  methods: {
    handle_file_change (ev) {
      const file = ev.target.files[0]

      if (file) {
        this._file = file
        this.filename = file.name
        this.preview_type = this.parse_preview_type(file.type)
        this.preview_url = URL.createObjectURL(file)
      } else {
        this.reset_file()
      }
    },

    reset_file () {
      this._file = null
      this.filename = null
      this.preview_type = PREVIEW_TYPE.OTHER
      URL.revokeObjectURL(this.preview_url)
      this.preview_url = null
    },

    parse_preview_type (type) {
      if (type.startsWith('image')) {
        return PREVIEW_TYPE.IMAGE
      } else if (type.startsWith('audio')) {
        return PREVIEW_TYPE.AUDIO
      } else if (type.startsWith('video')) {
        return PREVIEW_TYPE.VIDEO
      } else {
        return PREVIEW_TYPE.OTHER
      }
    },

    async submit () {
      if (!this._file) { return }
      if (this.state !== STATE.IDLE) { return }

      let sha256 = null
      try {
        sha256 = await this.hashing_file()
      } catch (e) {
        console.error(e)
        this.change_to_error('计算 SHA256 出错', e.message)
        return
      }

      await this.create_upload(sha256)
    },

    async hashing_file () {
      this.state = STATE.HASHING
      this.hashing_progress = 0

      return await blob_sha256(this._file, progress => {
        this.hashing_progress = progress
      })
    },

    async create_upload (sha256) {
      const req_data = {
        name: this._file.name,
        sha256,
        size: this._file.size,
        part_size: PART_SIZE
      }

      const res = await axios.post(this.submit_url, req_data, {
        headers: { 'X-CSRF-TOKEN': csrf_token() }
      })

      console.log(res.data)
    },

    change_to_error (...messages) {
      this.state = STATE.ERROR
      this.error_messages = messages
    },

    reupload () {
      this.state = STATE.IDLE
      this.error_messages = []
      this.reset_file()
    }
  }
}
</script>
