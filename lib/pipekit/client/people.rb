module Pipekit
  class Client
    module People
      def create_person(person_name, person)
        person[:name] = person_name
        post("/persons/#{person_name}", { body: person.to_json })
      end

      def update_person(person_id, person)
        person[:id] = person_id
        put("/persons/#{person_id}", { body: person.to_json })
      end

      def people(options = {})
        get('/persons', { query: options })
      end

      def person_by_id(id, options = {})
        get("/persons/#{id}", { query: options })
      end

      def people_by_name(name, options = {})
        options[:term] = name
        options[:search_by_email] = 0
        get('/persons/find', { query: options })
      end

      def people_by_email(email, options = {})
        options[:term] = email
        options[:search_by_email] = 1
        get('/persons/find', { query: options })
      end

      def person_activities(person_id, options = {})
        get("/persons/#{person_id}/activities", { query: options })
      end

      def person_deals(person_id, options = {})
        get("/persons/#{person_id}/deals", { query: options })
      end
    end
  end
end
