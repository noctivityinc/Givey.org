require 'test_helper'

class Admin::BackgroundsControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end

  context "show action" do
    should "render show template" do
      get :show, :id => Background.first
      assert_template 'show'
    end
  end

  context "new action" do
    should "render new template" do
      get :new
      assert_template 'new'
    end
  end

  context "create action" do
    should "render new template when model is invalid" do
      Background.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end

    should "redirect when model is valid" do
      Background.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to admin_background_url(assigns(:background))
    end
  end

  context "edit action" do
    should "render edit template" do
      get :edit, :id => Background.first
      assert_template 'edit'
    end
  end

  context "update action" do
    should "render edit template when model is invalid" do
      Background.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Background.first
      assert_template 'edit'
    end

    should "redirect when model is valid" do
      Background.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Background.first
      assert_redirected_to admin_background_url(assigns(:background))
    end
  end

  context "destroy action" do
    should "destroy model and redirect to index action" do
      background = Background.first
      delete :destroy, :id => background
      assert_redirected_to admin_backgrounds_url
      assert !Background.exists?(background.id)
    end
  end
end
