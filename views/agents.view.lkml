view: agents {
  # extension: required
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

# include: "//chatter_lookml/views/*.view.lkml"

# view: +agents {
#   derived_table: {
#     sql:
#     SELECT
#       'AGENT_NAME' AS agent_name,
#       'MODEL_NAME' AS model,
#       'EXPLORE_NAME' AS explore
#     -- UNION ALL
#     -- SELECT
#     --   'AGENT_NAME' AS agent_name,
#     --   'MODEL_NAME' AS model,
#     --   'EXPLORE_NAME' AS explore
#     ;;
#   }

# }
