class Todo < ActiveRecord::Base
  validates_numericality_of :time, :greater_than_or_equal_to =>0, :less_than => 24
  validates_presence_of :title

  belongs_to :user

  scope :users, lambda{ |user_id| where(:user_id => user_id)}
  default_scope order("date ASC")
end
