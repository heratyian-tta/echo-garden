import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hidden"]

  search() {
    const query = this.inputTarget.value

    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/plants/search?q=${query}`, {
      headers: { "Accept": "text/vnd.turbo-stream.html, text/html" }
    })
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
      })
  }

  select(event) {
    const plantId = event.currentTarget.dataset.plantId
    const plantName = event.currentTarget.dataset.plantName

    this.inputTarget.value = plantName
    this.hiddenTarget.value = plantId
    this.resultsTarget.innerHTML = ""
  }
}
