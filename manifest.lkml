project_name: "chatter"

constant: agents_table_name {
  value: "chatter.agents"
}

constant: example_table_name {
  value: "chatter.examples"
}

constant: fields_table_name {
  value: "chatter.fields"
}

constant: extra_context_table_name {
  value: "chatter.extra_context"
}


application: chatter {
  label: "Chatter"
  # url: "https://localhost:8080/bundle.js"
  # - this is used in prod!
  file: "bundle.js"
  entitlements: {
    core_api_methods: ["me", "lookml_model_explore","create_sql_query","run_sql_query","run_query","create_query", "run_inline_query", "all_lookml_models", "use_form_submit", "lookml_model", "create_merge_query", "merge_query"]
    navigation: yes
    use_embeds: yes
    use_iframes: yes
    new_window: yes
    new_window_external_urls: ["https://developers.generativeai.google/*"]
    external_api_urls: ["https://dataqna.googleapis.com/v1alpha1/projects/sam-pitcher-playground:askQuestion", "https://dataqna.googleapis.com","https://localhost:8080","http://localhost:8080"]
    oauth2_urls: ["https://accounts.google.com/o/oauth2/v2/auth"]
    local_storage: yes
  }
}
