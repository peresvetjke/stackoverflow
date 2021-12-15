require "rails_helper"

feature 'User can post comment', %q{
  In order to discuss some commentable details
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given(:answer)   { create(:answer, question: question) }

  shared_examples "commentable", js: true do
    feature "being unauthorized" do
      scenario "tries to create comment" do
        visit question_path(question)
        expect(page).to have_no_button("Create Comment")
      end
    end

    feature "being authorized" do
      background {
        sign_in(user)
        visit question_path(question)
      }

      scenario "tries to create comment with blank body" do
        within(".#{commentable.class.to_s.downcase.singularize}") do
          fill_in "comment_body", with: ""
          click_button "Create Comment"
        end
        expect(page).to have_text("Body can't be blank")
      end

      scenario "creates comment" do
        within(".#{commentable.class.to_s.downcase.singularize}") do
          fill_in "comment_body", with: "New comment"
          click_button "Create Comment"
        end
        expect(page).to have_content("New comment")
      end
    end
  end

  feature "commenting question" do
    it_behaves_like 'commentable' do
      given!(:commentable) { question }
    end
  end

  feature "commenting answer" do
    it_behaves_like 'commentable' do
      given!(:commentable) { answer }
    end
  end
end