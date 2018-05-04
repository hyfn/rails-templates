import * as React from 'react'
import { observer, inject } from 'mobx-react'

import './Home.scss'

import AppStore from 'stores/AppStore'
import RoutingStore from 'stores/RoutingStore'

export interface HomeProps {
  routingStore: RoutingStore
}

@inject(({ routingStore }: AppStore) => ({
  routingStore,
}))
@observer
export default class Home extends React.Component<HomeProps> {
  render() {
    return <div>Home!</div>
  }
}
