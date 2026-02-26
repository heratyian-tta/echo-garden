import { Controller } from "@hotwired/stimulus"

// Connect this controller to the modal wrapper div:
// <div data-controller="plant-modal">
export default class extends Controller {
  static targets = ["dialog", "plotId", "plantId", "plantInput", "results"]

  connect() {
    // Bind the backdrop click and ESC key if using <dialog>
    this._boundHandleBackdrop = this._handleBackdrop.bind(this)
    this._boundHandleCancel = this._handleCancel.bind(this)

    // Keep track of last focused element for accessibility
    this._lastFocused = null

    // Cache selected plant object
    this.selectedPlant = null
  }

  // ------------------------
  // Open / Close Modal
  // ------------------------
  open(event) {
    event?.preventDefault()
    this._lastFocused = document.activeElement

    const d = this.dialogTarget
    d.addEventListener("cancel", this._boundHandleCancel)
    d.addEventListener("click", this._boundHandleBackdrop)

    d.showModal()

    // Focus input for convenience
    this.plantInputTarget.focus()
  }

  close(event) {
    event?.preventDefault()
    const d = this.dialogTarget
    if (!d.open) return

    d.close()
    d.removeEventListener("cancel", this._boundHandleCancel)
    d.removeEventListener("click", this._boundHandleBackdrop)

    // Reset hidden inputs and selected plant
    this.plotIdTarget.value = ""
    this.plantIdTarget.value = ""
    this.plantInputTarget.value = ""
    this.resultsTarget.innerHTML = ""
    this.selectedPlant = null

    // Restore focus
    this._lastFocused?.focus()
  }

  // Close on backdrop click
  _handleBackdrop(e) {
    const article = this.dialogTarget.querySelector("article")
    if (!article.contains(e.target)) this.close()
  }

  // Close on ESC key
  _handleCancel(e) {
    e.preventDefault()
    this.close()
  }

  // ------------------------
  // Set the plot when user clicks a garden cell
  // ------------------------
  setPlotId(plotId) {
    this.plotIdTarget.value = plotId
  }

  // ------------------------
  // Plant search autocomplete
  // ------------------------
  search(event) {
    const query = event.target.value.trim()
    if (!query) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/plants?query=${encodeURIComponent(query)}`, {
      headers: { Accept: "application/json" }
    })
      .then(res => res.json())
      .then(plants => {
        this.resultsTarget.innerHTML = ""
        plants.forEach(plant => {
          const div = document.createElement("div")
          div.classList.add("autocomplete-item")
          div.textContent = plant.common_name
          div.dataset.plantId = plant.id
          div.addEventListener("click", () => this.selectPlant(plant))
          this.resultsTarget.appendChild(div)
        })
      })
  }

  selectPlant(plant) {
    this.selectedPlant = plant
    this.plantIdTarget.value = plant.id
    this.plantInputTarget.value = plant.common_name
    this.resultsTarget.innerHTML = ""
  }

  // ------------------------
  // Submit the form via AJAX
  // ------------------------
  sowSeed(event) {
    event.preventDefault()

    const plotId = this.plotIdTarget.value
    const plantId = this.plantIdTarget.value

    if (!plotId || !plantId) return alert("Select a plant first!")

    fetch(`/garden_plots/${plotId}/plant`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ plant_id: plantId })
    })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          // Update garden cell color and title dynamically
          const cell = document.querySelector(`[data-plot-id='${plotId}']`)
          if (cell) {
            cell.style.backgroundColor = "green"
            cell.title = data.plant_name
          }
          this.close()
        } else {
          alert(data.error)
        }
      })
  }
}
