# Sinatra bootstrap

## Installation

	git clone git://github.com/aimerickdesdoit/ruby-sinatra-bootstrap.git
	cd ruby-sinatra-bootstrap
	gem install bundler
	bundle install
	rackup

## json

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

## text/html

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
	  @message = 'Hello world !'
	  haml :index
	end