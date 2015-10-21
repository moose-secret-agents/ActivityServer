module LoginHelper
  private
    def http_basic_authenticate
      authenticate_or_request_with_http_basic do |username, password|
        @user = User.try_authenticate_or_retrieve(username, password)
        if @user.nil?
          render json: {status: 'Unauthorized'}, :status => :unauthorized
          return false
        end
        true
      end
    end
end