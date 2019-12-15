import * as React from 'react'
import { Provider } from 'mobx-react'
import { Router, Route, Link } from 'react-router-dom'
import createBrowserHistory from 'history/createBrowserHistory'

import './App.scss'

import RoutingStore from 'application/stores/RoutingStore'
import Home from './Home'
import Styleguide from './Styleguide'

const history = createBrowserHistory()
const routingStore = new RoutingStore(history)

const stores = {
  routingStore,
}

const App: React.StatelessComponent<{}> = () => (
  <Provider {...stores}>
    <Router history={history}>
      <div>
        <div className="menu">
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/styleguide">Styleguide</Link>
            </li>
          </ul>
        </div>
        <div>
          <Route path="/" exact component={Home} />
          <Route path="/styleguide" exact component={Styleguide} />
        </div>
      </div>
    </Router>
  </Provider>
)

export default App
