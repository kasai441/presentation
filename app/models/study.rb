class Study < ApplicationRecord

    def get_list
        seq_keys = seq.map { |key| key.subject }.uniq
        ready_x_months
      end
end
