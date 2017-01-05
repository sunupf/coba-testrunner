require 'rubygems'
require 'selenium-webdriver'

# Selenium::WebDriver::Firefox.path = "C:\\Program Files (x86)\\Mozilla Firefox\\firefox.exe"
# profile = Selenium::WebDriver::Firefox::Profile.new
driver = Selenium::WebDriver.for :firefox, :profile => "Driver"

start = Time.now
puts "Current Time : " + start.inspect
driver.get "http://google.com"

loaded = Time.now
puts "Current Time : " + loaded.inspect

element = driver.find_element :name => "q"
element.send_keys "Cheese!"
element.submit

puts "Page title is #{driver.title}"

wait = Selenium::WebDriver::Wait.new(:timeout => 10)
wait.until { driver.title.downcase.start_with? "cheese!" }

puts "Page title is #{driver.title}"
# driver.quit
