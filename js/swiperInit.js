// js/swiperInit.js
document.addEventListener('DOMContentLoaded', () => {
  console.log('Swiper Init');
  new Swiper('.destacadosSwiper', {
    slidesPerView: 4,
    spaceBetween: 20,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    breakpoints: {
      1024: { slidesPerView: 4 },
      768:  { slidesPerView: 2 },
      0:    { slidesPerView: 1 },
    },
  });
});
