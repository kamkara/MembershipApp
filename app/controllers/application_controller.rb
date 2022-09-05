class ApplicationController < ActionController::Base
      #Keep clean Application conroller, moved on noncern
    include DeviseConfiguration

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
        root_path
    end

    def after_sign_in_path_for(resource)
        feed_path
    end

    #User Ombording
    def after_sign_up_path_for(resource)
        feed_path
    end
end
