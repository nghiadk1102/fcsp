require "rails_helper"

RSpec.describe User, type: :model do
  before(:context) do
    @user1 = FactoryBot.create :user,
      role: "trainee", created_at: Time.now
    @user2 = FactoryBot.create :user,
      role: "trainee", created_at: Time.now + 1.hour
    @user3 = FactoryBot.create :user,
      role: "trainee", created_at: Time.now + 2.hours
    @users = [@user1, @user2, @user3]
    @type = %i(name email role)
  end

  describe "User validation" do
    context "association" do
      it{is_expected.to have_many(:user_groups).dependent :destroy}
      it{is_expected.to have_many(:employer_groups).through :user_groups}
      it{is_expected.to have_many(:candidates).dependent :destroy}
      it{is_expected.to have_many(:images).dependent :destroy}
      it{is_expected.to have_many(:jobs).through :candidates}
      it{is_expected.to have_many(:created_jobs).dependent :destroy}
      it{is_expected.to have_many(:bookmarked_jobs).through :bookmarks}
      it{is_expected.to have_many(:skill_users).dependent :destroy}
      it{is_expected.to have_many(:skills).through :skill_users}
      it{is_expected.to have_many(:user_schools).dependent :destroy}
      it{is_expected.to have_many(:schools).through :user_schools}
      it{is_expected.to have_many(:shares).dependent :destroy}
      it{is_expected.to have_many :share_jobs}
      it{is_expected.to have_many(:user_languages).dependent :destroy}
      it{is_expected.to have_many(:languages).through :user_languages}
      it{is_expected.to have_one(:company).with_foreign_key :creator_id}
      it{is_expected.to have_many(:share_posts).dependent :destroy}
      it{is_expected.to have_many :user_course_subjects}
      it{is_expected.to have_many :user_courses}
      it{is_expected.to have_many(:courses).through :user_courses}
      it{is_expected.to have_many(:online_contacts).dependent :destroy}
      it{is_expected.to have_many(:share_posts).dependent :destroy}
      it{is_expected.to have_one(:avatar).with_foreign_key :id}
      it{is_expected.to have_one(:cover_image).with_foreign_key :id}
      it{is_expected.to have_many(:bookmarks).dependent :destroy}
      it{is_expected.to have_one(:info_user).dependent :destroy}
      it{is_expected.to have_many(:subjects).through :user_course_subjects}
      it{is_expected.to have_many :user_tasks}
      it do
        is_expected.to have_many(:active_shares)
          .with_foreign_key(:user_shared_id).dependent :destroy
      end
      it do
        is_expected.to have_many(:passive_shares)
          .with_foreign_key(:user_share_id).dependent :destroy
      end
      it{is_expected.to have_many(:user_shares).through :active_shares}
      it{is_expected.to have_many(:shared).through :passive_shares}
      it{is_expected.to accept_nested_attributes_for :info_user}
    end

    context "column_specifications" do
      it{is_expected.to have_db_column(:name).of_type :string}
      it{is_expected.to have_db_column(:email).of_type :string}
      it{is_expected.to have_db_column(:company_id).of_type :integer}
      it{is_expected.to have_db_column(:avatar_id).of_type :integer}
      it{is_expected.to have_db_column(:cover_image_id).of_type :integer}
      it{is_expected.to have_db_column(:role).of_type :integer}
      it{is_expected.to have_db_column(:provider).of_type :string}
    end
  end

  describe "validations" do
    it{is_expected.to validate_presence_of :name}

    it do
      is_expected.to validate_length_of(:name)
        .is_at_most Settings.company.max_length_name
    end

    it{is_expected.to validate_presence_of :email}

    it do
      is_expected.to validate_inclusion_of(:auto_synchronize)
        .in_array [true, false]
    end
  end

  describe "#accepts_nested_attributes_for" do
    it do
      is_expected.to accept_nested_attributes_for(:info_user)
        .update_only true
    end
  end

  describe "delegate" do
    it "ambition" do
      is_expected.to delegate_method(:ambition).to(:info_user).with_prefix true
    end

    it "address" do
      is_expected.to delegate_method(:address).to(:info_user).with_prefix true
    end

    it "phone" do
      is_expected.to delegate_method(:phone).to(:info_user).with_prefix true
    end

    it "quote" do
      is_expected.to delegate_method(:quote).to(:info_user).with_prefix true
    end

    it "info_statuses" do
      is_expected.to delegate_method(:info_statuses)
        .to(:info_user).with_prefix true
    end

    it "birthday" do
      is_expected.to delegate_method(:birthday).to(:info_user).with_prefix true
    end

    it "relationship_status" do
      is_expected.to delegate_method(:relationship_status)
        .to(:info_user).with_prefix true
    end

    it "occupation" do
      is_expected.to delegate_method(:occupation)
        .to(:info_user).with_prefix true
    end

    it "country" do
      is_expected.to delegate_method(:country).to(:info_user).with_prefix true
    end

    it "introduction" do
      is_expected.to delegate_method(:introduction)
        .to(:info_user).with_prefix true
    end

    it "gender" do
      is_expected.to delegate_method(:gender).to(:info_user).with_prefix true
    end

    it "id" do
      is_expected.to delegate_method(:id).to(:info_user).with_prefix true
    end
  end

  describe "enumable" do
    it{is_expected.to define_enum_for(:role).with %i(employer trainee admin)}
  end

  describe "testing scope" do
    context "get newest user" do
      let!(:users){User.newest}
      it "returns ordered list" do
        expect(users).to eq [@user3, @user2, @user1]
      end
    end

    context "testing scope recommend" do
      it "syntax sucessfully" do
        qry = User.select("users.id, users.name, users.avatar_id, users.email")
          .limit Settings.recommend.user_limit
        expect(User.recommend).to eq qry
      end
    end

    context "testing scope recommend_job" do
      let!(:job){FactoryBot.create :job}
      qry = User.select("users.id, users.name, users.avatar_id, users.email")
        .includes(:avatar).limit Settings.recommend.user_limit
      it{expect(User.recommend_job job).to eq qry}
    end

    context "testing auto_synchronize" do
      let!(:query){User.want_auto_sync}
      let!(:filter){query.where_values_hash.symbolize_keys}
      let!(:synchronize){{auto_synchronize: true}}

      it{expect(filter).to eq synchronize}
    end

    context "testing filter_trainee_course" do
      let!(:course){FactoryBot.create :course}

      before do
        FactoryBot.create :user_course, user_id: @user1.id,
          course_id: course.id
      end

      it "matching sucessfully" do
        expect(User.left_outer_joins(:courses).filter_trainee_course course.id)
          .to include @user1
      end

      it"non-matching sucessfully" do
        expect(User.left_outer_joins(:courses).filter_trainee_course course.id)
          .not_to include @user2, @user3
      end
    end

    context "testing filter_trainee_programming_language" do
      let!(:programming_language){FactoryBot.create :programming_language}

      let!(:course) do
        FactoryBot.create :course,
          programming_language_id: programming_language.id
      end

      before do
        FactoryBot.create :user_course, user_id: @user1.id,
          course_id: course.id
      end

      it "matching sucessfully" do
        expect(User.left_outer_joins(courses: :programming_language)
          .filter_trainee_programming_language programming_language.id)
          .to include @user1
      end

      it"non-matching sucessfully" do
        expect(User.left_outer_joins(courses: :programming_language)
          .filter_trainee_programming_language programming_language.id)
          .not_to include @user2, @user3
      end
    end

    context "testing scope other_user" do
      it "matching sucessfully" do
        expect(User.other_user @user1.id).to eq [@user2, @user3]
      end

      it "non-matching sucessfully" do
        expect(User.other_user @user1.id).not_to include @user1
      end
    end
  end

  describe "#is_user?" do
    context "when params is unvalid" do
      it{expect(@user1.is_user? nil).to eq false}
    end

    context "when params is valid" do
      it{expect(@user1.is_user? @user1).to eq true}
    end
  end

  describe "#add_share" do
    let!(:user){FactoryBot.create :user}
    it{expect(user.add_share @user1).to eq [@user1]}
  end

  describe "#delete_share" do
    let!(:user){FactoryBot.create :user}

    before do
      user.user_shares << [@user1, @user2, @user3]
      user.delete_share @user1
    end

    it "delete one user_share" do
      expect(user.user_shares).to eq [@user2, @user3]
    end
  end

  describe "#share?" do
    let!(:user){FactoryBot.create :user}
    before{user.user_shares << [@user1, @user2]}

    context "matching sucessfully" do
      it{expect(user.share? @user1).to eq true}
    end

    context "non-matching sucessfully" do
      it{expect(user.share? @user3).to eq false}
    end
  end
end
