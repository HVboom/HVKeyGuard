import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["scrollContainer"];
  static values = { elementsClasses: Array };

  connect() {
    this.adjustScrollHeight();

    window.addEventListener("resize", this.adjustScrollHeight.bind(this));

    const observer = new MutationObserver(() => {
      this.adjustScrollHeight();
    });

    const selectors = this.elementsClassesValue.join(",");
    const elements = document.querySelectorAll(selectors);
    elements.forEach((element) => {
      observer.observe(element, {
        attributes: true,
        childList: true,
        subtree: true,
      });
    });
  }

  disconnect() {
    window.removeEventListener("resize", this.adjustScrollHeight.bind(this));
  }

  adjustScrollHeight() {
    const windowHeight = window.innerHeight;
    let breakpoint = window
      .getComputedStyle(document.documentElement)
      .getPropertyValue("--bs-breakpoint-md");
    let doScrollContainer = window.matchMedia(
      "(min-width: " + breakpoint + ")"
    ).matches;

    let elementsHeight = 50;

    const selectors = this.elementsClassesValue.join(",");
    const elements = document.querySelectorAll(selectors);

    elements.forEach((element) => {
      elementsHeight += element.offsetHeight;
    });

    const newHeight = windowHeight - elementsHeight;

    if (doScrollContainer && newHeight > 500) {
      if (this.scrollContainerTarget) {
        this.scrollContainerTarget.style.maxHeight = newHeight + "px";
        this.scrollContainerTarget.classList.add("scroll-container");
        this.scrollContainerTarget.classList.remove("no-scroll-container");
      }
    } else {
      if (this.scrollContainerTarget) {
        this.scrollContainerTarget.removeAttribute("style");
        this.scrollContainerTarget.classList.remove("scroll-container");
        this.scrollContainerTarget.classList.add("no-scroll-container");
      }
    }
  }
}
