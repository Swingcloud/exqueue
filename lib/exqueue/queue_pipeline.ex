defmodule Exqueue.QueuePipeline do
  @moduledoc false

  use Broadway

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

  def handle_message(_processor, message, _context) do
    IO.inspect(message, label: "Message")
  end

end
