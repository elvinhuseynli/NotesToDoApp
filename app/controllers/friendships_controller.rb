class FriendshipsController < ApplicationController

    def index
        @query = params[:query]
        @users = []
        @sent_requests = []
      
        if @query.present?
            accepted_friend_ids = Friendship.where(senderId: current_user.id, status: "accepted").pluck(:receiverId)
            accepted_friend_ids_1 = Friendship.where(receiverId: current_user.id, status: "accepted").pluck(:senderId)
            received_request_ids = Friendship.where(receiverId: current_user.id, status: "pending").pluck(:senderId)
            
            @users = User.where('email': /#{@query}/)
                        .where.not(id: current_user.id)
                        .reject { |user| accepted_friend_ids.include?(user.id) || accepted_friend_ids_1.include?(user.id) || received_request_ids.include?(user.id) }

            @sent_requests = current_user.friendship.where(status: "pending").pluck(:receiverId)
        end
    end
      

    def send_request
        sender = User.find(params[:senderId])
        receiver = User.find(params[:receiverId])

        Friendship.create(senderId: sender.id, receiverId: receiver.id, status: "pending")
        redirect_to friendships_index_path(notice: 'Friend request sent successfully!')
        
    end

    def friends_list
        requested = Friendship.where(receiverId: current_user.id, status: "accepted").pluck(:senderId)
        sent = Friendship.where(senderId: current_user.id, status: "accepted").pluck(:receiverId)
        friend_ids = requested + sent
        @friends = User.in(id: friend_ids)
    end  
    
    def invitations
        @received_requests = Friendship.where(receiverId: current_user.id, status: "pending")
    end
    
    def accept
        friendship = Friendship.find(params[:id])
        friendship.update(status: "accepted")
        redirect_to friendships_invitations_path(notice: 'Friend request accepted successfully!')
    end
    
    def reject
        friendship = Friendship.find(params[:id])
        friendship.destroy
        redirect_to friendships_invitations_path(notice: 'Friend request rejected successfully!')
    end

end
