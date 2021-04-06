import $ from 'jquery';

window.addEventListener('turbolinks:load', () => {
  $.rails.refreshCSRFTokens();
});
