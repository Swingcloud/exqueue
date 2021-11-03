defmodule Exqueue.QueuePipeline do
  @moduledoc false

  use Broadway

  alias Broadway.Message
  alias Exqueue.Store

  @producer BroadwayRabbitMQ.Producer

  @producer_config [
    queue: "food_order_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue
  ]

  def start_link(_args) do
    options = [
      name: QueuePipeline,
      producer: [module: {@producer, @producer_config}],
      processors: [
        default: [
          concurrency: System.schedulers_online() * 2
        ]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  def prepare_messages(messages, _context) do
    messages =
      Enum.map(messages, fn message ->
        Message.update_data(message, fn data ->
          [store, food, email, user_id] = String.split(data, ",")
          %{store: store, food: food, email: email, user_id: user_id}
        end)
      end)

    users = Store.user_by_ids(Enum.map(messages, & &1.data.user_id))

    Enum.map(messages, fn message ->
      Message.update_data(message, fn data ->
        user = Enum.find(users, &(&1.id == data.user_id))
        Map.put(data, :user, user)
      end)
    end)
  end

  def handle_message(_processor, message, _context) do
    %{data: %{store: store, food: food, email: email, user: user}} = message

    # TODO
    # Store.available?(store)

    Store.create_order(store, food)
    Store.send_notification(email, store, food)
    Store.update_member_data(user, store, food)
    IO.inspect(message, label: "Message")
  end
end
