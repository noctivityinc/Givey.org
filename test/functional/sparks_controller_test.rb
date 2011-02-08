require 'test_helper'

class SparksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Spark.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Spark.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Spark.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to spark_url(assigns(:spark))
  end

  def test_edit
    get :edit, :id => Spark.first
    assert_template 'edit'
  end

  def test_update_invalid
    Spark.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Spark.first
    assert_template 'edit'
  end

  def test_update_valid
    Spark.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Spark.first
    assert_redirected_to spark_url(assigns(:spark))
  end

  def test_destroy
    spark = Spark.first
    delete :destroy, :id => spark
    assert_redirected_to sparks_url
    assert !Spark.exists?(spark.id)
  end
end
