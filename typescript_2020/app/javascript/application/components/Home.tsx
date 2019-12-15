import * as React from "react"

import "./Home.scss"

import AppStore from "application/stores/AppStore"
import RoutingStore from "application/stores/RoutingStore"

export interface HomeProps {
  routingStore: RoutingStore
}

export default class Home extends React.Component<HomeProps> {
  render() {
    return <div>Home!</div>
  }
}
