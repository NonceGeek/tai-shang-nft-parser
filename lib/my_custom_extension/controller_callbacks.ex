defmodule MyCustomExtension.ControllerCallbacks do
  use Pow.Extension.Phoenix.ControllerCallbacks.Base
  alias TaiShangNftParser.Users.UsersExtra
  def before_respond(Pow.Phoenix.RegistrationController, :create, {:ok, user, conn}, _config) do
    # send email
    %{id: id} = user
    {:ok, _} = UsersExtra.create(%{user_id: id})
    {:ok, user, conn}
  end
end
