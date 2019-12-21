module CommonAws
  extend ActiveSupport::Concern

  def update_instances(instances)
    update_instances = Instance.import! instances, on_duplicate_key_update: [:updated_at]
    # binding.pry
  end

  
end