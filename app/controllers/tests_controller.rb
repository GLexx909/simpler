class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    # render plain: "Plain text response", status: 201
    # render 'tests/list'
    # response.headers['Content-Type'] = 'text/plain'
  end

  def create

  end

  def show
    @test = Test.find(params[:id])
  end

end
