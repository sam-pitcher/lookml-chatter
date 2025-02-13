view: agents {
  sql_table_name: `@{agents_table_name}` ;;

  dimension: explore {
    type: string
    sql: ${TABLE}.explore ;;
  }

  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

}
