require "selenium-webdriver"

class Test
  def initialize(config)
    @config = config
    @driver = ""
  end
  def init()
    case @config['browsers']
    when "firefox"
      @driver = Selenium::WebDriver.for :firefox, :profile => "Driver"
    when "safari"
      @driver = Selenium::WebDriver.for :safari
    when "opera"
      @driver = Selenium::WebDriver.for :opera
    when "chrome"
      @driver = Selenium::WebDriver.for :chrome
    when "ie"
      @driver = Selenium::WebDriver.for :ie
    when "phantomjs"

    else
      puts "Browser you specified not supported yet"
    end
  end
  def start
    @driver.get "http://google.com"
  end
  def stop

  end
  def beforeExecution

  end
  def afterExecution

  end
  def config
    @config
  end
end
