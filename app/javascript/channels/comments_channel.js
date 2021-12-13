import consumer from "./consumer"
var comment_template = require("../../assets/templates/partials/comment.hbs")

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
          
          if (typeof(gon.current_user) == 'undefined' || gon.current_user.id !== comment.author_id ) {
            appendComment(comment)
          }
        }
      })
  }
}

function appendComment(comment) {
  var commentsList = $(`.${comment.commentable_type.toLowerCase()}[item-id='${comment.commentable_id}'] .comments`)
  var comment_form = $(`.${comment.commentable_type.toLowerCase()}[item-id='${comment.commentable_id}'] .comment_form form`)[0]

  if (typeof(gon.current_user) !== 'undefined') {
    var current_user_id = gon.current_user.id
  }

  commentsList.append(comment_template({comment: comment, current_user_id: current_user_id}))
  
  if (typeof(gon.current_user) !== 'undefined' && gon.current_user.id == comment.author.id ) {
    comment_form.reset()
  }
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)