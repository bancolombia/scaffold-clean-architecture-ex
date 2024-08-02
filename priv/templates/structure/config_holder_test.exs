defmodule ConfigHolderTest do
  use ExUnit.Case
  alias {app}.Config.{AppConfig, ConfigHolder}

  test "Should load config in ETS" do
    # Arrange
    expected_config = %AppConfig{
      env: :test,
      enable_server: true,
      http_port: 8083
      # TODO: Add another config properties here
    }

    # Act
    loaded_config = ConfigHolder.conf()
    # Assert
    assert expected_config == loaded_config
  end

  test "Should save additional config" do
    # Arrange
    other_config = %{send_notifications: true, notifications_method: "email"}

    # Act
    ConfigHolder.set(:notifications, other_config)
    saved_config = ConfigHolder.get!(:notifications)
    # Assert
    assert other_config == saved_config
  end
end
