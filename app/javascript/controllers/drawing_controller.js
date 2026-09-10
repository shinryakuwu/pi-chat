import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "color", "size", "file"]

  connect() {
    this.ctx = this.canvasTarget.getContext("2d")

    this.ctx.lineCap = "round"
    this.ctx.lineJoin = "round"

    this.history = []
    this.tool = "brush"
    this.color = this.colorTarget.value
    this.lineWidth = Number(this.sizeTarget.value)
    this.drawing = false

    this.startX
    this.startY
  }

  select(tool) {
    this.clear()
    tool.classList.add("active")
  }

  clear() {
    this.element
      .querySelectorAll(".tool_button_state")
      .forEach(item => item.classList.remove("active"))
  }

  selectBrush(event) {
    this.select(event.currentTarget)
    this.tool = "brush"
  }

  selectEraser(event) {
    this.select(event.currentTarget)
    this.tool = "eraser"
  }

  selectPicker(event) {
    this.select(event.currentTarget)
    this.tool = "picker"
  }

  selectColor() {
    this.color = this.colorTarget.value
  }

  selectSize() {
    this.lineWidth = Number(this.sizeTarget.value)
  }

  startDrawing(event) {
    this.startX = event.offsetX
    this.startY = event.offsetY

    if (this.tool === "picker") {
      this.pickColor(event)
      return
    }

    this.drawing = true

    this.canvasTarget.setPointerCapture(event.pointerId)

    this.saveState()

    if (this.tool === "brush") {
      this.drawDot()
    }
    if (this.tool === "eraser") {
      this.eraseDot()
    }

    // Start a fresh path for movement
    this.ctx.beginPath()
    this.ctx.moveTo(this.startX, this.startY)
  }

  drawDot() {
    this.ctx.fillStyle = this.color
    this.ctx.beginPath()
    this.ctx.arc(this.startX, this.startY, this.lineWidth / 2, 0, Math.PI * 2)
    this.ctx.fill()
  }

  eraseDot() {
    this.ctx.save()

    this.ctx.globalCompositeOperation = "destination-out"
    this.ctx.beginPath()
    this.ctx.arc(this.startX, this.startY, this.lineWidth / 2, 0, Math.PI * 2)
    this.ctx.fill()

    this.ctx.restore()
  }

  draw(event) {
    if (!this.drawing) return

    let x = event.offsetX
    let y = event.offsetY

    if (this.tool === "brush") {
      this.ctx.strokeStyle = this.color
      this.ctx.lineWidth = this.lineWidth

      this.ctx.lineTo(x, y)
      this.ctx.stroke()
    }

    if (this.tool === "eraser") {
      this.ctx.globalCompositeOperation = "destination-out"
      this.ctx.lineWidth = this.lineWidth

      this.ctx.lineTo(x, y)
      this.ctx.stroke()

      this.ctx.globalCompositeOperation = "source-over"
    }
  }

  stopDrawing() {
    this.drawing = false
  }

  pickColor(event) {
    let x = event.offsetX
    let y = event.offsetY

    let pixel = this.ctx.getImageData(x, y, 1, 1).data
    let opacity = pixel[3]

    if (opacity < 255) {
      this.color = "#ffffff"
    } else {
      let r = pixel[0]
      let g = pixel[1]
      let b = pixel[2]

      this.color = "#" +
        r.toString(16).padStart(2, "0") +
        g.toString(16).padStart(2, "0") +
        b.toString(16).padStart(2, "0")
    }

    this.colorTarget.value = this.color
  }

  saveState() {
    this.history.push(
      this.ctx.getImageData(0, 0, this.canvasTarget.width, this.canvasTarget.height)
    )
    if (this.history.length > 10) { this.history.shift() }
  }

  undo() {
    if (this.history.length === 0) return

    let previous = this.history.pop()
    this.ctx.putImageData(previous, 0, 0)
  }

  clearCanvas() {
    this.saveState()

    this.ctx.clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)
  }

  prepareDrawing(event) {
    // workaround for not submitting the form several times
    if (this.submitting) {
      return
    }

    event.preventDefault()

    // TODO: maybe later check if canvas cntains any non-transparent pixels
    if (this.history.length === 0) { return } // do not submit if no changes were made

    this.submitting = true

    this.canvasTarget.toBlob((blob) => {
      const file = new File([blob], "drawing.png", {
        type: "image/png"
      })

      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)

      this.fileTarget.files = dataTransfer.files

      event.target.requestSubmit()
    }, "image/png")
  }

  submissionFinished(event) {
    if (event.detail.success) {
      this.clearCanvas()
      this.history = []
    }

    this.submitting = false
  }
}
