require 'test_helper'

class MturksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Mturk.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Mturk.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Mturk.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to mturk_url(assigns(:mturk))
  end

  def test_edit
    get :edit, :id => Mturk.first
    assert_template 'edit'
  end

  def test_update_invalid
    Mturk.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Mturk.first
    assert_template 'edit'
  end

  def test_update_valid
    Mturk.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Mturk.first
    assert_redirected_to mturk_url(assigns(:mturk))
  end

  def test_destroy
    mturk = Mturk.first
    delete :destroy, :id => mturk
    assert_redirected_to mturks_url
    assert !Mturk.exists?(mturk.id)
  end
end
