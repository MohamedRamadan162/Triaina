class EnrollmentSerializer < ApplicationSerializer
  attributes :id, :course_id

  attribute :user do
    UserSerializer.render(object.user)
  end

  attribute :role do
    RoleSerializer.render(object.role)
  end
end
