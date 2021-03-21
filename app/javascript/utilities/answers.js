document.addEventListener('turbolinks:load', function () {
  document.querySelector('.edit-answer-link').addEventListener('click', (e) => {
    e.preventDefault()

    const answerId = e.target.dataset.answerId
    document.querySelector('form#edit-answer-' + answerId).classList.remove('hidden')
  })
})
