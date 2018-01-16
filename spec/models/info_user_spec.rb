require "rails_helper"

RSpec.describe InfoUser, type: :model do
  before(:context) do
    @info_user = FactoryBot.create :info_user
    @type = %i(quote phone address introduction gender birthday
      occupation relationship_status ambition country)
  end

  describe "InfoUser validation" do
    context "column_specifications" do
      it{is_expected.to have_db_column(:introduction).of_type :string}
      it{is_expected.to have_db_column(:quote).of_type :string}
      it{is_expected.to have_db_column(:ambition).of_type :string}
      it{is_expected.to have_db_column(:relationship_status).of_type :integer}
      it{is_expected.to have_db_column(:phone).of_type :string}
      it{is_expected.to have_db_column(:address).of_type :string}
      it{is_expected.to have_db_column(:gender).of_type :integer}
      it{is_expected.to have_db_column(:birthday).of_type :datetime}
      it{is_expected.to have_db_column(:occupation).of_type :string}
      it{is_expected.to have_db_column(:country).of_type :string}
      it{is_expected.to have_db_column(:is_public).of_type :boolean}
      it{is_expected.to have_db_column(:user_id).of_type :integer}
    end

    context "associations" do
      it{is_expected.to belong_to :user}
    end
  end

  describe "validations" do
    it do
      is_expected.to validate_length_of(:introduction)
        .is_at_most Settings.info_users.max_length_introduce
    end

    it do
      is_expected.to validate_length_of(:ambition)
        .is_at_most Settings.info_users.max_length_ambition
    end

    it do
      is_expected.to validate_length_of(:quote)
        .is_at_most Settings.info_users.max_length_quote
    end
  end

  describe "testing scope" do
    it do
      expect(InfoUser::INFO_ATTRIBUTES).to eq %i(introduction ambition
        portfolio award work education link project certificate
        language skill)
    end

    it do
      is_expected.to define_enum_for(:gender)
        .with %i(male female other)
    end

    it do
      is_expected.to define_enum_for(:relationship_status)
        .with %i(single married complicated)
    end
  end
end
