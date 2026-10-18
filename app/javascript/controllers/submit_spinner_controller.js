import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status"]

  show() {
    if (this.busy) return
    this.busy = true
    const button = this.buttonTarget
    this.originalLabel = button.value || button.textContent
    button.classList.add("inline-flex", "items-center", "gap-2", "opacity-80", "cursor-wait")
    button.setAttribute("aria-busy", "true")
    const spinner = document.createElement("span")
    spinner.className = "inline-block h-4 w-4 animate-spin rounded-full border-2 border-[#17483e] border-t-transparent"
    spinner.setAttribute("role", "status")
    this.spinner = spinner
    button.insertAdjacentElement("beforebegin", spinner)
    button.parentElement.classList.add("items-center")
  }

  connect() {
    this.resetUploads()
  }

  resetUploads() {
    this.uploads = new Map()
    this.completed = 0
    this.failed = 0
  }

  uploadsStart() {
    this.show()
  }

  uploadInit({ detail: { id } }) {
    this.uploads.set(id, 0)
    this.renderProgress()
  }

  uploadProgress({ detail: { id, progress } }) {
    this.uploads.set(id, progress)
    this.renderProgress()
  }

  uploadEnd({ detail: { id } }) {
    this.uploads.set(id, 100)
    this.completed++
    this.renderProgress()
  }

  uploadError(event) {
    event.preventDefault()
    this.failed++
    this.statusTarget.textContent = `Upload failed for a photo (${event.detail.error}). Please try again.`
    this.reset()
  }

  renderProgress() {
    if (!this.statusTarget || this.failed) return
    const total = this.uploads.size
    const percent = Math.round([...this.uploads.values()].reduce((sum, value) => sum + value, 0) / total)
    this.statusTarget.textContent = `Uploading photos: ${this.completed}/${total} complete (${percent}%). Please keep this page open.`
  }

  reset() {
    this.resetUploads()
    this.busy = false
    this.spinner?.remove()
    this.buttonTarget.classList.remove("opacity-80", "cursor-wait")
    this.buttonTarget.removeAttribute("aria-busy")
  }
}
