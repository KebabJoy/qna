$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault()

    const answerId = $(this).data('answerId')
    const $form = $('form#edit-answer-' + answerId)

    $form.toggle()
    if($form.is(':visible')){
      $(this).text('Cancel')
    } else{
      $(this).text('Edit')
    }
  })
})
