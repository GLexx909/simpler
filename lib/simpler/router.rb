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
      env['REQUEST_PARAMS'] = {}
      @env_path_arr = path.split('/')

      route_found = @routes.find { |route| route.match?(method, path) }

      # get keys for env_params
      params = {}
      route_found.path.split('/').map.with_index do |part, index|
        if part.match?(':')
          params[part.delete(':').to_sym] = index
        end
      end

      # get and add values for env_params
      params.each do |key, val|
        value = @env_path_arr[val]
        env['REQUEST_PARAMS'][key] = value.to_i
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
