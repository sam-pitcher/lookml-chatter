view: chat_prompt {
  derived_table: {
    sql:
    WITH

examples_cte AS (
  SELECT STRING_AGG(
      CONCAT(
          'input_question: ', input_question, '\n',
          'output_json: ', output_json, '\n'
      )
  ) AS examples
  FROM ${examples.SQL_TABLE_NAME}
  WHERE explore = "order_items" and model = "thelook"
),

prompt_template AS (
  SELECT REPLACE("""
  You are tasked with generating a JSON object for a Looker API query based on the given input question. The JSON must follow this exact structure and type formatting:
  {
    "query.model": "{model}",
    "query.view": "{view}",
    "query.fields": "[{fields}]",  -- Comma-separated, wrapped in single quotes and square brackets
    "query.filters": "{filters}",  -- Key-value pairs wrapped in single quotes and curly braces
    "query.limit": {limit},        -- Integer value
    "query.column_limit": "{column_limit}", -- String value, e.g., '50'
    "query.sorts": "[{sorts}]"    -- Comma-separated, wrapped in single quotes and square brackets
  }

  ### Examples Input and Output:
  INPUT_EXAMPLES

  - **Field Descriptions**:
    - "query.model" and "query.view": Strings specifying the model and view.
    - "query.fields": Comma-separated fields wrapped in single quotes and square brackets (e.g., '['field1','field2']').
    - "query.filters": Key-value pairs for filtering, wrapped in single quotes and curly braces.
    - "query.limit": Integer specifying the maximum rows, default to 500 if not mentioned.
    - "query.column_limit": String specifying the maximum columns, default to '50' if not mentioned.
    - "query.sorts": Comma-separated sorting fields wrapped in single quotes and square brackets.

  ### Task:
  Based on the input question below, generate the corresponding JSON query. Ensure:
  1. All fields are formatted as per the example.
  2. Only return the JSON object, nothing else. It must start and end with {} only.

  input_question: '{{prompt_input._parameter_value}}'
  """,
  "INPUT_EXAMPLES",
  examples_cte.examples
  ) AS generated_prompt FROM examples_cte
)

SELECT ml_generate_text_llm_result AS generated_content
FROM ML.GENERATE_TEXT(
  MODEL `chatter.chatter_llm`,
  (
    SELECT generated_prompt AS prompt
    FROM prompt_template
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

  parameter: input_question {}

  parameter: previous_messages {}

  dimension: generated_content {}
}
