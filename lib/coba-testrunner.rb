require "selenium-webdriver"
require 'fileutils'
require "csv"

class TestRunner
  def initialize(config)
    @config = config
    @driver = ""
    @time = Hash.new
    @index = 0
    @testCase = ""
    # @screenshotPath = "#{Dir.pwd}/log/#{@config['browsers']}/#{@config['screenshotPath']}/#{@index+1}"
    @screenshotPath = ""
  end
  def index=(index)
    @index = index
    @screenshotPath = "#{Dir.pwd}/log/#{@config['browsers']}/screenshot/#{@index+1}"
  end
  def init(port , marionettePort = 0)
    start = Time.new

    # Selenium::WebDriver.logger.level = :debug
    # Selenium::WebDriver.logger.level = :debug
    case @config['browsers']
    when "firefox"
      profile = Selenium::WebDriver::Firefox::Profile.new
      options = Selenium::WebDriver::Firefox::Options.new
      # options.add_argument("-private")
      options.add_argument("--new-instance")
      options.add_argument("--marionette-port=#{marionettePort}")
      options.profile = profile
      @driver = Selenium::WebDriver.for :firefox, options: options , :port => port
    when "phantomjs"
      @driver = Selenium::WebDriver.for :phantomjs, :port => port
    when "chrome"
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--incognito")
      @driver = Selenium::WebDriver.for :chrome,  options: options, :port => port
    when "iexplore"
      caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer(
        'ie.ensureCleanSession' => true,
        'ie.forceCreateProcessApi' => true, 
        'ie.browserCommandLineSwitches' => '-private'
        )
      @driver = Selenium::WebDriver.for(:internet_explorer, :desired_capabilities => caps, :port => port)
    when "safari"
      # opts = Selenium::WebDriver::Safari::Options.new
      # opts.add_extension "#{Dir.pwd}/../selenium/SafariDriver.safariextz"
      @driver = Selenium::WebDriver.for :safari
    when "opera"
      Selenium::WebDriver::Chrome.driver_path = "#{Dir.pwd}/../selenium/operadriver.exe"
      @driver = Selenium::WebDriver.for :chrome
      # @driver = Selenium::WebDriver.for :ie
    else
      puts "Browser you specified not supported yet"
    end


    finish = Time.new

    logTime "initialize", start, finish

    max_width, max_height = @driver.execute_script("return [window.screen.availWidth, window.screen.availHeight];")
    @driver.manage.window.move_to(0, 0)
    @driver.manage.window.resize_to(max_width, max_height)
  end

  def writeLog
    Selenium::WebDriver.logger.output = 'selenium.log'  
  end
  def start(testCase=nil)
    @testCase = testCase

    if(@config['overrideConfig'] === true)
      @config = overrideConfig(@config,@testCase)
    end

    beforeExecution

    loadUrl(@config['startingUrl'])

    mainTest(testCase)

    afterExecution
  end
  def stop
    # @driver.manage.delete_all_cookies
    # @driver.quit
    @testCase['time'] = @time
    puts "====================== Clearing Cookies : Test Case Number #{@index+1}"
    return @testCase
  end
  def end
    @driver.quit
    puts "====================== Finish : Test Case Number #{@index+1}"
  end
  def config
    @config
  end

  private #Private method dibawah
  def overrideConfig(config,testCases)
    config['startingUrl'] = testCases['testCases']['startingUrl'];
    return config;
  end
  def logTime(index,start,finish)
    @time[index] = Hash.new
    @time[index]['start'] = start
    @time[index]['finish'] = finish
    @time[index]['time'] = finish - start
  end
  def loadUrl(url)
    puts "- Load Url - #{@index+1}"
    takeScreenshot(@screenshotPath,'loadUrl','start')

    start = Time.new

    if @config['before'] and File.exist?(@config['before']) and !url.nil?
      @driver.navigate.to url
    elsif !url.nil?
      @driver.get url
    end

    finish = Time.new

    logTime "load", start, finish

    takeScreenshot(@screenshotPath,'loadUrl','finish')
  end
  def mainTest(testCase)
    puts "- Executing Main Test - #{@index+1}"
    takeScreenshot(@screenshotPath,'MainExecution','start')

    start = Time.new

    if @config['scenario'] and File.exist?(@config['scenario'])
      load "#{Dir.pwd}/#{@config['scenario']}" #work LOL
      mainTest = Test.new(testCase,@driver).run
      @testCase['assertion'] = mainTest
    end

    finish = Time.new

    logTime "main", start, finish

    takeScreenshot(@screenshotPath,'MainExecution','finish')
  end
  def beforeExecution
    puts "- Executing Pre Script - #{@index+1}"
    takeScreenshot(@screenshotPath,'PreExecution','load')
    start = Time.new

    if @config['before'] and File.exist?(@config['before'])
      load "#{Dir.pwd}/#{@config['before']}" #work LOL
      beforeTest = BeforeTest.new(@testCase,@driver).run
    end

    finish = Time.new

    logTime "before", start, finish

    takeScreenshot(@screenshotPath,'PreExecution','finish')
  end
  def afterExecution
    puts "- Executing After Execution Script - #{@index+1}"
    takeScreenshot(@screenshotPath,'AfterExecution','load')

    start = Time.new

    if @config['after'] and File.exist?(@config['after'])
      load "#{Dir.pwd}/#{@config['after']}"
      afterTest = AfterTest.new(@testCase,@driver).run
    end

    finish = Time.new

    logTime "after", start, finish

    takeScreenshot(@screenshotPath,'AfterExecution','finish')
  end
  def takeScreenshot(folderPath,prefix=nil,sufix=nil)
    if !@config['screenshot'].nil?
      if !Dir.exist? "#{folderPath}/"
        FileUtils::mkdir_p "#{folderPath}/"
      end
      # @driver.save_screenshot("#{folderPath}/#{prefix}-#{sufix}.png")
      picture = @driver.screenshot_as :png
      File.open("#{folderPath}/#{prefix}-#{sufix}.png","wb") do |f|
        f.write(picture)
      end
    end
  end
end
