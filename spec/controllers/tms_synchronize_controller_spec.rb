require "rails_helper"

RSpec.describe TmsSynchronizeController, type: :controller do
  let(:user) {FactoryGirl.create :user, email: "bui.khanh.huyen@framgia.com", auto_synchronize: false}
  before {WebMock.allow_net_connect!}
  after {WebMock.disable_net_connect!}
  before(:each) {sign_in user}

  describe "GET #index" do
    it "returns http redirect" do
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "POST #auto sync" do
    it "update sucessfully" do
      post :auto_synchronize, params: {auto_synchronize: true}
      expect(controller).to set_flash[:success]
        .to(I18n.t "tms_synchronize.auto_synchronize_success")
    end

    it "update error" do
      post :auto_synchronize, params: {auto_synchronize: nil}
      expect(controller).to set_flash[:error]
        .to(I18n.t "tms_synchronize.auto_synchronize_error")
    end
  end
end
