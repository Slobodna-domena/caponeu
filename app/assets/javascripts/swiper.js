//= require swiper/swiper-bundle.min.js

const swiper = new Swiper('.swiper', {
  direction: 'horizontal',
  loop: false,
  slidesPerView: 1,
  autoplay: {
   delay: 5000,
   },
  effect: 'fade',
  fadeEffect: {
    crossFade: true,
  },
  autoHeight: true,
  pagination: {
    el: '.swiper-pagination',
    clickable: true,
  },
  numberSlides: true,
  on: {
    slideChange: function () {
      var currentSlideIndex = swiper.activeIndex + 1;
      var totalSlides = swiper.slides.length;
      document.getElementById('numberSlides').textContent = currentSlideIndex + '/' + totalSlides;
    },
  },
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
});
