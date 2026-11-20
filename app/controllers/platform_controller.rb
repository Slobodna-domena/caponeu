class PlatformController < ApplicationController
  class Platform
  end

  def index
    reset_search_session

    @platform = Class.new do
      def novels
        Novel.order("RANDOM()").limit(12)
      end

      def keywords
        Keyword.order("RANDOM()").limit(6)
      end

      def thematic_collections
        ThematicCollection.order("RANDOM()").limit(2)
      end

      def materials
        Material.order("RANDOM()").limit(6)
      end

      def name
        "Platform"
      end
    end.new
  end

  def show
    @novel = Novel.find(params[:slug])
  end
end
