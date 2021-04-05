import $ from 'jquery';

window.addEventListener('turbolinks:load', () => {
  $('#user_tag_list').select2({
    tags: true,
    multiple: true,
    theme: 'bootstrap-5',
  })
});
