import consumer from './consumer'

const updateCard = (runId, content) => {
  $(`[data-run-card-run-id=${runId}]`).replaceWith(content)
  $(`[data-run-card-run-id=${runId}]`).animate( {'backgroundColor': '#c6dcef'}, 200)
  $(`[data-run-card-run-id=${runId}]`).animate( {'backgroundColor': 'white'}, 200)
}

const subscribeToUpdates= () => {
  console.log('subscribed')
  consumer.subscriptions.create('RunChannel', {
    received(data) {
      updateCard(data['run_id'], data['partial'])
    },
  })
}

window.onload = () => {
  subscribeToUpdates()
}
