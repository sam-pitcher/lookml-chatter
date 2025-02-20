view: examples {
  sql_table_name: `@{example_table_name}` ;;

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: explore {
    type: string
    sql: ${TABLE}.explore ;;
  }

  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: input_question {
    type: string
    sql: ${TABLE}.input_question ;;
  }

  dimension: output_json {
    type: string
    sql: ${TABLE}.output_json ;;
  }

}
