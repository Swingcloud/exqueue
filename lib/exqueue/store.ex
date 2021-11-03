defmodule Exqueue.Store do
  @moduledoc false

  def available?(_store) do
    # mimic processing time
    Process.sleep(Enum.random(100..200))
    true
  end

  def create_order(_store, _food) do
    Process.sleep(Enum.random(250..1000))
  end

  def send_notification(_email, _store, _food) do
    Process.sleep(Enum.random(100..200))
  end

  def update_member_data(nil = _user, _store, _food), do: nil

  def update_member_data(_user, _store, _food) do
    Process.sleep(Enum.random(100..200))
  end

  @users [
    %{id: "1", email: "foo@example.com"},
    %{id: "2", email: "bar@example.com"},
    %{id: "42", email: "answer_of_life@exampel.com"}
  ]

  def user_by_ids(ids) when is_list(ids) do
    Enum.filter(@users, &(&1.id in ids))
  end
end
