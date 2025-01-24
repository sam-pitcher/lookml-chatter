view: routing_prompt {
  derived_table: {
    sql:
      SELECT ml_generate_text_llm_result AS generated_content
      FROM ML.GENERATE_TEXT(
      MODEL `chatter.chatter_llm`,
      (
      SELECT """
      You are a chat and question classification assistant. You classify the input message from the user based on the given choices.

      You should only return the string "CHAT" or "QUESTION".

      Choices:
      - CHAT
      - QUESTION

      Defintion:
      CHAT:
      Normal chatting language with no data question. Nothing to do with the data.
      Examples:
      - "Hi!"
      - "How are you?"

      QUESTION:
      Direct question on the data, but can include a bit of chat.
      Examples:
      - "How many orders were sold in 2023 and 2024?"
      - "How many users spent over $100 in Q4 2022?"

      <return format>
      "CHAT"
      </return format>

      or

      <return format>
      "QUESTION"
      </return format>

      Question:
      '{{prompt_input._parameter_value}}'

      Response:
      """ AS prompt
      ),
      STRUCT(
      0.05 AS temperature,
      1024 AS max_output_tokens,
      0.98 AS top_p,
      TRUE AS flatten_json_output,
      1 AS top_k
      )
      )

      ;;
  }
  parameter: prompt_input {}

  parameter: previous_messages {}

  dimension: generated_content {}
}
