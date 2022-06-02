return {
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      format = {
        enable = true,
        bracketSpacing = false,
        singleQuote = true,
      },
      schemas = {
        kubernetes = "/*.yaml"
      },
      schemaDownload = { enable = true },
      validate = true,
    }
  },
}
