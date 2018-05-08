import React from 'react'
import { render } from 'react-dom'
import Raven from 'raven-js'
import App from 'application/components/App'

Raven.config(process.env.SENTRY_DSN_JS, {
  environment: process.env.RAILS_ENV,
  sampleRate: process.env.RAILS_ENV === 'production' ? 0.1 : 1,
  debug: process.env.RAILS_ENV !== 'production',
}).install()

Raven.context(() => {
  render(React.createElement(App), document.getElementById('root'))
})
