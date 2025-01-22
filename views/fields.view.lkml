view: fields {
  sql_table_name: `@{fields_table_name}` ;;

  dimension: available_in_chatter {
    type: yesno
    sql: ${TABLE}.available_in_chatter ;;
  }
  dimension: field {
    type: string
    sql: ${TABLE}.field ;;
  }
  dimension: field_type {
    type: string
    sql: ${TABLE}.field_type ;;
  }
  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }
  dimension: explore {
    type: string
    sql: ${TABLE}.explore ;;
  }
  dimension: view {
    type: string
    sql: ${TABLE}.view ;;
  }

}
