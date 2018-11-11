require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = @request.env['simpler.render_plain'] || render_body
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      path = @request.env['REQUEST_PATH']
      path_arr = path.split('/')
      @request.env['REQUEST_PARAMS'] = {}

      # Name of primary_key of Table
      primary_key = Simpler.application.db[@name.to_sym].columns[0]

      # Add parameters to @request.env['REQUEST_PARAMS'] as hash
      path_arr.each_with_index do |element, index|
        @request.env['REQUEST_PARAMS'][primary_key]=path_arr[index+1].to_i if (element.to_i==0 && path_arr[index+1].to_i>0)
      end

      @request.env['REQUEST_PARAMS'].merge!(@request.params)
    end

    def render(data)
      if data.is_a?(String)
        @request.env['simpler.template'] = data
      else  # if data is {method: 'params'}
        data.each { |method, value| send(method, value) }
      end
    end

    def plain(value)
      @request.env['simpler.render_plain'] = value
    end

    def status(value)
      @response.status = value
    end

  end
end
