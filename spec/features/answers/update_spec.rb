require "rails_helper"

feature 'User can edit an answer', %q{
  In order to correct or update it
} do

  given(:user)         { create(:user) }
  given(:question)     { create(:question, author: user) }
  given(:answer)       { create(:answer, question: question, author: user) }
  given(:other_user)   { create(:user) }
  given(:other_answer) { create(:answer, question: question, author: other_user) }

  background {
    answer
    other_answer
  }

  feature "when unauthorized" do
    scenario "tries to edit answer" do
      visit question_path(question)
      expect(find(:xpath, "//*[contains(text(), '#{answer.body}')]/parent::tr")).to have_no_button("Edit answer")
    end
  end

  feature "being authorized" do
    feature "without attachments" do
      background { sign_in(user) }
      
      scenario "tries to edit other's answer" do
        other_answer
        visit question_path(question)
        expect(find(".answers table", text: other_answer.body)).to have_no_button("Edit answer")
      end

      scenario "edits own answer" do
        visit question_path(question)
        within(".answers table", text: answer.body) { click_button("Edit answer") }
        fill_in "Body", :with => "my corrections"
        page.click_button("Update Answer")
        expect(page).to have_content("my corrections")
        expect(page).to have_no_content(answer.body)
      end
    end

    feature "with attachments" do
      background { 
        sign_in(user)
        answer.files.attach(create_file_blob)
        visit question_path(question)
        within(".answers table", text: answer.body) { click_button("Edit answer") }
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
  end
end