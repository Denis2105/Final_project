class MainController < ApplicationController

  def index
    agent = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
    }

    page = agent.get('https://www.ozbargain.com.au/')
    body = Nokogiri::HTML(page.body)
    # binding.pry

    Bargain.destroy_all

    body.css('.node').each do |bargain|

      title = bargain.css('h2 a').text
      linkNode = bargain.css('.title a').attr('href')
      link = 'https://www.ozbargain.com.au' + linkNode
      description = bargain.css('.content p').text

      bargains = []

      if bargain.css('.right img')[0]
        image_url = bargain.css('.right img')[0]['src']
      else
        image_url = nil
      end


      @bargain = Bargain.new
      @bargain.title = title
      @bargain.description = description
      @bargain.image_url = image_url
      @bargain.bargain_url = link
      @bargain.save

    end

    @bargains = Bargain.all
    # puts title
    # puts description
    # puts image_url
    # puts ""
    render :index
  end

  def results

    @search = params[:search]

  end


end

# render json: @bargain.to_json
# scrape ozbargain using the search key from params
# save it to your db
