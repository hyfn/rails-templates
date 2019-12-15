import React from 'react'
import { render } from 'react-dom'
import App from 'application/components/App'
import initSentry from "services/initSentry"

initSentry({
  // debug: debugUI,
  tags: {
    // add some
  },
})

render(React.createElement(App), document.getElementById("root"))
