class Record < ActiveRecord::Base
  validates_numericality_of :start, :greater_than_or_equal_to =>0, :less_than => 24
  validates_numericality_of :duration, :greater_than =>0, :less_than => 24
  validates :date, :presence => true,
                    :format => {:with => /^([0-3][0-9]-[0-1][0-9]-[12][0-9]{3})$/}

  belongs_to :user
  
  scope :users, lambda{ |user_id| where(:user_id => user_id)}
  default_scope order("date ASC")

  # to have method to calculate when working day was ended
  def ends
    start + duration
  end

  # calculates duration and makes all times from string to decimal
  def self.extend_params_with params = {}
    record = params[:record]
    unless record.nil?
      record[:start] = Time::hours_to_numeric(record[:start])
      record[:duration] = Time::hours_to_numeric(record[:duration])
      params[:ends] = Time::hours_to_numeric(params[:ends])

      if params[:ends] >= 0 && record[:duration] == 0
        params[:record][:duration] = params[:ends] - record[:start]
      end
    end
    params
  end


end
