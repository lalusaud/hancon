import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "image", "counter"]

  open(event) {
    this.currentIndex = Number(event.currentTarget.dataset.lightboxIndex)
    this.dialogTarget.showModal()
    this.showCurrentImage()
  }

  close() {
    this.dialogTarget.close()
  }

  clear() {
    this.imageTarget.removeAttribute("src")
  }

  previous() {
    this.currentIndex = (this.currentIndex - 1 + this.images.length) % this.images.length
    this.showCurrentImage()
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.images.length
    this.showCurrentImage()
  }

  navigateWithArrow(event) {
    if (event.key === "ArrowLeft") {
      event.preventDefault()
      this.previous()
    }
    if (event.key === "ArrowRight") {
      event.preventDefault()
      this.next()
    }
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  get images() {
    return this.element.querySelectorAll("[data-lightbox-src]")
  }

  showCurrentImage() {
    const image = this.images[this.currentIndex]
    this.imageTarget.src = image.dataset.lightboxSrc
    this.imageTarget.alt = image.dataset.lightboxAlt
    this.counterTarget.textContent = `${this.currentIndex + 1} / ${this.images.length}`
  }
}
