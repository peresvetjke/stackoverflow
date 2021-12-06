import consumer from "../../javascript/channels/consumer"
var answer_template = require("../../assets/templates/partials/answer.hbs")

function ready() {
  var answersList = $("table.answers > tbody")
  if (answersList.length > 0) {

    consumer.subscriptions.create({ channel:"AnswersChannel", question_id: gon.question_id}, {
      received(data) {
        appendAnswer(answersList, data);
      }
    })
  }  
}

function appendAnswer(answersList, data) {
  var answer = JSON.parse(data)
  
  if (typeof(gon.current_user) !== 'undefined') {
    var current_user_id = gon.current_user.id
  }
  
  if (typeof(gon.current_user) == 'undefined' || gon.current_user.id !== answer.author.id ) {
    answersList.append(answer_template({answer: answer, current_user_id: current_user_id}))
  }
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)