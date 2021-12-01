import { DirectUpload } from "@rails/activestorage"


document.addEventListener('turbolinks:load', function() {

  // https://edgeguides.rubyonrails.org/active_storage_overview.html
  const input = document.querySelector('input[type=file]')

  if (input) { 
    // Bind to normal file selection
    input.addEventListener('change', (event) => {
      Array.from(input.files).forEach(file => uploadFile(file))
      // you might clear the selected files from the input
      input.value = null
    })

    const uploadFile = (file) => {
      // your form needs the file_field direct_upload: true, which
      //  provides data-direct-upload-url, data-direct-upload-token
      // and data-direct-upload-attachment-name
      const url = input.dataset.directUploadUrl
      const token = input.dataset.directUploadToken
      const attachmentName = input.dataset.directUploadAttachmentName
      const upload = new DirectUpload(file, url, token, attachmentName)

      upload.create((error, blob) => {
        if (error) {
          // Handle the error
        } else {
          // Add an appropriately-named hidden input to the form with a
          //  value of blob.signed_id so that the blob ids will be
          //  transmitted in the normal upload flow
          const hiddenField = document.createElement('input')
          hiddenField.setAttribute("type", "hidden");
          hiddenField.setAttribute("value", blob.signed_id);
          hiddenField.name = input.name
          document.querySelector('#direct_upload_form').appendChild(hiddenField)
        }
      })
    }
  }
})