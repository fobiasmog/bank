import { Controller } from "@hotwired/stimulus"

import "axios"

export default class extends Controller {
  static targets = ['amount', 'sendButton', 'balance', 'clients']
  static selectionPosition = null
  static receiverId = null

  async connect() {}

  // nth-child usecase is dead simple and w/o useless js computations through list
  selectClient({ target, params: { clientId, position }}) {
    if (this.selectionPosition) {
      this.clientsTarget.querySelector(`:nth-child(${this.selectionPosition})`).classList.remove('selected-row')
    }

    this.receiverId = clientId
    this.selectionPosition = position

    this.clientsTarget.querySelector(`:nth-child(${this.selectionPosition})`).classList.add('selected-row')
  }

  async transfer() {
    this.sendButtonTarget.disabled = true

    const transferData = {
      transfer: {
        receiver_id: this.receiverId,
        amount: parseFloat(this.amountTarget.value),
      }
    }

    await axios
            .post('/api/v1/transfer', transferData)
            .then(result => this.handleResult(result))
            .catch((error) => this.handleError(error))
            .finally(() => this.cleanUp())
  }

  handleResult(response) {
    if (response.data.balance) {
      this.balanceTarget.innerHTML = response.data.balance
    }
  }

  handleError(error) {
    alert(error.response.data.errors)
  }

  cleanUp() {
    this.sendButtonTarget.disabled = false
    this.amountTarget.value = null
    this.receiverId = null

    if (this.selectionPosition) {
      this.clientsTarget.querySelector(`:nth-child(${this.selectionPosition})`).classList.remove('selected-row')
      this.selectionPosition = null
    }
  }
}
