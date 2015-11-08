require 'active_record'

class Labels < ActiveRecord::Base
  def self.add(labels, note_id)
    labels = labels.split(',')
    labels.each do |label|
      Labels.create(
        note_id: note_id,
        label: label.strip
      )
    end
  end
end
