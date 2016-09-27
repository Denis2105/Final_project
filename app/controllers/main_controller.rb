class MainController < ApplicationController

  def index
    agent = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
    }

    page = agent.get('https://www.ozbargain.com.au/')
    body = Nokogiri::HTML(page.body)

    Bargain.destroy_all

    page_number = 1

    loop do

      body.css('.node-ozbdeal').each do |bargain|

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

        # saving new bargains into db scrapped from the site
        @bargain = Bargain.new
        @bargain.title = title
        @bargain.description = description
        @bargain.image_url = image_url
        @bargain.bargain_url = link
        @bargain.save

      end

      # goes to the next page after the first loop ends and so forth
      page_number += 1
      # bot looks for the next page number in a text
      next_link = page.links_with(:text => page_number.to_s)[0]
      # need a way out of the loop
      break if next_link == nil
      # bot clicks on the next_link after sucessfully searching for it
      body = next_link.click

    end

    @bargains = Bargain.all
    # puts title
    # puts description
    # puts image_url
    # puts ""
    render :index
  end

  def results

    # search method that redirects user to results site
    search = params[:search]

    # "%" + search + "%" prevents user from accessing our database via the search function, safety measures from hackers
    # ilike searches case insensitive keywords
    @bargain_results = Bargain.where("title ilike ? ", "%#{search}%")

  end

end
