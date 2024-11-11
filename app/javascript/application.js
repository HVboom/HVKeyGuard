import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

// Initialize tooltips
document.addEventListener('DOMContentLoaded', function () {
  const tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
});
