class ResponseTimer
  def initialize(app)
    @app = app
  end
  
  def call(env)
    [200, {'Content-Type' => 'text/html'}, "Hello, World!"]
  end
end