// TODO: this probably imports all of lodash
import { toPairs, fromPairs } from "lodash"

export type QueryString = Record<string, string | undefined>

export function parse(search: string) {
  const params = search.substr(1)
  const tokens = params.split("&")

  return fromPairs(tokens.map(kv => kv.split("=")))
}

export function stringify(query: QueryString) {
  return toPairs(query)
    .filter(pair => pair.every(x => !!x))
    .map(pair => pair.map(v => encodeURIComponent(v!)).join("="))
    .join("&")
}
