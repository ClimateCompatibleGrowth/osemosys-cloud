window.addEventListener('turbolinks:load', () => {
  clipboardIcons = document.querySelectorAll('[data-copy-to-clipboard]');
  clipboardIcons.forEach(function(clipboardIcon) {
    clipboardIcon.addEventListener('click', event => {
      navigator.clipboard.writeText(clipboardIcon.dataset.copyToClipboard)
      $(clipboardIcon).tooltip('show')
      setTimeout(() => { $(clipboardIcon).tooltip('hide') }, 1000)
      event.preventDefault()
    })
  })
});
