import sha256 from 'fast-sha256'
import { floor as _floor } from 'lodash'
import $ from 'jquery'

/**
 * 计算 Blob 的 sha256
 * @param {Blob} blob
 * @param {function} on_progress 进度回调
 */
export async function blob_sha256 (blob, on_progress) {
  const chunk_size = 4 * 1024 * 1024
  const chunk_count = Math.ceil(blob.size / chunk_size)
  const hasher = new sha256.Hash()

  for (let idx = 0; idx < chunk_count; idx++) {
    const start = idx * chunk_size
    const end = (start + chunk_size) > blob.size ? blob.size : start + chunk_size
    const buffer = new Uint8Array(await read_blob(blob.slice(start, end)))

    if (on_progress) {
      on_progress(chunk_count > 1 ? _floor(idx / (chunk_count - 1) * 100, 2) : 100)
    }

    hasher.update(buffer)
  }

  hasher.digest()

  return Array.prototype.map.call(hasher.digest(), x => ('00' + x.toString(16)).slice(-2)).join('')
}

function read_blob (blob) {
  return new Promise(function (resolve, reject) {
    const file_reader = new FileReader()

    file_reader.onload = function (ev) {
      resolve(ev.target.result)
    }

    file_reader.onerror = function () {
      reject(new Error('读取 Blob 失败'))
    }

    file_reader.readAsArrayBuffer(blob)
  })
}

/**
 * 格式化字节
 * @param {int} bytes 字节数
 */
export function human_readable_bytes (bytes) {
  const SIZE_UNIT = ['B', 'KB', 'MB', 'GB']

  for (let idx = 0; idx < SIZE_UNIT.length; idx++) {
    if (bytes / Math.pow(1024, idx + 1) < 1) {
      return (bytes / Math.pow(1024, idx)).toFixed(2) + ' ' + SIZE_UNIT[idx]
    }
  }
}

/**
 * 获取 CSRF TOKEN
 */
export function csrf_token () {
  return $('meta[name=csrf-token]').attr('content')
}
