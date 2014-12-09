require "grn_mini"
require "sinatra/base"
require "sinatra/reloader"
require "haml"
require "sass"
require "coffee-script"

class MTask < Sinatra::Base
  register Sinatra::Reloader

  set :bind, "0.0.0.0"
  set :env, :production
  set :port, 7400

  enable :method_override

  configure do
    GrnMini::create_or_open("db/tasks.db")
    $tasks = GrnMini::Array.new("Tasks")

    $tasks.setup_columns(content: "") if $tasks.empty?
  end

  get "/" do
    query = params[:query] || ""
    if query.empty?
      hit_tasks = $tasks
    else
      hit_tasks = $tasks.select("content:@#{query}")
    end

    haml :index, locals: {params: params, tasks: hit_tasks}
  end

  post "/" do
    content = params[:new_task]
    $tasks << {content: content} unless content.empty?
    redirect "/"
  end

  post "/search" do
    redirect "/?query=#{escape(params[:query])}"
  end

  patch "/:id" do
    task = $tasks[params[:id].to_i]
    content = params[:content]
    task.content = content
    redirect "/"
  end

  delete "/:id" do
    task = $tasks[params[:id].to_i]
    task.delete if task
    redirect "/"
  end

  # assets

  get "/main.css" do
    sass :"sass/main"
  end

  get "/main.js" do
    coffee :"coffee/main"
  end

  # run

  run! if app_file == $0
end
