defmodule Ca.Sobelow.SonarTest do
  use ExUnit.Case

  import Mock
  alias Mix.Tasks.Ca.Sobelow.Sonar, as: Task

  test "should shows helper information" do
    assert :ok === Task.execute(["-h"])
  end

  test "should execute actions on project" do
    json_sobelow = """
    {"findings":{"high_confidence":[{"line":0,"type":"Config.HTTPS: HTTPS Not Enabled","file":"config/prod.exs"}],"low_confidence":[{"line":9,"type":"RCE.CodeModule: Code Execution in `Code.eval_string`","file":"lib/some_use_case.ex","variable":"public_key"}],"medium_confidence":[{"line":98,"type":"XSS.SendResp: XSS in `send_resp`","file":"lib/rest_controller.ex","variable":"body"}]},"sobelow_version":"0.13.0","total_findings":3}
    """

    with_mocks([{File, [], [exists?: fn _file -> true end, read!: fn _file -> json_sobelow end, write!: fn _file, _content -> :ok end]}]) do
      Task.execute({[input: "sobelow.json", output: "sobelow_sonar.json"], []})
      assert called(File.write!("sobelow_sonar.json", :_))
    end
  end

end
