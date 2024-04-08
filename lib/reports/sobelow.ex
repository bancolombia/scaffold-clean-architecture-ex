defmodule ElixirStructureManager.Reports.Sobelow do
  @moduledoc """
  Sobelow report generator
  """

  def translate(
        %{
          "findings" => %{
            "high_confidence" => highs,
            "medium_confidence" => meds,
            "low_confidence" => lows
          },
          "sobelow_version" => vsn
        },
        sonar_base_folder
      ) do
    issues =
      Enum.map(highs, &format(&1, :high, vsn, sonar_base_folder))
      |> Enum.concat(Enum.map(meds, &format(&1, :medium, vsn, sonar_base_folder)))
      |> Enum.concat(Enum.map(lows, &format(&1, :low, vsn, sonar_base_folder)))

    %{issues: issues}
  end

  defp format(
         %{"type" => type, "file" => file, "line" => line} = finding,
         confidence,
         vsn,
         prefix
       ) do
    variable = Map.get(finding, "variable", "")
    [mod_id, _] = String.split(type, ":", parts: 2)
    # Code.ensure_loaded(Sobelow)
    rule = Sobelow.get_mod(mod_id)

    location = %{
      filePath: "#{prefix}#{file}",
      message: "#{type} #{variable} \n Help: #{rule.details()}"
    }

    location = with_text_range(location, line)

    %{
      ruleId: rule.id(),
      severity: confidence_to_severity(confidence),
      type: "VULNERABILITY",
      engineId: "sobelow-#{vsn}",
      primaryLocation: location
    }
  end

  defp with_text_range(%{} = location, line) when line > 0 do
    Map.put(location, :textRange, %{startLine: line})
  end

  defp with_text_range(%{} = location, _line), do: location

  defp confidence_to_severity(:high), do: "CRITICAL"
  defp confidence_to_severity(:medium), do: "MAJOR"
  defp confidence_to_severity(:low), do: "MINOR"
end
