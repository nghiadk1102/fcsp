class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    case user.role
    when "admin"
      can :manage, User
    else
      can :manage, User, id: user.id
      can :read, User
      can :follow, User
      can :unfollow, User
    end
  end
end
