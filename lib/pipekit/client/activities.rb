module Pipekit
  class Client
    module Activities
      def create_activity(activity)
        post('/activities', { body: activity.to_json })
      end

      def activities(options = {})
        get('/activities', { query: options })
      end

      def update_activity(activity_id, activity)
        activity[:id] = activity_id
        put("/engagements/v1/engagements/#{activity_id}", { body: activity.to_json })
      end
    end
  end
end
