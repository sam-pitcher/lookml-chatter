view: chat_prompt {
  derived_table: {
    sql:
    WITH

fields_cte AS (
  SELECT STRING_AGG(
      CONCAT(
          'field: ', field, '\n',
          'description: ', field, '\n'
      )
  ) AS fields
  FROM ${fields.SQL_TABLE_NAME}
  WHERE explore = {{explore._parameter_value | replace: "\'", ""}} and model = {{model._parameter_value | replace: "\'", ""}}
),

examples_cte AS (
  SELECT STRING_AGG(
      CONCAT(
          'input_question: ', input_question, '\n',
          'output_json: ', output_json, '\n'
      )
  ) AS examples
  FROM ${examples.SQL_TABLE_NAME}
  WHERE explore = {{explore._parameter_value | replace: "\'", ""}} and model = {{model._parameter_value | replace: "\'", ""}}
),

prompt_template AS (
  SELECT REPLACE(REPLACE("""
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

  - **Available Fields**:
  - Only these fields can be used in the JSON response.
  - Note that they are in the format view_name.field_name.
  - You must always keep the fields as they as, don't switch the view_name with other fields.

  FIELDS_LIST

  ### Task:
  Based on the input question below and prior messages, generate the corresponding JSON query. Ensure:
  - The query reflects the intent of the input question and incorporates insights from prior messages, including temporal dimensions (e.g., year, quarter).
  - The generated JSON starts and ends with {} only and adheres to the provided structure. Do not include json ```
  - Prioritize precision and ensure the inclusion of all referenced fields when explicitly or implicitly mentioned.
  - Focus on the previous messages in the conversation so far.

  # Previous Messages:
  This is the conversation so far between you (bot) and the user.
  '{{previous_messages._parameter_value}}'

  input_question:
  '{{prompt_input._parameter_value}}'
  """,
  "INPUT_EXAMPLES",
  examples_cte.examples
  ),
  "FIELDS_LIST",
  fields_cte.fields) AS generated_prompt FROM examples_cte, fields_cte
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
  parameter: prompt_input {type:string}

  parameter: input_question {}

  parameter: previous_messages {type:string}

  parameter: model {default_value:"thelook"}

  parameter: explore {default_value:"order_items"}

  dimension: generated_content {}
}
