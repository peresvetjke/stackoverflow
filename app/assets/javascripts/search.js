function ready () {
	var input = $(".sphinx_search")

	if (input) {

    $(document).on('ajax:before', ".sphinx_search", function(e) {
      clear_results()
    }) .on('ajax:success', ".sphinx_search", function(e) {        
      console.log(e.detail[0])
    })
  }

}

function clear_results() {
  $(".results").empty()
  $(".questions").empty()
  $(".answers").empty()
  $(".comments").empty()
  $(".users").empty()
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)