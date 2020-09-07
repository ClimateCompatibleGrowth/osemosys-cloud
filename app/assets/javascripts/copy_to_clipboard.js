window.addEventListener('DOMContentLoaded', () => {
  clipboardIcons = document.querySelectorAll('[data-copy-to-clipboard]');
  clipboardIcons.forEach(function(clipboardIcon) {
    clipboardIcon.addEventListener('click', (event) => {
      navigator.clipboard.writeText(clipboardIcon.dataset.copyToClipboard)
      event.preventDefault()
    })
  })
});
