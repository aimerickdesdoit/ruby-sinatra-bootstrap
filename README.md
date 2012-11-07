# Sinatra bootstrap

## Supports

* active record
* capistrano
* haml
* padrino helpers
* padrino mailers
* sass / compass
* sinatra reloader
* sprockets / asset hosts / manifest

## Installation

	git clone git://github.com/aimerickdesdoit/ruby-sinatra-bootstrap.git
	cd ruby-sinatra-bootstrap
	gem install bundler
	bundle install
	rackup

### json

	# error handling

	error Sinatra::NotFound do
	  @json[:message] = "No entry point for #{request.path_info}"
	  logger.error @json[:message]
	  @json.to_json
	end

	error do
	  @json[:message] = "Internal Server Error : #{request.env['sinatra.error'].message}"
	  logger.error request.env['sinatra.error']
	  @json.to_json
	end

	# controllers

	before do
	  content_type :json
	  @json = {
	    :environment => MyApp.environment
	  }
	end

	get '/' do
	  @json[:message] = 'Hello world !'
	  @json.to_json
	end

### text/html

	# error handling

	error Sinatra::NotFound do
	  @message = "No entry point for #{request.path_info}"
	  logger.error @message
	  haml 'errors/404'.to_sym
	end

	error do
	  @message = "Internal Server Error : #{request.env['sinatra.error'].message}"
	  logger.error request.env['sinatra.error']
	  haml 'errors/500'.to_sym
	end

	# controllers

	get '/' do
	  haml :index
	end

## Assets

### asset_host

with numeric based domains

	Sinatra::Sprockets.configure do |sprockets|
	  sprockets.configuration.asset_host = lambda do |path|
	    domain = 'http://assets%d.localhost:9292'
	    "#{domain % (path.hash % 3)}#{path}"
	  end
	end

with customized domains

	Sinatra::Sprockets.configure do |sprockets|
	  sprockets.configuration.asset_host = lambda do |path|
	    domains = %w(assets0.localhost assets1.localhost assets2.localhost)
	    "http://#{domains[path.hash % domains.count]}:9292#{path}"
	  end
	end

with extension based domains

	Sinatra::Sprockets.configure do |sprockets|
	  sprockets.configuration.asset_host = lambda do |path|
	    domains = {
	      :css  => 'stylesheets.localhost',
	      :js   => 'javascripts.localhost',
	      :png  => 'images.localhost'
	    }
	    domain = domains[File.extname(path).gsub('.', '').downcase.to_sym] || 'assets.localhost'
	    "http://#{domain}:9292#{path}"
	  end
	end