function ready() {
  $(document).on('ajax:success', ".vote form", function(e, data) {
      var klass = e.detail[0]["klass"]
      var id = e.detail[0]["id"]
      var rating = e.detail[0]["rating"]

      $(`.${klass}[item-id=${id}] .vote .rating`)[0].textContent = rating
    })
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)