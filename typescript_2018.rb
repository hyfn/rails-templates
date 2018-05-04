require 'fileutils'
require 'shellwords'
require 'json'

def source_dir
  return File.dirname(__FILE__) unless __FILE__ =~ %r{\Ahttps?://}

  tmpdir = Dir.mktmpdir('rails-template-')
  at_exit { FileUtils.remove_entry(tmpdir) }

  git clone: [
    '--quiet',
    'https://github.com/hyfn/rails-templates.git',
    tmpdir,
  ].map(&:shellescape).join(' ')
  tmpdir
end

source_paths.unshift(File.join(source_dir, 'typescript_2018'))

####################################
# WEBPACKER
####################################

rails_command 'webpacker:install:typescript'

remove_file 'app/assets'

# run 'yarn remove coffee-loader coffee-script'
# remove_file 'config/webpack/loaders/coffee.js'

npm_packages = %(
  @types/react @types/react-dom
  @types/classnames classnames
  mobx mobx-react
  react-router-dom @types/react-router-dom
  axios @types/axios
  json2typescript
  lodash @types/lodash
  raven-js @types/raven-js
).gsub(/\s+/, ' ')

run "yarn add #{npm_packages}"

dev_packages = %(tslint prettier).gsub(/\s+/, ' ')

run "yarn add #{dev_packages} --dev"

require 'pry'

package_json = JSON.parse(File.read('package.json'))

package_json_updates = {
  "scripts": {
    "start": 'bin/webpack-dev-server',
    "lint": 'tslint -p tsconfig.json --type-check -t verbose',
    "lint:fix": 'tslint -p tsconfig.json --type-check --fix -t verbose',
  },
  "engines": {
    "vscode": '^1.0',
    "node": '>=7.6.0',
    "yarn": '^1.0',
  },
  "prettier": {
    "printWidth": 80,
    "semi": false,
    "trailingComma": 'es5',
  },
}

File.write('package.json', JSON.dump(package_json.merge(package_json_updates)))

remove_file 'app/javascript/packs/application.js'
remove_file 'app/javascript/packs/hello_react.jsx'

directory 'app', 'app', recursive: true, verbose: true
copy_file 'tslint.json', 'tslint.json'
copy_file 'tsconfig.json', 'tsconfig.json'
