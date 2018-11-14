require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    @logger.info(template(env, status, headers))
    [status, headers, body]
  end

  private

  def template(env, status, headers)
    method = env['REQUEST_METHOD']
    adress = env['PATH_INFO']
    controller = env['simpler.controller']
    controller_class = controller.class
    action = env['simpler.action'] || 'Bad request'
    params = env['simpler.route_params'] || '{}'
    headers = headers['Content-Type']
    controller_name = (controller&.name)  || 'Bad request'

    <<-HEREDOC

    Request: #{method} #{adress}
    Handler: #{controller_class}##{action}
    Parameters: #{params}
    Response: #{status} [#{headers}] #{controller_name}/#{action}.html.erb
    HEREDOC
  end

end
