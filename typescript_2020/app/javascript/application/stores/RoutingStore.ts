import {
  History,
  Location,
  LocationState,
  LocationDescriptorObject,
} from 'history'
import { parse, stringify, QueryString } from 'helpers/queryString'

export default class RoutingStore {
  // @observable
  location: Location

  // @computed
  get query() {
    return parse(this.location.search) as QueryString
  }

  constructor(public history: History) {
    this.location = history.location
    history.listen(this.handleLocationChange)
  }

  push = (path: string, state?: LocationState) => this.history.push(path, state)
  replace = (path: string) => this.history.replace(path)
  go = (n: number) => this.history.go(n)
  goBack = () => this.history.goBack()
  goForward = () => this.history.goForward()

  setQuery(q: QueryString, loc: LocationDescriptorObject = {}) {
    this.history.push({ ...loc, search: stringify(q) })
  }

  updateQuery(q: QueryString, loc: LocationDescriptorObject = {}) {
    this.setQuery({ ...this.query, ...q }, loc)
  }

  // @action
  handleLocationChange = (location: Location) => {
    this.location = location
  }
}
