require 'test_helper'

class Admin::MturksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Mturks.first
    assert_template 'show'
  end
end
