$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e){
    e.preventDefault()

    const questionId = $(this).data('questionId')
    const $form = $('form#edit-question-' + questionId)

    $form.toggle()
    if($form.is(':visible')){
      $(this).text('Cancel')
    } else{
      $(this).text('Edit')
    }
  })
})


