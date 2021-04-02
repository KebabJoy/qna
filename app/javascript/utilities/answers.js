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

  $('form.new-answer').on('ajax:success', function(e){
    const answer = e.detail[0];

    $('.answers').append('<p>' + answer.body + '</p>');
  })
    .on('ajax:error', function (e){
      const errors = e.detail[0];

      $.each(errors, function (index, value){
        $('.answer-errors').append('<p>' + value + '</p>')
      })
    })
})
