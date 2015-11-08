require 'active_record'
require 'pp'

class Notes < ActiveRecord::Base
  def self.retrieve_element(id)
    note = Notes.find_by(note_id: id)

    return nil if note.nil?

    labels = Labels.where(note_id: note.note_id).pluck(:label)
    note = note.attributes
    note[:labels] = labels

    note
  end

  def self.retrieve_elements(notes)
    result = []
    notes.each do |note|
      result << Notes.retrieve_element(note)
    end

    result
  end

  def self.retrieve_all
    # Will retrieve max 1000 rows!
    result = []
    Notes.all.find_each do |note|
      note = retrieve_element(note.note_id)
      result << note
    end

    result
  end

  def self.search_with_label(params)
    # Ugly as hell :(
    notes = Notes.find_by_sql(
      [ 'SELECT DISTINCT N.note_id ' \
        'FROM notes AS N, labels as L ' \
        'WHERE (N.title LIKE ? AND N.content LIKE ? ) ' \
        'AND (L.note_id = N.note_id) AND (L.label LIKE ? )',
        "%#{params['title']}%",
        "%#{params['content']}%",
        "%#{params['label']}%"
      ]
    )
    notes.empty? ? nil : retrieve_elements(notes)
  end

  def self.search_title_content(params)
    notes = Notes.find_by_sql(
      ['SELECT note_id FROM notes WHERE '\
       '(title LIKE ? AND content LIKE ? )',
       "%#{params['title']}%",
       "%#{params['content']}%"
      ]
    )
    notes.empty? ? nil : retrieve_elements(notes)
  end

  def self.search(par)
    par.key?('label') ? search_with_label(par) : search_title_content(par)
  end
end
