//= require_tree .

const editions_and_translations_title = document.querySelectorAll(".editions_and_translations .title");

editions_and_translations_title.forEach(elem => {
  elem.addEventListener("click", () => {
    elem.classList.toggle("is-active");
  });
});
