class Event < ActiveRecord::Base
  belongs_to :family;
  belongs_to :person;

end
