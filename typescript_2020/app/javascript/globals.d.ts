interface Window {
  globals: {
    sentryDsn: string
    sentrySampleRate: number
    sentryDialog?: boolean
    trackingLogLevel: string
    // add your own
  }
}

declare const process: { env: Record<string, string> }
declare const require: any

declare type QueryString = Record<string, string | undefined>

// a class e.g. JS constructor function
declare type Constructor<T, U extends Array<any> = any> = new (...args: U) => T

// https://medium.com/@jrwebdev/react-higher-order-component-patterns-in-typescript-42278f7590fb
declare type Subtract<T, K> = Omit<T, keyof K>

// some convenience wrappers for React event types
// declare type InputEvent = React.FormEvent<HTMLInputElement>
// declare type FormEvent = React.FormEvent<HTMLFormElement>
// declare type LinkEvent = React.MouseEvent<HTMLAnchorElement>
// declare type SelectEvent = React.ChangeEvent<HTMLSelectElement>
// declare type ButtonEvent = React.FormEvent<HTMLButtonElement>

// tell TS that the typedefs for @rails/actioncable are at @types/actioncable
declare module "@rails/actioncable" {
  import * as ActionCable from "actioncable"
  export = ActionCable
}

declare module "*.png" {
  const content: string
  export default content
}

declare module "*.jpg" {
  const content: string
  export default content
}

declare module "*.svg" {
  const content: string
  export default content
}

declare module "*.woff" {
  const content: string
  export default content
}

declare module "*.otf" {
  const content: string
  export default content
}
