import * as Sentry from "@sentry/browser"
import { GlobalHandlers, Breadcrumbs } from "@sentry/browser/dist/integrations"
import { ExtraErrorData, Debug } from "@sentry/integrations"
import { Integration } from "@sentry/types"

interface Props {
  debug?: boolean
  tags?: Record<string, string>
  user?: Sentry.User
}

const prettifyCategories = ["body", "headers", "state", "value"]

export default function initSentry({ debug, tags, user }: Props) {
  Sentry.init({
    dsn: window.globals.sentryDsn,
    environment: process.env.ENV,
    sampleRate: window.globals.sentrySampleRate,
    debug: debug,
    release: process.env.HEROKU_SLUG_COMMIT,
    maxBreadcrumbs: 50,
    beforeSend: (e, hint) => {
      const message =
        hint &&
        hint.originalException &&
        (typeof hint.originalException === "string"
          ? hint.originalException
          : hint.originalException.message)
      if (message === "cancelled") {
        return null
      }
      return e
    },
    beforeBreadcrumb: bc => {
      if (
        bc.category === "console" &&
        (bc.level === "debug" || bc.level === "info" || bc.level === "log")
      ) {
        // only capture console.error/warn/assert
        return null
      }
      if (
        bc.category === "API Response" ||
        bc.category === "API Error" ||
        bc.category === "API Request"
        // || bc.category === "savedState"
      ) {
        prettifyCategories.forEach(k => {
          if (bc.data[k] && typeof bc.data[k] === "object") {
            let data = JSON.stringify(bc.data[k], null, 1).replace(/["\\]/g, "")
            if (data.length >= 1024) data = data.slice(0, 512) + "..."
            bc.data[k] = data
          }
        })
      }
      if (
        bc.category === "xhr" &&
        bc.data.url === "https://api.amplitude.com"
      ) {
        return null
      }

      return bc
    },
    integrations: plugins => {
      const newPlugins: typeof plugins = []
      plugins.forEach(plugin => {
        const newPlugin = handlePlugin(plugin)
        if (Array.isArray(newPlugin)) {
          newPlugin.forEach(p => newPlugins.push(p))
        } else if (newPlugin) {
          newPlugins.push(newPlugin)
        }
      })
      newPlugins.push(new ExtraErrorData())
      if (debug) {
        newPlugins.push(new Debug())
      }
      return newPlugins
    },
  })

  try {
    Sentry.configureScope(s => {
      if (tags) s.setTags(tags)
      if (user) s.setUser(user)
    })
  } catch (ex) {
    Sentry.captureException(ex)
    console.error("Couldn't set Sentry context", ex)
  }
}

function handlePlugin(plugin: Integration) {
  switch (plugin.name) {
    case "GlobalHandlers":
      return new GlobalHandlers({
        onunhandledrejection: false,
        onerror: true,
      })
    case "Breadcrumbs":
      // skip console calls locally, as it screws up console.x backtraces
      return new Breadcrumbs({
        console: process.env.NODE_ENV === "production",
        xhr: false,
      })

    default:
      return plugin
  }
}
