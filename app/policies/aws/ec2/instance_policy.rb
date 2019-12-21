class Aws::EC2::InstancePolicy < ApplicationPolicy
  def visible?
    binding.pry
    true
  end

  class Scope < Scope
    def resolve
      binding.pry
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
