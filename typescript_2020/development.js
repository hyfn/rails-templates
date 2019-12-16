process.env.NODE_ENV = process.env.NODE_ENV || 'development'

// ruby-style .env
const dotenv = require("dotenv")
const dotenvFiles = [
  `.env.${process.env.NODE_ENV}.local`,
  ".env.local",
  `.env.${process.env.NODE_ENV}`,
  ".env",
]
dotenvFiles.forEach(path => {
  dotenv.config({ path, silent: true })
})

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
