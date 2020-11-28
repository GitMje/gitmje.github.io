Write-Verbose "Install Ruby"
#choco.exe Install -y ruby --params "/InstallDir:c:\apps\ruby" --version 2.5.1.2 

Write-Verbose "Install bundler gem"
#gem install bundler --version 1.16.3

Write-Verbose "Install bundler"
#bundle install

Write-Verbose "Test site"
#bundle exec jekyll serve