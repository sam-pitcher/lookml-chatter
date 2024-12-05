view: prompt {
  derived_table: {
    sql:

    -- Fetch chat history
    -- DECLARE formatted_chat_history STRING;
    -- SET formatted_chat_history = (
    --     SELECT STRING_AGG(sender || ': ' || message, '\n' ORDER BY message_timestamp)
    --     FROM chat_history
    --     WHERE conversation_id = 123  -- Replace with the actual conversation ID
    -- );

    SELECT ml_generate_text_llm_result AS generated_content
    FROM
    ML.GENERATE_TEXT(
        MODEL `explore_assistant.explore_assistant_llm`,
        (
          SELECT """
          You are an expert assistant on this subject:
          @{preamble}

        -- Previous conversation:
        -- " || formatted_chat_history || "

        From this, please answer this question:

          From this, please answer this question:
          {{input_question._parameter_value}}

          """ as prompt
        ),
        STRUCT(
        0.05 AS temperature,
        1024 AS max_output_tokens,
        0.98 AS top_p,
        TRUE AS flatten_json_output,
        1 AS top_k)
      )
    ;;
  }

  parameter: input_question {
    type: string
  }
  dimension: generated_content {}

}
