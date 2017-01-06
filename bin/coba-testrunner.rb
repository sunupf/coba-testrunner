require "thor"
require "json"
require "./testRunner"

class Coba < Thor
  desc "test configFile [browser]", "Testing based on configFile and/or specific Browser"
  long_desc <<-LONGDESC
    coba test will test your test suite agains specific browser and input

    You can optionally specify browser and this browser will override browser that you specify
    on configFile

    ex :\n
    > $./coba test configFile.json\n
    > $./coba test configFile.json firefox
  LONGDESC
  def test(configFile, browser=nil)
    puts "Testing based on #{configFile}"

    # 1. read configFile
    # error when not found
    # error when json not valid

    if File.exist?(configFile)
      file = File.read(configFile)
    else
      raise "File #{configFile} doesn't exist"
    end

    config = JSON.parse(file)

    # 2. get test Cases
    # error when not found
    # error when json not valid

    if File.exist?(config['data'])
      testFile = File.read(config['data'])
    else
      raise "File #{config['data']} doesn't exist"
    end

    testCases = JSON.parse(testFile)

    # 3. get browser
    # isArray? isString?
    # String push ke array
    # Array loop
    arrayOfBrowser = Array.new
    if config['browsers'].instance_of? String
      arrayOfBrowser << config['browsers'];
    else
      arrayOfBrowser = config['browsers'];
    end

    arrayOfBrowser.each_with_index do |browser,index|
      # 4. Create config for single browser
      singleBrowserConfig = config;
      singleBrowserConfig["browsers"] = browser

      # variable untuk menyimpan hasil
      logs = Array.new

      # 5. Loop Test Cases hasil generate
      testCases.each_with_index do |testCase,testIndex|
        # 5. Create object Test
          singleBrowserConfig['keyIndex'] = testIndex
          test = TestRunner.new(singleBrowserConfig)

          # - init
            test.init()
            # driver init

            # screenshot after init (if config set to true)
          # - start
            test.start(testCase)
            # - before Hook (if available)
              # Log Time
              # screenshot before and after test (if config set to true)
            # - Execution
              # Log Time
              # screenshot before and after test (if config set to true)
            # - after Hook (if available)
              # Log Time
              # screenshot before and after test (if config set to true)
          # - stop
            result = test.stop()
            # driver quit

          # compose result
          logs.push(result)
      end

      # 6. Ketika selesai atau throw error save log (JSON) ke dalam sebuah file dengan alamat cwd()+log+browserName
      logPath = "#{Dir.pwd}/#{browser}"
      if !Dir.exist? "#{logPath}/"
        FileUtils::mkdir_p "#{logPath}/"
      end

      File.open("#{logPath}/#{browser}.json","w") do |f|
        f.write(JSON.pretty_generate logs)
      end
    end


  end


  desc "generate type", "Generate data for testing purpose"
  long_desc <<-LONGDESC
    coba generate will generate data for your test suite base on validation rule/something else :p

    ex :\n
    > $./coba generate input\n
    > $./coba generate output
  LONGDESC
  def generate(type)
    puts "Generate on #{type} data"
  end
end

Coba.start(ARGV)
