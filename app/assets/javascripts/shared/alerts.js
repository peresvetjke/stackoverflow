function ready() {
  console.log('In not_authorized!')
  
  $(document).on('ajax:error', "form[data-remote='true'], a[data-remote='true']", function(e) {
    let error_status_list = [401, 403]
    if (error_status_list.includes(e.detail[2].status)) {
      alert(e.detail[0])  
    }
  })

}

document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)