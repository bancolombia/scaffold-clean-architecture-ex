Code.require_file("support/test_stubs.exs", __DIR__)
ExUnit.configure formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitSonarqube]
ExUnit.start(exclude: [:skip])
