class Friendship
    include Mongoid::Document
    include Mongoid::Timestamps
    field :senderId, type: String
    field :receiverId, type: String
    field :status, type: String
  
    belongs_to :sender, class_name: 'User', foreign_key: 'senderId'
    belongs_to :receiver, class_name: 'User', foreign_key: 'receiverId'
  
end
