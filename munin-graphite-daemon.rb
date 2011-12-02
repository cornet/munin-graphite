#!/usr/bin/env ruby

require 'daemons'

options = {
  :app_name => 'munin-graphite',
  :dir_mode => :system,
  :log_dir  => '/var/log',
  :log_output => true,
}

Daemons.run('/opt/graphite/munin-graphite/munin-graphite.rb', options)
