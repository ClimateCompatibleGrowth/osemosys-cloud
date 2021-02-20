import consumer from './consumer'
console.log('Subscribing')

consumer.subscriptions.create({ channel: 'RunChannel', room: 'ping' }, {
  received(data) {
    alert('hi')
    console.log(data)
  },
})
