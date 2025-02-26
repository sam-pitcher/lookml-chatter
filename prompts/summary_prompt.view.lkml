view: summary_prompt {
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
  FROM ${fields.SQL_TABLE_NAME} WHERE agent_name = {{agent._parameter_value | replace: "\'", ""}}
),

    prompt_template AS (
        SELECT REPLACE("""
You are tasked with interpreting the JSON object output from a Looker API query and crafting a friendly, engaging summary of the data. Your response should feel conversational, relatable, and directly address the last question posed, using the JSON data as your guide.

### Task:
- Carefully analyze the JSON output to identify the most relevant and meaningful insights.
- Summarize the findings in a concise and approachable manner (1–2 sentences).
- Frame the summary as if you're answering a question, ensuring your tone is friendly and inviting.
- Focus on the practical implications of the data, avoiding technical jargon.

### Tips:
- Highlight trends, comparisons, or significant metrics.
- Use field descriptions and example questions to provide meaningful context.
- Ensure the summary is high-level, keeping it understandable and engaging.
- Ensure the response questions are inline with what fields are available.
- Ensure the previous question isn't the question you're about to ask.

### Available fields for responses that could be aligned with the next question:
FIELDS_LIST

### Example responses:
1. "It looks like there were 478 orders last year! Is there another metric you'd like to explore?"
2. "Sales increased by 12% from 2023 to 2024."
3. "Customer retention is up by 8% this quarter—great news! What shall we look into next?"
4. "Most orders came from the Midwest region last month. Shall we explore trends by product category?"
5. "Revenue hit $1.2M last year, with Q4 contributing the most. Curious about performance by month?"
6. "It seems like the top-selling product was the 'Classic Coffee Mug' with 1,200 units sold! Want to look at other top products?"
7. "Your customer satisfaction score has reached an all-time high of 92%. Would you like insights on how to sustain this?"
8. "The most popular day for purchases was Saturday. Would you like to examine weekend trends further?"
9. "The average order value increased to $45, up from $40 last year. Would you like to explore how discounts impacted this?"
10. "Employee productivity rose by 15% this month compared to last. Shall we break it down by department?"

### Context:
- Use the provided field descriptions and example questions as a guide for interpreting the data.
- Craft responses that resonate with a non-technical audience, emphasizing clarity and relatability.

# Previous Messages:
'{{previous_messages._parameter_value}}'

JSON to summarize:
'{{prompt_input._parameter_value}}'
      """
      ,
  "FIELDS_LIST",
  fields_cte.fields) AS generated_prompt FROM fields_cte)

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
  parameter: input_question {type:string}
  parameter: previous_messages {type:string}
  parameter: output_json {type:string}
  parameter: model {default_value:"thelook"}
  parameter: explore {default_value:"order_items"}
  parameter: agent {default_value:"Customer 360"}

  dimension: generated_content {}
}
