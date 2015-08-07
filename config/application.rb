class OrigenMemoryImageApplication < Origen::Application
  
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

  # This information is used in headers and email templates, set it specific
  # to your application
  config.name     = "Origen Memory Image"
  config.initials = "OrigenMemoryImage"
  config.rc_url   = "git@github.com:Origen-SDK/origen_memory_image.git"
  config.release_externally = true

  config.web_directory = "git@github.com:Origen-SDK/Origen-SDK.github.io.git/memory_image"
  config.web_domain = "http://origen-sdk.org/memory_image"

  # When false Origen will be less strict about checking for some common coding errors,
  # it is recommended that you leave this to true for better feedback and easier debug.
  # This will be the default setting in Origen v3.
  config.strict_errors = true

  # See: http://origen.freescale.net/origen/latest/guides/utilities/lint/
  config.lint_test = {
    # Require the lint tests to pass before allowing a release to proceed
    run_on_tag: true,
    # Auto correct violations where possible whenever 'origen lint' is run
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
  #  "#{Origen.root}/output/#{$dut.class}"
  #end

  # Similary for the reference files, generally you want to setup the reference directory
  # structure to mirror that of your output directory structure.
  #config.reference_directory do
  #  "#{Origen.root}/.ref/#{$dut.class}"
  #end

  # Run the tests before deploying to generate test coverage numbers
  def before_deploy_site
    Dir.chdir Origen.root do
      #system "origen examples -c"
      system "origen specs -c"
      dir = "#{Origen.root}/web/output/coverage"       
      FileUtils.remove_dir(dir, true) if File.exists?(dir) 
      system "mv #{Origen.root}/coverage #{dir}"
    end
  end
 
  # This will automatically deploy your documentation after every tag
  def after_release_email(tag, note, type, selector, options)
    command = "origen web compile --remote --api"
    Dir.chdir Origen.root do
      system command
    end
  end

  # Ensure that all tests pass before allowing a release to continue
  def validate_release
    if !system("origen specs") #|| !system("origen examples")
      puts "Sorry but you can't release with failing tests, please fix them and try again."
      exit 1
    else
      puts "All tests passing, proceeding with release process!"
    end
  end

end
