// controllers/url_opener_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "link"]

  connect() {
    this.updateLink(); // Initialize the link when the controller connects
  }

  updateLink() {
    const url = this.inputTarget.value;
    if (this.isValidUrl(url)) {
      this.linkTarget.href = url;
      this.linkTarget.classList.remove("d-none"); // Show the icon
    } else {
      this.linkTarget.href = "#";
      this.linkTarget.classList.add("d-none"); // Hide the icon if URL is invalid
    }
  }

  isValidUrl(url) {
    // Check if the URL starts with http:// or https://
    return /^https?:\/\//.test(url);
  }

  inputTargetConnected() {
    this.inputTarget.addEventListener("input", this.updateLink.bind(this));
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.updateLink.bind(this));
  }
}
