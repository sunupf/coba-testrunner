require "selenium-webdriver"
require 'fileutils'

class TestRunner
  def initialize(config)
    @config = config
    @driver = ""
    @time = Hash.new
    @index = config['keyIndex']
    @testCase = ""
  end
  def init()
    start = Time.new

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

    finish = Time.new

    logTime "initialize", start, finish
  end
  def start(testCase=nil)
    @testCase = testCase

    beforeExecution

    loadUrl(@config['startingUrl'])

    mainTest(testCase)

    afterExecution
  end
  def stop
    @driver.quit
    @testCase['time'] = @time
    return @testCase
  end
  def config
    @config
  end

  private #Private method dibawah
  def logTime(index,start,finish)
    @time[index] = Hash.new
    @time[index]['start'] = start
    @time[index]['finish'] = finish
    @time[index]['time'] = finish - start
  end
  def loadUrl(url)
    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'loadUrl','start')

    start = Time.new

    if url
      @driver.navigate.to url
    end

    finish = Time.new

    logTime "load", start, finish

    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'loadUrl','finish')
  end
  def mainTest(testCase)
    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'MainExecution','start')

    start = Time.new

    if @config['scenario'] and File.exist?(@config['scenario'])
      load @config['scenario'] #work LOL
      test = Test.new(testCase,@driver).run
      @testCase['assertion'] = test
    end

    finish = Time.new

    logTime "main", start, finish

    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'MainExecution','finish')
  end
  def beforeExecution
    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'PreExecution','load')

    start = Time.new

    if @config['before'] and File.exist?(@config['before'])
      load @config['scenario'] #work LOL
      test = BeforeTest.new(@driver).run
    end

    finish = Time.new

    logTime "before", start, finish

    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'PreExecution','finish')
  end
  def afterExecution
    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'AfterExecution','load')

    start = Time.new

    if @config['after'] and File.exist?(@config['after'])
      load @config['scenario'] #work LOL
      test = AfterTest.new(@driver).run
    end

    finish = Time.new

    logTime "after", start, finish

    takeScreenshot("#{Dir.pwd}/#{@config['browsers']}/#{@index+1}",'AfterExecution','finish')
  end
  def takeScreenshot(folderPath,prefix=nil,sufix=nil)
    if @config['screenshot']
      if !Dir.exist? "#{folderPath}/"
        FileUtils::mkdir_p "#{folderPath}/"
      end
      puts "#{folderPath}/#{prefix}.png"
      @driver.save_screenshot("#{folderPath}/#{prefix}-#{sufix}.png")
    end
  end
end
