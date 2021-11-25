require "rails_helper"

feature 'User can edit a question', %q{
  In order to correct or update it
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, author: user) }
  # given(:link) { build(:link) }

  feature "when unauthorized" do
    scenario "tries to edit question" do
      visit question_path(question)
      expect(page).to have_no_button("Edit Question")
    end
  end

  feature "when authorized" do
    feature "being not an author of question" do
      given(:other_user)     { create(:user) }
      background { sign_in(other_user)}

      scenario "tries to edit question" do
        visit question_path(question)
        expect(page).to have_no_button("Edit Question")
      end
    end

    feature "being an author of question" do
      feature "without existing attachments and links" do
        background { 
          sign_in(user)
          visit question_path(question)
          click_button "Edit Question"
        }

        scenario "tries to create question with blank title" do
          fill_in "Title", :with => ""
          fill_in "Body", :with => question.body
          click_button "Update Question"
          expect(page).to have_text("Title can't be blank")
        end

        scenario "edits question" do
          fill_in "Title", :with => question.title
          fill_in "Body", :with => question.body + " corrections"
          click_button "Update Question"
          expect(page).to have_text("Question has been successfully updated")
          expect(page).to have_content(question.body + " corrections")
        end

        scenario "attaches link", js: true do
          within("#links") do  
            click_link "add link"
            fill_in "Title", :with => "Google"
            fill_in "Url", :with => "https://www.google.com/"
          end
          click_button "Update Question"
          expect(page).to have_link("Google", href: "https://www.google.com/")
        end
      end
        
      feature "with attachments" do
        background { 
          sign_in(user)
          question.files.attach(create_file_blob)
          visit question_path(question)
          click_button "Edit Question"
        }  

        scenario "adds new attachment" do
          attach_file 'question_files', ["#{Rails.root}/spec/spec_helper.rb"]
          click_button "Update Question"
          within(".attachments") do
            expect(page).to have_link('image.jpeg')
            expect(page).to have_link('spec_helper.rb')
          end
        end

        scenario "removes existing attachment", js: true do
          within(".attachments tr", text: "image.jpeg") do
            accept_alert { find(".delete").click }
          end
          expect(page).to have_no_css('.attachments tbody')
          expect(page).to have_no_link('image.jpeg')
        end

      end

      feature "with links" do
        given(:question) { create(:question, :with_link, author: user) }
        background { 
          sign_in(user)
          question.files.attach(create_file_blob)
          visit question_path(question)
          click_button "Edit Question"
        }  

        scenario "removes existing link", js: true do
          within("#links") { click_link "remove link" }
          click_button "Update Question"
          expect(page).to have_no_link("Stackoverflow", href: "https://stackoverflow.com/")
        end
      end
    end
  end
end