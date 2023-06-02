require_relative './base'
require_relative './commit'

module GitRecord
  module GithubApi
    class Reference < Base
      attribute :ref, :string
      attribute :sha, :string
      attribute :url, :string
      attribute :node_id, :string

      attribute :repo_full_name
      attribute :_payload, :hash

      def initialize(**payload)
        attributes = payload.reject{ |k,v| !Reference.attribute_names.include?(k.to_s) }

        super(attributes)

        self.sha = payload["object"]["sha"]
        self._payload = payload
      end

      def self.find(ref, repo_full_name)        
        payload = self.client.get("/repos/#{repo_full_name}/git/ref/#{ref}")

        payload[:repo_full_name] = repo_full_name

        self.new(**payload)
      end

      def commit
        Commit.find(sha, repo_full_name)
      end
    end
  end
end