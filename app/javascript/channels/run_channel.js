import consumer from './consumer'

const updateCard = (runId, content) => {
  $(`[data-run-card-run-id=${runId}]`).replaceWith(content)
  $(`[data-run-card-run-id=${runId}]`).animate( {'backgroundColor': '#c6dcef'}, 200)
  $(`[data-run-card-run-id=${runId}]`).animate( {'backgroundColor': 'white'}, 200)
}

const subscribeToUpdates= (runId) => {
  consumer.subscriptions.create({channel: 'RunChannel', run_id: runId}, {
    received(data) {
      updateCard(runId, data['partial'])
    },
  })
}
window.onload = () => {
  document.querySelectorAll('[data-run-card-run-id]').forEach((runCard) => {
    subscribeToUpdates(runCard.dataset.runCardRunId)
  })
}
