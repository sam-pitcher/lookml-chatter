project_name: "chatter"

constant: example_table_name {
  value: "sam-pitcher-playground.chatter.examples_test"
}

constant: preamble {
  value: "
    Football, also known as soccer in some parts of the world, is a team sport played with a spherical ball between two teams of eleven players. It is the world's most popular sport, played by over 250 million players in over 200 countries and dependencies. The game is played on a rectangular field called a pitch with a goal at each end. The object of the game is to score by moving the ball beyond the goal line into the opposing goal.  

Basic Rules and Gameplay

Football is a game of two 45-minute halves, with a 15-minute break in between. The game is played with a single referee who enforces the rules, assisted by two assistant referees on the sidelines. Players can use any part of their body to move the ball, except their hands and arms, with the primary method being kicking the ball. The only player allowed to handle the ball within the penalty area is the goalkeeper, whose primary role is to prevent the opposing team from scoring.  

A typical football match begins with a kickoff in the center of the pitch, with the team that wins the coin toss choosing which goal to attack in the first half. The opposing team kicks off the second half. During the game, players attempt to move the ball down the field towards the opponent's goal through a combination of passing, dribbling, and running with the ball. The team with possession of the ball is the attacking team, while the other team is the defending team.  

Fouls and Misconduct

The referee enforces the rules of the game and can penalize players for fouls, which are infringements of the rules. Common fouls include tripping, kicking, pushing, holding, and handling the ball with the hands or arms (except for the goalkeeper within their penalty area). When a foul is committed, the referee awards a free kick to the opposing team. If a foul is committed within the penalty area, a penalty kick is awarded, which is a direct free kick taken from 12 yards out with only the goalkeeper defending.  

Players can be cautioned with a yellow card for unsporting behavior or persistent fouling. Two yellow cards in a single game result in a red card, which means the player is sent off and cannot be replaced, leaving their team with one less player.  

Positions and Formations

While the goalkeeper is the only designated position in football, players typically specialize in different roles on the field. These roles are broadly categorized into defenders, midfielders, and forwards.

Defenders: Primarily responsible for preventing the opposing team from scoring. They typically position themselves in front of their own goal and try to intercept passes, tackle opponents, and clear the ball from danger.  
Midfielders: Play in the middle of the field and are involved in both attacking and defending. They link the defense and attack, win the ball, create scoring opportunities, and contribute to both offensive and defensive plays.  
Forwards: The main attacking players whose primary goal is to score. They typically play closest to the opponent's goal and use their speed, skill, and finishing ability to create and convert scoring chances.  
Teams utilize different formations to organize their players on the field. Common formations include 4-4-2, 4-3-3, and 3-5-2, which indicate the number of players in each position (defenders, midfielders, and forwards). Formations can be adjusted depending on the opponent, the game situation, and the team's playing style.  

Tactics and Strategies

Football tactics and strategies are complex and varied, with teams employing different approaches to achieve success. Some common tactical elements include:  

Passing and movement: Teams use intricate passing sequences and coordinated player movement to create space and break down defenses.  
Possession football: A style of play focused on maintaining possession of the ball and controlling the tempo of the game.  
Counter-attacking: A strategy that involves quickly transitioning from defense to attack, exploiting spaces left by the opponent.  
Set pieces: Pre-planned routines for situations like free kicks, corner kicks, and throw-ins, designed to create scoring opportunities.  
Coaches analyze their opponents' strengths and weaknesses and devise game plans to maximize their own team's chances of winning. They make substitutions during the game to change the team's formation, introduce fresh players, or adjust their tactical approach.  

The Global Game

Football is a truly global sport, played and followed by millions around the world. The FIFA World Cup, held every four years, is the most prestigious international football tournament, attracting billions of viewers worldwide. Continental championships like the UEFA European Championship and the Copa América are also hugely popular.  

At the club level, domestic leagues like the English Premier League, Spanish La Liga, and German Bundesliga are followed by passionate fans worldwide. The UEFA Champions League, a competition between the top clubs in Europe, is one of the most prestigious club tournaments in the world.  

Football's popularity has led to the development of a massive global industry, with billions of dollars generated through broadcasting rights, sponsorships, and merchandise sales. The sport has also become a powerful platform for social and cultural expression, bringing people together from all walks of life.  

This is just a brief overview of the beautiful game. There are countless nuances, strategies, and stories that make football such a captivating and enduring sport. From the grassroots level to the professional game, football continues to inspire and entertain people across the globe.
  "
}

