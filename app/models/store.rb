class Store < ActiveRecord::Base
  attr_accessible :phone, :name, :slogan, :status, :location, :city, :country, :latitude, :longitude, :hours

  belongs_to :category
  has_and_belongs_to_many :tags
end
