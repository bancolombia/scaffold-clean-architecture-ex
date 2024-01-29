defmodule Hooks do
  require Logger

  def check_message(commit_message_file) do
    {:ok, content} = File.read(commit_message_file)

    case Regex.run(
           ~r/^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\([a-z0-9\s_,-]+\))?!?:\s\w/,
           content
         ) do
      nil ->
        Logger.error("""
        \nYour commit message did not follow semantic versioning: #{content}
        Commit message format should be: type(scope): subject")
        Valid types are: feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert
        """)

        :error

      other when is_list(other) ->
        :ok
    end
  end
end
