class UserSerializer < ApplicationSerializer
  attributes :id, :username, :name, :email, :created_at, :updated_at

  attribute :verified do
    object.is_verified?
  end

  attribute :enrollments do
    object.enrollments.map do |enrollment|
      {
        course_id: enrollment.course_id,
        role: enrollment.role.name,
        permissions: enrollment.role.permissions.map do |permission|
          "#{permission.subject}/#{permission.action}"
        end
      }
    end
  end
end
