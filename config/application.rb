class MemoryImageApplication < RGen::Application

  # See http://rgen.freescale.net/rgen/latest/api/RGen/Application/Configuration.html
  # for a full list of the configuration options available

  # RGen will ensure that this plugin only ever runs with this version or higher
  config.min_required_rgen_version = "v2.3.0.dev146"

  config.max_required_rgen_version = "v2.99.99"
  
  # To share resources with the apps that import this plugin uncomment the following attribute:
  #config.shared = {
  # Add the dir/file of patterns that needs to be shared 
  #  patterns: "pattern/shared",
  # Add the file which includes all commands that needs the be shared with the app that imports
  # this plugin in :command_launcher attribute
  #  command_launcher: "config/shared_commands.rb",
  # Shared templates go in the :templates attribute
  #  templates: "templates/shared_templates",
  # Shared programs go in the :programs attributes
  #  programs: "programs/shared"
  #}


  # Plugins can be imported like this:
  config.imports_dev = [
    {
      :vault => "sync://sync-15088:15088/Projects/common_tester_blocks/rgen_blocks/helpers/Doc_Helpers/tool_data/rgen",
      :version => "v1.6.1",
    }
  ]

  # This information is used in headers and email templates, set it specific
  # to your application
  config.name     = "Memory Image"
  config.initials = "Memory_Image"
  config.vault    = "sync://sync-15088:15088/Projects/common_tester_blocks/rgen_blocks/helper/Memory_Image/tool_data/rgen" 

  # To enable deployment of your documentation to a web server (via the 'rgen web'
  # command) fill in these attributes. The example here is configured to deploy to
  # the rgen.freescale.net domain, which is an easy option if you don't have another
  # server already in mind. To do this you will need an account on CDE and to be a member
  # of the 'rgen' group.
  config.web_directory = "/proj/.web_rgen/html/memory_image"
  config.web_domain = "http://rgen.freescale.net/memory_image"

  # When false RGen will be less strict about checking for some common coding errors,
  # it is recommended that you leave this to true for better feedback and easier debug.
  # This will be the default setting in RGen v3.
  config.strict_errors = true

  # See: http://rgen.freescale.net/rgen/latest/guides/utilities/lint/
  config.lint_test = {
    # Require the lint tests to pass before allowing a release to proceed
    run_on_tag: true,
    # Auto correct violations where possible whenever 'rgen lint' is run
    auto_correct: true, 
    # Limit the testing for large legacy applications
    #level: :easy,
    # Run on these directories/files by default
    #files: ["lib", "config/application.rb"],
  }

  config.semantically_version = true

  # By default all generated output will end up in ./output.
  # Here you can specify an alternative directory entirely, or make it dynamic such that
  # the output ends up in a setup specific directory. 
  #config.output_directory do
  #  "#{RGen.root}/output/#{$dut.class}"
  #end

  # Similary for the reference files, generally you want to setup the reference directory
  # structure to mirror that of your output directory structure.
  #config.reference_directory do
  #  "#{RGen.root}/.ref/#{$dut.class}"
  #end

  # Run the tests before deploying to generate test coverage numbers
  def before_deploy_site
    Dir.chdir RGen.root do
      #system "rgen examples -c"
      system "rgen specs -c"
      dir = "#{RGen.root}/web/output/coverage"       
      FileUtils.remove_dir(dir, true) if File.exists?(dir) 
      system "mv #{RGen.root}/coverage #{dir}"
    end
  end
 
  # This will automatically deploy your documentation after every tag
  def after_release_email(tag, note, type, selector, options)
    deployer = RGen.app.deployer
    if deployer.running_on_cde? && deployer.user_belongs_to_rgen?
      command = "rgen web compile --remote --api"
      if RGen.app.version.production?
        command += " --archive #{RGen.app.version}"
      end
      Dir.chdir RGen.root do
        system command
      end
    end 
  end

  # Ensure that all tests pass before allowing a release to continue
  def validate_release
    if !system("rgen specs") #|| !system("rgen examples")
      puts "Sorry but you can't release with failing tests, please fix them and try again."
      exit 1
    else
      puts "All tests passing, proceeding with release process!"
    end
  end

end