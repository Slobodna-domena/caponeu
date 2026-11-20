//= require swiper/swiper-bundle.esm.browser.js

const hamburger = document.querySelector(".hamburger")
const sortButton = document.querySelector(".sort div")
const sortMenu = document.querySelector(".sort ul")
const body = document.querySelector("body")
const searchIcon = document.querySelector(".search-icon")
const searchMenu = document.querySelector(".search-menu")
const closeSearchIcon = document.querySelector(".search-menu .close-icon")
const mainSearchForm = document.querySelector(".main-search")
const mainSearchSelect = document.querySelector(".main-search select")

hamburger.addEventListener ("click", openMenu )

function openMenu() {
  const navMenu = document.querySelector("nav.menu")
  navMenu.classList.toggle("is-active")
  hamburger.classList.toggle("is-active")
  body.classList.toggle("no-scroll")
}
if (sortButton) {
  sortButton.addEventListener("click", (e) => {
    e.stopPropagation()
    sortMenu.classList.toggle("is-active")
  })
}

body.addEventListener("click", () => {
  sortMenu.classList.remove("is-active")
})


searchIcon.addEventListener("click", () => {
  searchMenu.classList.add("is-active")
  body.classList.add("no-scroll")
})

closeSearchIcon.addEventListener("click", () => {
  searchMenu.classList.remove("is-active")
  body.classList.remove("no-scroll")
})

mainSearchSelect.addEventListener("change", (e) => {
  if (e.target.value === "/cdp/people") {
    e.target.nextElementSibling.placeholder = "Search by name..."
  } else if (e.target.value === "/cdp/global_search") {
    e.target.nextElementSibling.placeholder = "Search..."
  } else {
    e.target.nextElementSibling.placeholder = "Search by title..."
  }
  mainSearchForm.action = e.target.value
})
