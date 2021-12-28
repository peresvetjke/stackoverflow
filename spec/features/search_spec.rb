require "sphinx_helper"

feature 'User can perform full-text search', %q{
  In order to find questions or other matched records
}, sphinx: true, js: true do

  given!(:question) { create(:question, body: "my_topic in question") }
  given!(:answer)   { create(:answer, body: "my_topic in answer") }
  given!(:comment)  { create(:comment, body: "my_topic in comment", commentable: create(:question)) }
  given!(:user)     { create(:user, email: "my_topic@email.com") }
  
  background {
    visit search_path
    fill_in "Your query:", with: "my_topic"
  }

  feature "search all" do
    background {
      click_button "Search"      
    }

    it "serach though all types of records" do
      save_and_open_page
      expect(page).to have_text(question.title)
      expect(page).to have_text(answer.body)
      expect(page).to have_text(comment.body)
      expect(page).to have_text(user.email)
    end
  end

  feature "questions search" do
    background {
      choose "Question"
      click_button "Search"      
    }

    
    it "results with question" do
      expect(page).to have_text(question.title)
    end

    it "doesn't show with records of other types" do
      expect(page).to have_no_text(answer.body)
      expect(page).to have_no_text(comment.body)
      expect(page).to have_no_text(user.email)
    end
  end

  feature "answers search" do
    background {
      choose "Answer"
      click_button "Search"      
    }

    it "results with answer" do
      expect(page).to have_text(answer.body)
    end

  
    it "doesn't show with records of other types" do
      expect(page).to have_no_text(question.title)
      expect(page).to have_no_text(comment.body)
      expect(page).to have_no_text(user.email)
    end
  end

  feature "comments search" do
    background {
      choose "Comment"
      click_button "Search"      
    }
    
    it "results with comment" do
      expect(page).to have_text(comment.body)
    end

  
    it "doesn't show with records of other types" do
      expect(page).to have_no_text(question.title)
      expect(page).to have_no_text(answer.body)
      expect(page).to have_no_text(user.email)
    end
  end

  feature "users search" do
    background {
      choose "User"
      click_button "Search"      
    }
  
    it "results with user" do
      expect(page).to have_text(user.email)
    end

  
    it "doesn't show with records of other types" do
      expect(page).to have_no_text(question.title)
      expect(page).to have_no_text(answer.body)
      expect(page).to have_no_text(comment.body)
    end
  end
end