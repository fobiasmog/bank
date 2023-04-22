import { Controller } from "@hotwired/stimulus"
import 'axios'

export default class extends Controller {

  static targets = ["transactionsList"]

  async connect() {
    axios.get('/api/v1/account/transactions').then((response) => this.showTransactions(response.data))
  }

  showTransactions(list) {
    // console.log(list)
    this.transactionsListTarget.innerHTML = list
  }
}
