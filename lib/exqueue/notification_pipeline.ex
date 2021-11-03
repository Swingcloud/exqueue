defmodule Exqueue.NotificationPipeline do
  @moduledoc false
  use Broadway

  alias Broadway.Message

  @producer BroadwayRabbitMQ.Producer
  @producer_config [
    queue: "notification_queue",
    declare: [durable: true],
    on_failure: :reject_and_requeue
  ]

  def start_link(_args) do
    options = [
      name: NotificationPipeline,
      producer: [module: {@producer, @producer_config}],
      processors: [
        default: []
      ],
      batchers: [
        pos: [concurrency: 2, batch_timeout: 2_000]
      ]
    ]

    Broadway.start_link(__MODULE__, options)
  end

  def handle_message(_processor, message, _context) do
    message
    |> Message.put_batcher(:pos)
    |> Message.put_batch_key(message.data.store)
  end

  def prepare_messages(messages, _context) do
    Enum.map(messages, fn message ->
      Message.update_data(message, fn data ->
        [store, food] = String.split(data, ",")
        %{food: food, store: store}
      end)
    end)
  end

  def handle_batch(_batcher, messages, batch_info, _context) do
    IO.puts("#{inspect(self())} Batch #{batch_info.batcher} #{batch_info.batch_key}")

    # Send to the store

    messages
  end
end
