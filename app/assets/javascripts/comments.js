import consumer from "../../javascript/channels/consumer"
var comment_template = require("../../assets/templates/partials/comment.hbs")
var errors_template = require("../../assets/templates/partials/errors.hbs")

function ready() {
  var input = $('.comments')

  if (input) {
    $(document).on('ajax:before', ".comment_form", function(e) {  
        resetErrors()
      }) .on('ajax:success', ".comment_form", function(e) {  
        var comment = e.detail[0]
        appendComment(comment)
      }) .on('ajax:error', ".comment_form", function(e) {
        var form = $(e.target)
        var messages = e.detail[0]      
        appendErrors(form, messages)
      })

    $(document).on('ajax:success', ".delete_comment", function(e) {  
        $(e.target).closest('.comment').remove()
        alert(e.detail[0].message)
      })

    $(document).on('click', ".form_inline_link", formIlineLinkHandler)

    $(document).on('ajax:before', ".form_inline", function(e) {  
        resetErrors()
      }) .on('ajax:success', ".form_inline", function(e) {  
        var comment = e.detail[0]
        updateComment(comment)
      }) .on('ajax:error', ".form_inline", function(e,data) {
        var form = $(e.target)
        var messages = e.detail[0]      
        appendErrors(form, messages)
      })

  }
}

function formIlineLinkHandler(event) {
  event.preventDefault()
  var commentId = $(event.target).closest('.comment').attr('item-id')
  formInlineHandler(commentId)
}

function formInlineHandler(commentId) {
  var link = $(`.comment[item-id=${commentId}] .form_inline_link`)[0]
  var $commentBody = $(`.comment[item-id=${commentId}] .comment_body`)
  var $commentAuthor = $(`.comment[item-id=${commentId}] .comment_author`)
  var $formInline = $(`.comment[item-id=${commentId}] .form_inline`)

  $commentBody.toggle()
  $commentAuthor.toggle()
  $formInline.toggle()
  resetErrors()

  if ($formInline.is(":visible")) {
    link.textContent = 'Cancel'
  } else {
    link.textContent = 'Edit'
  }
}

function updateComment(comment) {
  var $commentBody = $(`.comment[item-id=${comment.id}] .comment_body`)
  $commentBody[0].textContent = comment.body

  formInlineHandler(comment.id)
}

function appendComment(comment) {
  var commentsList = $(`.${comment.commentable_type.toLowerCase()}[item-id='${comment.commentable_id}'] .comments`)
  var comment_form = $(`.${comment.commentable_type.toLowerCase()}[item-id='${comment.commentable_id}'] .comment_form form`)[0]

  if (typeof(gon.current_user) !== 'undefined') {
    var current_user_id = gon.current_user.id
  }

  commentsList.append(comment_template({comment: comment, current_user_id: current_user_id}))
  
  if (typeof(gon.current_user) !== 'undefined' && gon.current_user.id == comment.author_id ) {
    comment_form.reset()
  }
}

function appendErrors(form, messages) {
  form.before(errors_template({messages: messages}))
}

function resetErrors() {
  $('.errors').remove()
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)