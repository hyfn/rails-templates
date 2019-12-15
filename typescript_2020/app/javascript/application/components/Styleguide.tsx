import * as React from 'react'

import './Styleguide.scss'

import AppStore from 'application/stores/AppStore'
import RoutingStore from 'application/stores/RoutingStore'

export interface StyleguideProps {
  routingStore: RoutingStore
}

export default class Styleguide extends React.Component<StyleguideProps> {
  render() {
    return <div>Styleguide!</div>
  }
}
