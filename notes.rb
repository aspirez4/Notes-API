require 'active_record'

class Notes < ActiveRecord::Base
  def self.retrieve_element(id)
    note = Notes.find_by(note_id: id)

    return nil if note.nil?

    labels = Labels.where(:note_id => note.note_id).pluck(:label)
    note = note.attributes
    note[:labels] = labels

    return note
  end

  def self.retrieve_all
    result = [];
    Notes.all.each do |note|
      note = self.retrieve_element(note.note_id)
      result << note
    end

    return result
  end
end