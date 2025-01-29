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

extra_context_cte AS (
  SELECT STRING_AGG(
      CONCAT(
          'extra_context: ', extra_context, '\n'
      )
  ) AS extra_context
  FROM ${extra_context.SQL_TABLE_NAME}
  WHERE explore = {{explore._parameter_value | replace: "\'", ""}} and model = {{model._parameter_value | replace: "\'", ""}}
),

prompt_template AS (
  SELECT REPLACE(REPLACE(REPLACE("""
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

  - **Dates Filter Syntax**:

Basic Time Intervals
this {interval}
Example: this month
Notes: Supports this week, this month, this quarter, or this year. Does not support this day. Use today for current-day data.
Relative Time Intervals
{n} {interval}
Example: 3 days
{n} {interval} ago
Example: 3 days ago
{n} {interval} ago for {n} {interval}
Example: 3 months ago for 2 days
before {n} {interval} ago
Example: before 3 days ago
Specific Times
before {time}
Example: before 2018-01-01 12:00:00
Notes: Not inclusive of the time specified. For example, before 2018-01-01 excludes data from 2018-01-01.
after {time}
Example: after 2018-10-05
Notes: Inclusive of the time specified. For example, after 2018-10-05 includes data from 2018-10-05 onward.
Time Ranges
{time} to {time}
Example: 2018-05-18 12:00:00 to 2018-05-18 14:00:00
Notes: The start time is inclusive, but the end time is not. For instance, 2018-05-18 12:00:00 to 2018-05-18 14:00:00 retrieves data up to 13:59:59.
this {interval} to {interval}
Example: this year to second
Notes: Retrieves data from the start of the first interval to the start of the second. For example, this week to day covers the beginning of the week through the beginning of the current day.
Advanced Use Cases
{time} for {n} {interval}
Example: 2018-01-01 12:00:00 for 3 days
today
Retrieves data from the current day.
yesterday
Retrieves data from the previous day.
tomorrow
Retrieves data from the following day.
{day of week}
Example: Monday
Notes: Refers to the most recent occurrence of the specified day. For example, Monday returns the most recent Monday. You can combine this with before or after for advanced filtering:
after Monday: Returns data from the most recent Monday onward.
before Monday: Returns data before the most recent Monday, excluding the Monday itself.
Future Intervals
next {interval}
Example: next week
Notes: Only works with specific intervals like week, month, quarter, fiscal quarter, year, and fiscal year.
{n} {interval} from now
Example: 3 days from now
{n} {interval} from now for {n} {interval}
Example: 3 days from now for 2 weeks

  ### Task:
  Based on the input question below and prior messages, generate the corresponding JSON query. Ensure:
  - The query reflects the intent of the input question and incorporates insights from prior messages, including temporal dimensions (e.g., year, quarter).
  - The generated JSON starts and ends with {} only and adheres to the provided structure. Do not include json ```
  - Prioritize precision and ensure the inclusion of all referenced fields when explicitly or implicitly mentioned.
  - Focus on the previous messages in the conversation so far.

  # Previous Messages:
  This is the conversation so far between you (bot) and the user.
  '{{previous_messages._parameter_value}}'

  # Extra Context:
  EXTRA_CONTEXT

  input_question:
  '{{prompt_input._parameter_value}}'
  """,
  "INPUT_EXAMPLES",
  examples_cte.examples
  ),
  "FIELDS_LIST",
  fields_cte.fields
  ),
  "EXTRA_CONTEXT",
  extra_context_cte.extra_context) AS generated_prompt FROM examples_cte, fields_cte, extra_context_cte
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
