require 'test_helper'

class Admin::FbErrorsControllerTest < ActionController::TestCase
  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end
  end

  context "show action" do
    should "render show template" do
      get :show, :id => FbError.first
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
      FbError.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end

    should "redirect when model is valid" do
      FbError.any_instance.stubs(:valid?).returns(true)
      post :create
      assert_redirected_to admin_fb_error_url(assigns(:fb_error))
    end
  end

  context "edit action" do
    should "render edit template" do
      get :edit, :id => FbError.first
      assert_template 'edit'
    end
  end

  context "update action" do
    should "render edit template when model is invalid" do
      FbError.any_instance.stubs(:valid?).returns(false)
      put :update, :id => FbError.first
      assert_template 'edit'
    end

    should "redirect when model is valid" do
      FbError.any_instance.stubs(:valid?).returns(true)
      put :update, :id => FbError.first
      assert_redirected_to admin_fb_error_url(assigns(:fb_error))
    end
  end

  context "destroy action" do
    should "destroy model and redirect to index action" do
      fb_error = FbError.first
      delete :destroy, :id => fb_error
      assert_redirected_to admin_fb_errors_url
      assert !FbError.exists?(fb_error.id)
    end
  end
end
