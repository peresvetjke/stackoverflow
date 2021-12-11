import consumer from "./consumer"
var question_template = require("../../assets/templates/partials/question.hbs")

function ready() {
  var questionsList = $("table#questions > tbody")
  if (questionsList.length > 0) {

    consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
      connected() {
        this.perform("follow")
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },
  
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