constant: examples {
  value: "

  input_question: What are the total sales amount and status of all orders?

  output_json: {'query.model':'thelook','query.view':'order_items','query.fields':'['order_items.total_sales_amount','order_items.status']','query.filters':null,'query.limit':500,'query.column_limit':null,'query.sorts':null}


  input_question: What is the sales amount by status for the last 7 days?

  output_json: {'query.model':'thelook','query.view':'order_items','query.id':2550,'query.fields':'['order_items.status','order_items.total_sales_amount']','query.filters':'{'order_items.created_date':'7 days'}','query.limit':500,'query.column_limit':'50','query.sorts':'['order_items.total_sales_amount desc 0']','history.count':10}


  input_question: How many orders are there by status for the last 7 days?

  output_json: {'query.model':'thelook','query.view':'order_items','query.id':1021,'query.fields':'['order_items.status','order_items.count']','query.filters':'{'order_items.created_date':'7 day'}','query.limit':500,'query.column_limit':'50','query.sorts':'['order_items.count desc 0']','history.count':9}


  input_question: How does the total sales amount and year-to-date sales amount break down by the first dimension?

  output_json: {'query.model':'thelook','query.view':'order_items','query.id':2502,'query.fields':'['order_items.dimension_from_parameter_1','order_items.total_sales_amount','order_items.total_sales_amount_ytd']','query.filters':'{'order_items.dimension_1':'status'}','query.limit':500,'query.column_limit':'50','query.sorts':'['order_items.dimension_from_parameter_1']','history.count':5}


  input_question: What is the total sales amount for the past year?

  output_json: {'query.model':'thelook','query.view':'order_items','query.id':1904,'query.fields':'['order_items.total_sales_amount']','query.filters':'{'order_items.created_month':'1 years'}','query.limit':500,'query.column_limit':'50','query.sorts':null,'history.count':4}


  input_question: How many orders were placed each day in the last 7 days?

  output_json: {'query.model':'thelook','query.view':'order_items','query.id':1027,'query.fields':'['order_items.count','order_items.created_date']','query.filters':'{'order_items.created_date':'7 day'}','query.limit':500,'query.column_limit':'50','query.sorts':'['order_items.created_date desc']','history.count':4}


  input_question: How are sales and cumulative sales changing over time in November 2024?

  output_json: {'query.model':'thelook','query.view':'order_items','query.id':1053,'query.fields':'['order_items.count','order_items.created_date','order_items.total_sales_amount','order_items.cum_sales_amount']','query.filters':'{'order_items.created_month_year':'11-2024'}','query.limit':500,'query.column_limit':'50','query.sorts':'['order_items.created_date desc']','history.count':3}

  "
}

# constant: examples {
#   value: "

#   input_question: How many sales were there, and when were they created?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.count,__record_count,sales_denormalized.creation_date&&sorts=&limit=&column_limit=&origin=share-expanded


#   input_question: How many sales are available, and when were they created?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.count,__record_count,sales_denormalized.creation_date&f[sales_denormalized.status]=available&sorts=&limit=&column_limit=&origin=share-expanded


#   input_question: How many sales were made on each date?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.creation_date,__record_count,sales_denormalized.count&&sorts=&limit=&column_limit=&origin=share-expanded


#   input_question: How many available sales were there each day?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.creation_date,__record_count,sales_denormalized.count&f[sales_denormalized.status]=available&sorts=&limit=&column_limit=&origin=share-expanded


#   input_question: How many sales were made each day?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.count,__record_count,sales_denormalized.creation_date&&sorts=sales_denormalized.creation_date asc &limit=5000&column_limit=&origin=share-expanded


#   input_question: How many available sales are there, and what's the total number of sales records?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.count,__record_count,sales_denormalized.status&f[sales_denormalized.status]=available&sorts=sales_denormalized.count desc &limit=5000&column_limit=&origin=share-expanded


#   input_question: How many available items are there, and what's the total count of items?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.status,__record_count,sales_denormalized.count&f[sales_denormalized.status]=available&sorts=sales_denormalized.count desc &limit=5000&column_limit=&origin=share-expanded


#   input_question: How many sales are there, and how many unique customers are involved?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.count,__record_count,sales_denormalized.customer_key&&sorts=sales_denormalized.count desc &limit=5000&column_limit=&origin=share-expanded

#   input_question: How many orders last year?

#   output_url: https://452227bf-6f71-4262-bb19-e913e4ee41db.looker.app/embed/explore/shred/sales_denormalized?fields=sales_denormalized.count&f[sales_denormalized.creation_date]=1+year+ago+for+1+year&limit=5000&column_limit=50&origin=share-expanded

#   "
# }

application: chatter {
  label: "Chatter"
  url: "https://localhost:8080/bundle.js"
  # file: "bundle.js"
  entitlements: {
    core_api_methods: ["me", "lookml_model_explore","create_sql_query","run_sql_query","run_query","create_query", "run_inline_query", "all_lookml_models", "use_form_submit", "lookml_model"]
    navigation: yes
    use_embeds: yes
    use_iframes: yes
    new_window: yes
    new_window_external_urls: ["https://developers.generativeai.google/*"]
    local_storage: yes
    # external_api_urls: ["https://us-central1-sam-pitcher-playground.cloudfunctions.net/explore-assistant-api"]
    external_api_urls : ["https://us-central1-sam-pitcher-playground.cloudfunctions.net","https://localhost:8080","http://localhost:8080"]
  }
}
