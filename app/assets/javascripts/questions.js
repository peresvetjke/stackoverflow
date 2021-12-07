import consumer from "../../javascript/channels/consumer"
var question_template = require("../../assets/templates/partials/question.hbs")

function ready() {
  var questionsList = $("table#questions > tbody")
  if (questionsList.length > 0) {

    consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
      received(data) {
        appendQuestion(questionsList, data);
      }
    })
  }  
}

function appendQuestion(questionsList, data) {
  var question = JSON.parse(data)
  questionsList.append(question_template({question: question}))
}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)