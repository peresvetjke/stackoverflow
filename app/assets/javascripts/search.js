var pagination_template = require("../../assets/templates/partials/pagination.hbs")
var answers_template = require("../../assets/templates/partials/search/answers/answers.hbs")
var comments_template = require("../../assets/templates/partials/search/comments/comments.hbs")
var questions_template = require("../../assets/templates/partials/search/questions/questions.hbs")
var users_template = require("../../assets/templates/partials/search/users/users.hbs")

function ready () {
  var input = $(".sphinx_search")

  if (input) {

    // $(".sphinx_search").on('ajax:before', function(e) {
    $(document).on('ajax:before', ".sphinx_search", function(e) {
      clearResults()
    // }) .on('ajax:success', function(e) {     
    }) .on('ajax:success', ".sphinx_search", function(e) {     
      var results = e.detail[0].results
      var meta = e.detail[0].meta

      refreshPagination(meta)
      appendResults(results);
    })
  }

}

function refreshPagination(meta) {
  $(".pages").empty()

  if (meta.total_pages > 1) { 
    var query = $(".sphinx_search #query")[0].value
    var type = getType()
    
    $(".pages").append(pagination_template({meta: meta, type: type, query: query}))
  }
}

function appendResults(results) {
  if (typeof(results.questions) !== 'undefined') { $(".questions").append(questions_template({questions: results.questions})) }
  if (typeof(results.answers) !== 'undefined')   { $(".answers").append(answers_template({answers: results.answers})) }
  if (typeof(results.comments) !== 'undefined')  { $(".comments").append(comments_template({comments: results.comments})) }
  if (typeof(results.users) !== 'undefined')     { $(".users").append(users_template({users: results.users})) }
}
  
function clearResults() {
  $(".questions").empty()
  $(".answers").empty()
  $(".comments").empty()
  $(".users").empty()
}

function getType() {
  var typeRadios = document.querySelectorAll(".sphinx_search input[type='radio']")

  for (var i = 0; i < typeRadios.length; i++) {
    if (typeRadios[i].checked == true) {
      return typeRadios[i].value
    }     
  }
  
}

document.addEventListener('turbolinks:load', ready)
// document.addEventListener('page:load', ready)
// document.addEventListener('page:update', ready)