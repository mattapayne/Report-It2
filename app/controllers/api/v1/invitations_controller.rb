module Api
  module V1
    class InvitationsController < ApiController
      before_action :construct_search_params, only: [:index]
      before_action :load_invitation, only: [:destroy, :accept, :reject]
            
      def index
        results = SearchResults::InvitationSearchResults.new(current_user.get_invitations(@search))
        render json: results, serializer: PagedInvitationsSerializer
      end
      
      def create
        #TODO - Move this logic out of the controller
        #TODO - Need to check for validation errors and errors where the invitee might already be invited.
        emails = params_for_invitation[:emails]
        message = params_for_invitation[:message]
        if emails.present? && !emails.empty?
          invitations = []
          emails.uniq.each do |email|
            user = User.find_by(email: email)
            if user.present?
              invitations << current_user.invite_to_associate!(user, message)
            else
              invitations << current_user.invite_to_associate_with_new_user!(email, message)
            end
          end
          queue_invitation_notifications(invitations)
          render json: { messages: ["Successfully send invitations to #{get_invitee_emails(invitations)}."]}
        else
          render json: { messages: ['No emails have been supplied.']}, status: 406
        end
      end
      
      def destroy
        if @invitation.destroy
          render json: { messages: ["Successfully deleted the invitation to #{@invitation.invitee_email}."] }
        else
          render json: { messages: @invitation.errors.full_messages }, status: 406
        end
      end
      
      def accept
        associate = @invitation.inviter
        if @invitation.update_attribute(:status, :accepted)
          current_user.associate_with!(associate)
          render json: { messages: ["You are now associated with #{associate.full_name}."] }
        else
          render json: { messages: @invitation.errors.full_messages }, status: 406
        end
      end
      
      def reject
        if @invitation.update_attribute(status: :rejected)
          render json: { messages: ["You have rejected the invitation from #{associate.full_name}."] }
        else
          render json: { messages: @invitation.errors.full_messages }, status: 406
        end
      end
      
      private
      
      def load_invitation
        @invitation = AssociateInvitation.find(params[:id])
        unless @invitation.present? && (@invitation.sent_by?(current_user) || @invitation.sent_to?(current_user))
          render_not_allowed_json_response("You do not have access to that invitation.") and return
        end
      end
      
      def construct_search_params
        @search = SearchParams::InvitationSearchParams.new(params.dup)
      end
      
      def get_invitee_emails(invitations)
        invitations.map(&:invitee_email).join(", ")
      end
      
      def queue_invitation_notifications(invitations)
        #send email here
      end
      
      def params_for_invitation
        params.require(:invitation).permit(:message, emails: [])
      end
      
    end
  end
end
