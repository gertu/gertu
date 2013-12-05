# Only files that match the pattern will be instrumented
require("blanket")
  pattern: "/"
  "data-cover-never": "node_modules"
  "loader": "./node-loaders/coffee-script"

