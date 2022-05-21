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
      },
      schemas = {
        kubernetes = "/*.yaml"
      },
      schemaDownload = { enable = true },
      validate = true,
    }
  },
}
