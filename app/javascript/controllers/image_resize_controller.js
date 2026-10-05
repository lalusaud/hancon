import { Controller } from "@hotwired/stimulus"

const MAX_IMAGE_DIMENSION = 1200

export default class extends Controller {
  static targets = ["input", "status"]

  async resize() {
    const files = Array.from(this.inputTarget.files || [])
    if (files.length === 0) return

    const submitButtons = Array.from(this.element.closest("form")?.querySelectorAll('[type="submit"]') || [])
    const previousDisabledStates = submitButtons.map(button => button.disabled)
    submitButtons.forEach(button => { button.disabled = true })
    this.inputTarget.disabled = true
    this.statusTarget.textContent = "Preparing photos for upload…"

    try {
      const resizedFiles = await Promise.all(files.map(file => this.resizeFile(file)))
      const transfer = new DataTransfer()
      resizedFiles.forEach(file => transfer.items.add(file))
      this.inputTarget.files = transfer.files
      this.statusTarget.textContent = "Photos are ready to upload (maximum dimension: 1200px)."
    } catch (_error) {
      this.inputTarget.value = ""
      this.statusTarget.textContent = "Could not resize these photos. Please use JPEG, PNG, or WebP images."
    } finally {
      this.inputTarget.disabled = false
      submitButtons.forEach((button, index) => { button.disabled = previousDisabledStates[index] })
    }
  }

  async resizeFile(file) {
    if (!file.type.startsWith("image/")) return file

    const bitmap = await createImageBitmap(file)
    const scale = Math.min(1, MAX_IMAGE_DIMENSION / bitmap.width, MAX_IMAGE_DIMENSION / bitmap.height)
    if (scale === 1) {
      bitmap.close()
      return file
    }

    const canvas = document.createElement("canvas")
    canvas.width = Math.round(bitmap.width * scale)
    canvas.height = Math.round(bitmap.height * scale)
    canvas.getContext("2d").drawImage(bitmap, 0, 0, canvas.width, canvas.height)
    bitmap.close()

    const blob = await new Promise((resolve, reject) => {
      canvas.toBlob(result => result ? resolve(result) : reject(new Error("Image resize failed")), file.type, 0.88)
    })

    return new File([blob], file.name, { type: blob.type || file.type, lastModified: file.lastModified })
  }
}
