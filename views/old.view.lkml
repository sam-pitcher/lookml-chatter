# view: chat_prompt_old {
#   derived_table: {
#     sql:

#       SELECT ml_generate_text_llm_result AS generated_content
#     FROM
#       ML.GENERATE_TEXT(
#         MODEL `explore_assistant.explore_assistant_llm`,
#         (
#           SELECT """
#     You are tasked with generating a JSON object for a Looker API query based on the given input question. The JSON must follow this exact structure and type formatting:

#       {
#       'query.model': '{model}',
#       'query.view': '{view}',
#       'query.fields': '[{fields}]',  -- Comma-separated, wrapped in single quotes and square brackets
#       'query.filters': '{filters}',  -- Key-value pairs wrapped in single quotes and curly braces
#       'query.limit': {limit},        -- Integer value
#       'query.column_limit': '{column_limit}', -- String value, e.g., '50'
#       'query.sorts': '[{sorts}]',    -- Comma-separated, wrapped in single quotes and square brackets
#       }

# ### Examples Input and Output:
#       @{examples}

#       - **Field Descriptions**:
#       - `query.model` and `query.view`: Strings specifying the model and view.
#       - `query.fields`: Comma-separated fields wrapped in single quotes and square brackets (e.g., '['field1','field2']').
#       - `query.filters`: Key-value pairs for filtering, wrapped in single quotes and curly braces.
#       - `query.limit`: Integer specifying the maximum rows, default to 500 if not mentioned.
#       - `query.column_limit`: String specifying the maximum columns, default to '50' if not mentioned.
#       - `query.sorts`: Comma-separated sorting fields wrapped in single quotes and square brackets.

# ### Task:
#       Based on the input question below, generate the corresponding JSON query. Ensure:
#       1. All fields are formatted as per the example.
#       2. Only return the JSON object, nothing else.

#       input_question: {{input_question._parameter_value}}
#       """ AS prompt
#       ),
#       STRUCT(
#       0.05 AS temperature,
#       1024 AS max_output_tokens,
#       0.98 AS top_p,
#       TRUE AS flatten_json_output,
#       1 AS top_k)
#       )
#       ;;
#   }

#   parameter: prompt_input {}

#   parameter: input_question {}

#   parameter: previous_messages {}

#   dimension: generated_content {}

# }

# view: url_prompt {
#   derived_table: {
#     sql:

#     SELECT ml_generate_text_llm_result AS generated_content
#     FROM
#     ML.GENERATE_TEXT(
#     MODEL `explore_assistant.explore_assistant_llm`,
#     (
#     SELECT """
#     You are a specialized assistant that translates the fields parameter in a Looker Explore query URL into clear, natural language questions.

#       By analyzing the provided fields and filters in the URL, you will generate a concise, one-sentence question that resembles something an average person would ask, avoiding technical jargon. Keep responses short and conversational.

#       Example Input:
#       fields=users.count&f[products.category]=Jeans&f[order_items.created_date]=1+years&limit=500&origin=share-expanded

#       Example Output:
#       How many users bought jeans last year?

#       Now, generate the question for this input:
#       {{prompt_input._parameter_value}}
#       """ as prompt
#       ),
#       STRUCT(
#       0.05 AS temperature,
#       1024 AS max_output_tokens,
#       0.98 AS top_p,
#       TRUE AS flatten_json_output,
#       1 AS top_k)
#       )
#       ;;
#   }

#   parameter: prompt_input {}

#   dimension: generated_content {}

# }


# view: prompt_old {
#   derived_table: {
#     sql:

#     SELECT ml_generate_text_llm_result AS generated_content
#     FROM
#     ML.GENERATE_TEXT(
#     MODEL `explore_assistant.explore_assistant_llm`,
#     (
#     SELECT """
#     {{prompt_input._parameter_value}}
#     """ as prompt
#     ),
#     STRUCT(
#     0.05 AS temperature,
#     1024 AS max_output_tokens,
#     0.98 AS top_p,
#     TRUE AS flatten_json_output,
#     1 AS top_k)
#     )
#     ;;

#   }

#   parameter: prompt_input {}

#   parameter: input_question {}

#   parameter: previous_messages {}

#   dimension: generated_content {}

# }

# view: explore_prompt {
#   derived_table: {
#     sql:

#     SELECT ml_generate_text_llm_result AS generated_content
#     FROM
#     ML.GENERATE_TEXT(
#     MODEL `chatter.chatter_llm`,
#     (
#     SELECT """
#     You are tasked with generating a URL for a Looker API query based on the given input question. The URL must follow this structure and include relevant parameters like fields, filters, sorting, and limits.

#       - Previous conversation:
#       {{previous_messages._parameter_value}}

#       URL Structure:
#       /explore/{model}/{view}?fields={fields}&{filters}&sorts={sorts}&limit={limit}&column_limit={column_limit}&origin=share-expanded

#       {model} is the model being queried, e.g., basic_order_items.
#       {view} is the specific view, e.g., users, if mentioned in the question.
#       {fields} are the comma-separated fields relevant to the question (e.g., basic_users.count, basic_order_items.average_sale_price).
#       {filters} are conditions like f[basic_users.created_at_date]=6+month+ago or other applicable filters.
#       {sorts} is the sorting order (e.g., basic_users.count desc).
#       {limit} is the maximum number of rows, e.g., 500.
#       {column_limit} is the maximum number of columns, e.g., 50.

#       - Process:
#       Identify Key Information:

#       Fields: Extract the fields to include in the query.
#       Filters: Identify any time periods, categories, or specific conditions to filter by.
#       Sorting: Determine if sorting is required.
#       Limit: If mentioned, use it. If not, default to 500.
#       Column Limit: Default to 50 if not mentioned.

#       - Here are some examples:
#       @{examples}

#       - Task:
#       Now, based on the input question, follow the above rules to generate the corresponding URL. The question may involve aggregations, time ranges, filters, and specific sorting orders. Only return the URL with no quote notation.
#       input_question: {{input_question._parameter_value}}
#       """ as prompt
#       ),
#       STRUCT(
#       0.05 AS temperature,
#       1024 AS max_output_tokens,
#       0.98 AS top_p,
#       TRUE AS flatten_json_output,
#       1 AS top_k)
#       )
#       ;;
#   }

#   parameter: prompt_input {}

#   parameter: input_question {}

#   parameter: previous_messages {}

#   dimension: generated_content {}

# }
