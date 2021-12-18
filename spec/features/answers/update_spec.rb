require "rails_helper"

feature 'User can edit an answer', %q{
  In order to correct or update it
} do

  given!(:user)         { create(:user) }
  given!(:question)     { create(:question, author: user) }
  given!(:answer)       { create(:answer, question: question, author: user) }

  shared_examples "guest" do
    scenario "tries to edit answer" do
      visit question_path(question)
      expect(find(".answers table", text: answer.body)).to have_no_button("Edit answer")
    end
  end

  shared_examples "author of answer" do
    feature "without attachments" do
      scenario "edits own answer" do
        visit question_path(question)
        within(".answers table", text: answer.body) { click_button("Edit") }
        fill_in "Body", :with => "my corrections"
        page.click_button("Update Answer")
        expect(page).to have_content("my corrections")
        expect(page).to have_no_content(answer.body)
      end
    end

    feature "with attachments" do
      background {
        answer.files.attach(create_file_blob)
        visit question_path(question)
        within(".answers table", text: answer.body) { click_button("Edit") }
      }  

      scenario "adds new attachment" do
        attach_file 'answer_files', ["#{Rails.root}/spec/spec_helper.rb"]
        click_button "Update Answer"
        within(".answers table", text: answer.body) do
          expect(page).to have_link('image.jpeg')
          expect(page).to have_link('spec_helper.rb')
        end
      end

      scenario "removes existing attachment", js: true do
        within(".attachments tr", text: "image.jpeg") do
          accept_alert { find(".delete").click }
        end
        expect(page).to have_no_css(".attachments tr", text: "image.jpeg")
        expect(page).to have_no_link("image.jpeg")
      end
    end

    feature "with links", js: true do
      given!(:answer_with_link) { create(:answer, :with_link, question: question, author: user) }
      
      scenario "removes existing link" do
        visit question_path(question)
        page.first("table.answers > tbody > tr", text: answer_with_link.body).click_button("Edit")
        within("#links") { click_link "remove link" }
        click_button "Update Answer"
        expect(page).to have_no_link("Stackoverflow", href: "https://stackoverflow.com/")
      end
    end
  end

  feature "being guest" do
    it_behaves_like "guest"
  end

  feature "being not an author of answer" do
    background { sign_in(create(:user)) }
    it_behaves_like "guest"
  end

  feature "being author of answer" do
    background { sign_in(user) }
    it_behaves_like "author of answer"
  end

  feature "being admin" do
    background { sign_in(create(:user, admin: true)) }
    it_behaves_like "author of answer"
  end
end