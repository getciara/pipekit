module Pipekit
  class Client
    module Activities
      def create_activity(activity)
        post('/activities', { body: activity.to_json })
      end

      def activities(options = {})
        get('/activities', { query: options })
      end

      def activity(activity_id)
        get("/activities/#{activity_id}")
      end

      def update_activity(activity_id, activity)
        activity[:id] = activity_id
        put("/activities/#{activity_id}", { body: activity.to_json })
      end
    end
  end
end
