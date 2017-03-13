require "selenium-webdriver"

class BeforeTest
  def initialize(testCase,driver)
    @testCase =  testCase
    @driver =  driver
  end
  def run
    # Here some example

    inputs = @testCase['testCases']
    inputs.each do |key,input|
      element = @driver.find_element :css => key
      element.send_keys input
    end

    buttonSubmit = @driver.find_element :css => ".uk-button-primary"
    buttonSubmit.click
    #
    wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    wait.until { @driver.find_element :css => ".uk-alert" }
    #
    # puts "Page title is #{@driver.title}"
  end
end
