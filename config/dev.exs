import Config

Code.require_file("hooks.exs", __DIR__)

config :git_hooks,
  verbose: true,
  hooks: [
    pre_commit: [
      tasks: [
        {:cmd, "mix format"},
        {:cmd, "mix credo --strict"},
        {:cmd, "mix dialyzer"},
        {:mix_task, :test}
      ]
    ],
    commit_msg: [
      tasks: [
        {Hooks, :check_message, 1}
      ]
    ]
  ]
