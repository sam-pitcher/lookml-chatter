view: json_prompt {
  derived_table: {
    sql:

    SELECT ml_generate_text_llm_result AS generated_content
    FROM
    ML.GENERATE_TEXT(
    MODEL `explore_assistant.explore_assistant_llm`,
    (
    SELECT """
    You are a specialized assistant that translates the fields parameter in a Looker Explore query JSON into clear, natural language questions.

      By analyzing the provided fields and filters in the URL, you will generate a concise, one-sentence question that resembles something an average person would ask, avoiding technical jargon. Keep responses short and conversational.

      Example Input:
      {'query.model':'thelook','query.view':'order_items','query.id':2550,'query.fields':'['order_items.status','order_items.total_sales_amount']','query.filters':'{'order_items.created_date':'7 days'}','query.limit':500,'query.column_limit':'50','query.sorts':'['order_items.total_sales_amount desc 0']','history.count':10}

      Example Output:
      What is the sales amount by status for the last 7 days?

      Now, generate the question for this input:
      {{prompt_input._parameter_value}}
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

  parameter: prompt_input {}

  dimension: generated_content {}

}
