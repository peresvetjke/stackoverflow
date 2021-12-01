document.addEventListener('turbolinks:load', function() {

  $(".vote form").on('ajax:success', function(e) {
    var klass = e.detail[0]["klass"]
    var id = e.detail[0]["id"]
    var rating = e.detail[0]["rating"]

    $(`.${klass}[item-id=${id}] .vote .rating`)[0].textContent = rating
  })
    .on('ajax:error', function(e) {
      var error = e.detail[0]
      window.alert(error)
  })
})