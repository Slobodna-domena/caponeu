const form = document.getElementById("search_form");

const searchContainer = document.getElementById('search-container');
if (form) {
  form.addEventListener("submit", onFormSubmit);
}

function onFormSubmit(event) {

  event.preventDefault();

  searchContainer.innerHTML = "<h3>Rezultati pretrage:</h3>";



  let formData = new FormData(form);

  var formObject = {};

  formData.forEach(function (value, key) {

    formObject[key] = value;

  });

  fetch("/cdp/people", {

      method: 'POST',

      headers: {

        "X-Requested-With": "XMLHttpRequest",

      },

      body: formData

    })

    .then(function (response) {

      if (!response.ok) {

        throw new Error('Network response was not ok');

      }

      return response.text();

    })

    .then(function (htmlContent) {

      searchContainer.innerHTML = htmlContent;
      console.log(htmlContent);

    })

    .catch(function (error) {

      console.error('Error:', error);

    });

    return false;

}

const searchArea = document.getElementById('search-area');

function showOrHideSearchArea() {
  var display = searchArea.style.display;

  if (display == "block") {
    searchArea.style.display = "none";
  }
  else {
    searchArea.style.display = "block";
  }

};
