import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (gon.question_id) {
    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
      connected(){
        console.log('COMMENTS CHANNEL CONNECTED')
      },

      received(data) {
        const template = require('./comment.hbs')
        if (gon.user_id !== data.author_id) {
          $('#commentable-'+data.commentable_id +' .comments').append(template(data))
        }
      }
    })
  }
})
