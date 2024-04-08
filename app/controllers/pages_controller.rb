require_relative '../services/page_crawler'
  class PagesController < ApplicationController
    def index
      @page = Page.find_or_initialize_by(url: params[:url])
      if @page.new_record?
        crawler = ::PageCrawler.new(@page.url)
        crawler.crawl
      end
      @pages = Page.all
    end
end