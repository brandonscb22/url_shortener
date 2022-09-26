class Link < ApplicationRecord
  has_many :link_histories , dependent: :delete_all
  validates :url, format: {
    with: /(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/i,
    message: "only supports valid links"
  }, :allow_blank => false
end
