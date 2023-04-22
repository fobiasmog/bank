import { Controller } from "@hotwired/stimulus"
import 'axios'

export default class extends Controller {
  static targets = ["transactionsList", "loadButton"]

  reachedBottom = false
  page = 0

  async connect() {
    this.loadTransactions()
  }

  showTransactions(list) {
    this.transactionsListTarget.innerHTML += list
  }

  async loadTransactions() {
    if (this.reachedBottom) return

    this.lockButtonState()

    const response = await axios.get('/api/v1/account/transactions', { params: { page: this.page } })

    if (response.data.length == 0) {
      this.reachedBottom = true
      return
    }

    this.showTransactions(response.data)
    this.page += 1

    this.releaseButtonState()
  }

  lockButtonState() {
    this.loadButtonTarget.disabled = "disabled"
  }
  releaseButtonState() {
    this.loadButtonTarget.disabled = null
  }
}
