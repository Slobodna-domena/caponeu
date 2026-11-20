//= require swiper/swiper-bundle.esm.browser.js

const openAdvancedSearch = document.querySelector(".btn.text.advanced-search")
const advancedSearch = document.querySelector(".advanced-search-container")
const closeAdvancedSearch = document.querySelector(".advanced-search-container .close-icon")

if (openAdvancedSearch) {
  openAdvancedSearch.addEventListener("click", () => {
    advancedSearch.classList.add("is-active")
    body.classList.add("no-scroll")
  })
}

if (closeAdvancedSearch) {
  closeAdvancedSearch.addEventListener("click", () => {
    advancedSearch.classList.remove("is-active")
    body.classList.remove("no-scroll")
  })
}
