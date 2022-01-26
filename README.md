# Questions and Answers

This project was built as part of education program at [Thinknetica](https://thinknetica.com/) (c).

### Goals
Develop an analog of Stackoverflow.

### User roles
- user
- admin

### Key features
- **questions and answers**

    User posts a question. Other users should have an ability to post answers for it.
    - AWS S3 is used as a storage for images direct upload.
    - Action Cable is used for getting the changes available for all the users. 
    - Cocoon is used for nested forms
    
- **comments**

    User can post comment - either questions or answers.
    
- **votes**

    User should have an ability to upvote or downvote questions and answers.

- **marking the best answer**

    User as an author marks the answer he chose as a best one.

- **subscriptions and notifications**

    User should have an ability to get daily email notifications about new questions or about the answers for the questions he subscribed for.
    - Sidekiq + Active Job + Whenever
 
- **omni auth**

    User should have an ability to login in system via Twitter or Github.

- **search**
    
    User should have an ability to perform a search for questions, answers, comments or user.
    - Thinking Sphinx
    - Kaminari
    
- **api**

    User should have an ability to get or proceed resources via API.
    - Doorkeeper
    - Active model serializers + Oj

- **authorization**
    
    User roles and permissions should be divided.
    - Cancancan

- **and other!**

### ER Diagram
