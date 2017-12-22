require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @chef = Chef.create!(chefname: "michael", email: "burtm@fordav.com",
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "mike", email: "mike@example.com",
                            password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "mike2", email: "mike2@example.com",
                            password: "password", password_confirmation: "password", admin: true)                    
  end
  
  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "burtm@fordav.com" }}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "michael1", email: "burtm1@fordav.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "michael1", @chef.chefname
    assert_match "burtm1@fordav.com", @chef.email
    
  end
  
  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "michael3", email: "burtm3@fordav.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "michael3", @chef.chefname
    assert_match "burtm3@fordav.com", @chef.email
  end
  
  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email }}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "michael", @chef.chefname
    assert_match "burtm@fordav.com", @chef.email
  end
  
end
