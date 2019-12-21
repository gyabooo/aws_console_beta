class AwsAccount < ApplicationRecord
  belongs_to :organization

  delegate :name, to: :organization, prefix: :org, allow_nil: true
end
