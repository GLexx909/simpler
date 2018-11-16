require_relative 'router/route'

module Simpler
  class Router

    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']
      env['simpler.route_params'] = {}
      env_path_arr = path.split('/')

      route_found = @routes.find { |route| route.match?(method, path) }
      return if route_found.nil?

      # get keys for env_params
      route_found.path.split('/').each.with_index do |part, index|
        env['simpler.route_params'][part.delete(':').to_sym] = env_path_arr[index] if part.match?(':')
      end

      route_found
    end

    private

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]
      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end

  end
end
