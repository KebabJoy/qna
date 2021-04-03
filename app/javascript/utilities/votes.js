$(document).on('turbolinks:load', function(){
  $('.votes').on('ajax:success','.votes-links a', function(e){
    const votable = e.detail[0];

    const votesDifference = votable.score
    const votesId = votable.votable_id
    const votesType = votable.votable_type
    const htmlId = '#vote' + '-' + votesType + '-' + votesId


    $(htmlId + ' .votes-score').html(votesDifference);
  })
    .on('ajax:error', function(e){
      const votable = e.detail[0];

      const errors = votable.errors
      const votesId = votable.votable_id
      const votesType = votable.votable_type
      const htmlId = '#vote' + '-' + votesType + '-' + votesId

      $.each(errors, function (index, value){
        $(htmlId + ' .votes-errors').append('<p>' + value + '</p>')
      })
    })
})
