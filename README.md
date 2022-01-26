# Questions and Answers

This project was built as part of education program at [Thinknetica](https://thinknetica.com/) (c).

### Goals
Develop an analog of Stackoverflow.

### When
07.11.21 - 30.12.21

### What
- **questions, answers and comments**

    User should have an ability to post a question. 
    Other users should have an ability to post answers for it.
    User can post comment - either questions or answers.
    
- **votes**

    User should have an ability to upvote or downvote questions and answers.

- **marking the best answer**

    User as an author marks the answer he chose as a best one.

- **subscriptions and notifications**

    User should have an ability to get daily email notifications about new questions or about the answers for the questions he subscribed for.
 
- **awardings**

    User as an author of question can assign an awarding for a question which is automaticcally granted to the best answer's author.
    
- **omni auth**

    User should have an ability to login in system via Twitter or Github.

- **search**
    
    User should have an ability to perform a search for questions, answers, comments or user.
    
- **api**

    User should have an ability to get or proceed resources via API.

- **authorization**
    
    User roles and permissions should be divided.

- **and other!**

### How
 - Action Cable is used for getting the changes available for all the users "online".
 - AWS S3 is used as a storage for images direct upload.
 - Cocoon is used for proceeding nested forms
 - Active Job + Sidekiq + Whenever made daily tasks possible
 - Doorkeeper is used for omniauth in part of api
 - Active model serializers + Oj are used for serialization of json's
 - Thinking Sphinx + Kaminari are used for search and pagination
 - Cancancan was chosen as an authorization manager
 - RSpec, Factory bot, Shoulda matchers and Capybara as part of TDD process
 - Deployed with Capistrano

### ER Diagram
![alt text](https://github.com/peresvetjke/stackoverflow/blob/main/stackoverflow%20v1.2.drawio.png?raw=true)
