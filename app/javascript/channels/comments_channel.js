import consumer from "./consumer"

var comment_template = require("../../assets/templates/partials/comment.hbs")
var errors_template = require("../../assets/templates/partials/errors.hbs")

function ready() {
  var input = $('.comments')

  if (input) {
    consumer.subscriptions.create({ channel:"CommentsChannel", question_id: gon.question_id}, {
        connected() {
          this.perform("follow", { question_id: gon.question_id } )
        },

        received(data) {
          var comment = JSON.parse(data)

          if (typeof(gon.current_user) !== 'undefined') {
            var current_user_id = gon.current_user.id
          }
          
          if (typeof(gon.current_user) == 'undefined' || gon.current_user.id !== comment.author.id ) {
            appendComment(comment)
          }
        }
      })
  }
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)