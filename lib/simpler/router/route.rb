module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :path

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(method, path)
        path_init = path_detect(@path)

        @method == method && same_length?(path) && path.match?(/^#{path_init}/)
      end

      def path_detect(path)
        path_arr = path.split('/')
        path_arr.map.with_index do |part, index|
          if part.match?(':')
            path_arr[index] = '.*'
          end
        end
        path_arr.join('/')
      end

      def same_length?(path)
        path.split('/').length == @path.split('/').length
      end

    end
  end
end
