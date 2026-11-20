//= require_tree .

//= require active_admin/base
//= require @selectize/selectize

//= require tinymce
//= require tinymce/themes/silver/theme
//= require tinymce/models/dom/model
//= require tinymce/icons/default/icons

//= require tinymce/plugins/image/plugin
//= require tinymce/plugins/link/plugin
//= require tinymce/plugins/code/plugin
//= require tinymce/plugins/lists/plugin
//= require tinymce/plugins/advlist/plugin
//= require tinymce/plugins/wordcount/plugin
//= require tinymce/plugins/media/plugin
//= require tinymce/plugins/visualblocks/plugin
//= require tinymce/plugins/quickbars/plugin
//= require tinymce/plugins/anchor/plugin
//= require tinymce/plugins/table/plugin
//= require tinymce/plugins/help/plugin

tinymce.init({
  selector: '.editor_minimal',
  menubar: false,
  height: 300,
  quickbars_insert_toolbar: false,
  quickbars_image_toolbar: false,
  plugins: 'link code lists advlist help',
  toolbar: 'undo redo | cut copy paste | bold italic | bullist numlist | link | code help'
});

tinymce.init({
  selector: '.editor',
  menubar: false,
  height: 400,
  quickbars_insert_toolbar: false,
  quickbars_image_toolbar: false,
  plugins: 'image link code lists advlist wordcount media help visualblocks quickbars anchor table',
  toolbar: 'undo redo | styles | cut copy paste | bold italic | bullist numlist | link image media table | visualblocks code help',
  formats: {
    title: { block: 'h2' },
    subtitle: { block: 'h3' }
  },
  style_formats: [
    { title: 'Naslov', format: 'title' },
    { title: 'Podnaslov', format: 'subtitle' },
  ],
});

document.addEventListener('DOMContentLoaded', () => {

  $('.selectize').selectize({});

  $('.selectize-with-add-new').selectize({
    create: function (input) {
      return {
        value: input,
        text: input
      }
    },
    sortField: 'text'
  });

  $(".has_many_add").on("click", function(param){
    if (param["originalEvent"]["isTrusted"]) {
      setTimeout(function(){ $('.selectize').selectize({}); }, 100);
      $('.selectize').removeClass('selectize').addClass('selectized`'); // bitno jer se gumb stiska vise puta i onda prethodna polja gube input
    }
    setTimeout(function () {
    tinymce.init({
      selector: '.editor_minimal',
      menubar: false,
      height: 300,
      quickbars_insert_toolbar: false,
      quickbars_image_toolbar: false,
      plugins: 'link code lists advlist help',
      toolbar: 'undo redo | cut copy paste | bold italic | bullist numlist | link | code help'
    });
    }, 100);

  });

  document.querySelectorAll('.copy_to_clipboard').forEach((element) => {
    element.addEventListener('click', (event) => {
      event.preventDefault();
      const copyText = event.target.nextElementSibling;
      copyText.select();
      setTimeout(() => { document.execCommand("copy"); }, 100);
    });
  });


  const editions = document.querySelector('.editions');
  if (editions) {
    const get_editions = (e) => {
      e.preventDefault();
      function addEditionBlock(element, index) {
        const editionsContainer = document.querySelector('.has_many_container');

        if (!editionsContainer) {
          console.error('Editions container not found. Make sure the correct class or selector is used.');
          return;
        }

        const addButton = editionsContainer.querySelector('.button.has_many_add');
        if (!addButton) {
          console.error('Add button not found. Make sure it exists within the editions container.');
          return;
        }

        addButton.click();

        setTimeout(() => {
          const editionBlocks = editionsContainer.querySelectorAll('.has_many_fields');
          const lastEditionBlock = editionBlocks[editionBlocks.length - index];
          if (!lastEditionBlock) {
            console.error('New edition block not found after adding.');
            return;
          }

          const titleInput = lastEditionBlock.querySelector('input[name*="[title]"]');
          const from_yearInput = lastEditionBlock.querySelector('input[name*="[from_year]"]');
          const isbnInput = lastEditionBlock.querySelector('input[name*="[isbn]"]');
          const publisherInput = lastEditionBlock.querySelector('select[name*="[publisher_id]"]');
          if (!titleInput) {
            console.error('Title input field not found in the new edition block.');
            return;
          }

          titleInput.value = element["title"];
          from_yearInput.value = element["year"];
          isbnInput.value = element["isbn"];
          publisherInput.value = element["publisher"][0];
        }, 100);
      }


      const novelTitle = document.querySelector('#novel_title').value;
      const author = document.querySelector('.item').innerHTML;
      newDiv.innerHTML = '<div class="progress-bar"><div class="progress"></div></div >';

      const progressBar = document.querySelector('.progress');
      let width = 0;
      const interval = setInterval(() => {
        if (width < 90) {
          width += 1;
        }
        if (width < 95) {
          width += 0.2;
        }
        if (width > 90) {
          progressBar.innerHTML = "Please wait ...";
        }
        if (width > 94) {
          progressBar.innerHTML = "Almost done ...";
        }
        progressBar.style.width = width + '%';
      }, 100);

      setTimeout(function () { $('.selectize').removeClass('selectize').addClass('selectized`'); }, 100);
      fetch('/api/openlibrary?q=' + novelTitle + '&a=' + author)
        .then(function (response) {
          return response.json();
        })
        .then(function (myJson) {
          myJson.forEach((element, index) => {
            addEditionBlock(element, index + 1);
            clearInterval(interval);
            progressBar.parentNode.style.display = 'none';
          });
          setTimeout(function () {
            $('.selectize').selectize({});

            document.querySelectorAll('[name*="publisher_id"]').forEach(el => {
              myJson.forEach(element => {
                const publisher = element.publisher;
                const currentOptionsValues = Object.values(el.selectize.options).map(item => parseInt(item.value));
                if (!currentOptionsValues.includes(publisher[0])) {
                  const newOption = { value: publisher[0], text: publisher[1] };
                  el.selectize.addOption(newOption);
                  if (!el.value) {
                    el.selectize.setValue(publisher[0]);
                  }
                  el.selectize.refreshOptions(false);
                }
              });
            });

          }, 100);
        })
        .catch(function (error) {
          console.error('Error fetching data:', error);
        });

    }

    const newDiv = document.createElement('div');
    newDiv.setAttribute("id", "api_editions");

    const link = document.createElement('a');
    link.href = '#';
    link.textContent = 'Get editions';
    link.addEventListener('click', get_editions);

    const heading = document.createElement('h3');
    heading.appendChild(link);
    newDiv.appendChild(heading);

    editions.parentElement.parentElement.appendChild(newDiv);
  }



}, false);

