view: examples {
  sql_table_name: `@{example_table_name}` ;;

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

view: examples_uploader {
  derived_table: {
    create_process: {
      sql_step:
      CREATE OR REPLACE TABLE `@{example_table_name}` AS (
      SELECT * FROM `sam-pitcher-playground.chatter.examples`
      )
      ;;
      sql_step:
      CREATE OR REPLACE TABLE ${SQL_TABLE_NAME} AS (SELECT 1 as one) ;;
    }
    persist_for: "1 second"
  }
  dimension: one {}
}
