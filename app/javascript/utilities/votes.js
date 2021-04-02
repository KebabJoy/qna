$(document).on('turbolinks:load', function(){
  $('.votes').on('ajax:success','.votes-links a', function(e){
    const votesDifference = e.detail[0];

    const votesId = e.currentTarget.dataset.id
    const votesType = e.currentTarget.dataset.votableType
    const htmlId = '#vote' + '-' + votesType + '-' + votesId


    $(htmlId + ' .votes-score').html(votesDifference);
  })
    .on('ajax:error', function(e){
      let errors = e.detail[0]
      const votesId = e.currentTarget.dataset.id

      $.each(errors, function (index, value){
        $('.votes[data-id="' + votesId + '"] .votes-score .votes-errors').append('<p>' + value + '</p>')
      })
    })
})
