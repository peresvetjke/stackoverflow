function ready() {
  const input = document.querySelector('.answers')
  
  if (input) {
    window.GistEmbed.init()  
  }
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)
