### Configuration
config = YAML::load(File.read('config.yml'))

name = config['config']['name']
description = config['config']['description']
username = config['config']['username']
password = config['config']['password']
theme = config['config']['theme']

set :public_dir, 'views/themes/#{theme}/static'

### Models
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/marvin.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :body, Text
  property :created_at, DateTime
  property :slug, String
end

class Page
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :body, Text
  property :slug, String
end

DataMapper.auto_migrate!

### Controllers
get '/' do
  @posts = Post.get(:order => [ :id_desc ])
  haml :"themes/#{theme}/index"
end

get '/:year/:month/:day/:slug' do
  year = params[:year]
  month = params[:month]
  day = params[:day]
  slug = params[:slug]

  haml :"themes/#{theme}/post.haml"
end

get '/:slug' do
  haml :"themes/#{theme}/page.haml"
end

get '/admin' do
  haml :"admin/index.haml"
end