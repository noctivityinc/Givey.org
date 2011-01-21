require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Donation.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Donation.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Donation.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to donation_url(assigns(:donation))
  end
  
  def test_edit
    get :edit, :id => Donation.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Donation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Donation.first
    assert_template 'edit'
  end

  def test_update_valid
    Donation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Donation.first
    assert_redirected_to donation_url(assigns(:donation))
  end
  
  def test_destroy
    donation = Donation.first
    delete :destroy, :id => donation
    assert_redirected_to donations_url
    assert !Donation.exists?(donation.id)
  end
end
