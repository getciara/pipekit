module Pipekit
  class Client
    module Deals
      def create_deal(deal)
        post('/deals', { body: activity.to_json })
      end

      def deals(options = {})
        get('/deals', { query: options })
      end

      def deals_by_name(name, options = {})
        options[:term] = name
        get('/deals/find', { query: options })
      end

      def deal(deal_id)
        get("/deals/#{deal_id}")
      end

      def deal_activities(deal_id, options = {})
        get("/deals/#{deal_id}/activities", { query: options })
      end

      def deal_files(deal_id, options = {})
        get("/deals/#{deal_id}/files", { query: options })
      end

      def deal_followers(deal_id, options = {})
        get("/deals/#{deal_id}/followers", { query: options })
      end

      def deal_participants(deal_id, options = {})
        get("/deals/#{deal_id}/participants", { query: options })
      end

      def deal_people(deal_id, options = {})
        get("/deals/#{deal_id}/persons", { query: options })
      end

      def update_deal(deal_id, deal)
        deal[:id] = deal_id
        put("/activities/#{deal_id}", { body: deal.to_json })
      end
    end
  end
end
