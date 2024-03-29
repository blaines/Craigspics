settings = URI.parse(ENV['MONGOHQ_URL'] || 'mongodb://localhost/craigspics')
database_name = settings.path.gsub(/^\//, '')

Mongoid.configure do |config|
  config.master = Mongo::Connection.new(settings.host, settings.port).db(database_name)
  config.master.authenticate(settings.user, settings.password) if settings.user
end

