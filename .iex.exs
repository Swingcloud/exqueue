send_messages = fn num_messages ->
  {:ok, connection} = AMQP.Connection.open()
  {:ok, channel} = AMQP.Channel.open(connection)

  Enum.each(1..num_messages, fn _ ->
    store = Enum.random(["dough_bros", "pizza_hut", "pizzaria"])
    user_id = Enum.random(1..10)
    AMQP.Basic.publish(channel, "", "food_order_queue", "#{store},pizza,example@example.com,#{user_id}")
  end)
  AMQP.Connection.close(connection)
end
