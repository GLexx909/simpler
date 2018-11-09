module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        path = path_detect(path)
        @method == method && path.match?(/^#{@path}$/)
      end

      def path_detect(path)
        path_array = path.split('/')
        if path_array.last.to_i > 0
          path_array.pop
          path_array << ':id'
          path_array.join('/')
        else
          path
        end
      end

    end
  end
end
