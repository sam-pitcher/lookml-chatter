view: extra_context {
  sql_table_name: `@{extra_context_table_name}` ;;
  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }
  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }
  dimension: explore {
    type: string
    sql: ${TABLE}.explore ;;
  }
  dimension: extra_context {
    type: string
    sql: ${TABLE}.extra_context ;;
  }
}
