class OrganizationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.where(owner_id: user.id)
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
