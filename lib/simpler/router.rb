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
      path = env['REQUEST_PATH']
      path_arr = path.split('/')
      env['REQUEST_PARAMS'] = {}
      table_name = path_arr[1]

      # Name of primary_key of Table
      primary_key = Simpler.application.db[table_name.to_sym].columns[0]

      # Add parameters to env['REQUEST_PARAMS'] as hash
      path_arr.each_with_index do |element, index|
        env['REQUEST_PARAMS'][primary_key]=path_arr[index+1].to_i if (element.to_i==0 && path_arr[index+1].to_i>0)
      end

      @routes.find { |route| route.match?(method, path) }
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
