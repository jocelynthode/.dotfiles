return {
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      trace = {
        server = "verbose"
      },
      format = {
        enable = true,
        bracketSpacing = false,
      },
      schemas = {
        kubernetes = "/*.yaml"
      },
      schemaDownload = { enable = true },
      validate = true,
    }
  },
}
