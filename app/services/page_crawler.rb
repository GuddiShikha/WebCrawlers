require 'open-uri'
require 'nokogiri'

class PageCrawler
  def initialize(url)
    @url = "https://www.bbc.com/"
  end

  def crawl
    page = Page.find_or_create_by(url: @url)
    crawl_page(page)
  end

  private

  def crawl_page(page, depth = 0)
    puts "Crawling page: #{page.url}, Depth: #{depth}"
    
    return if depth > 10  # Limit maximum depth to avoid infinite recursion
    begin
      html = Nokogiri::HTML(URI.open(page.url))
      # Extract and save assets
      html.css('link[href], script[src], img[src]').each do |element|
        asset_url = element.attribute('href')&.value || element.attribute('src')&.value
        page.assets.create(url: asset_url) unless asset_url.blank?
      end
      
      # Extract and crawl links
      html.css('a').each do |link|
        href = link.attribute('href')&.value
        next if href.blank? || href.start_with?('http') || href.start_with?('https')# Skip external links
        
        absolute_link = URI.join(page.url, href).to_s
        child_page = Page.find_or_create_by(url: absolute_link)
        page.assets.create(url: absolute_link) unless page == child_page
        crawl_page(child_page, depth + 1) unless page == child_page
      end
    rescue StandardError => e
      puts "Error crawling page #{page.url}: #{e.message}"
    end
  end
end
