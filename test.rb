#!/usr/bin/env ruby

require 'socket'
require 'amqp'

key = "servers.uk.co.bytemark.vm.baa.system.memory.foo"
msg = "438525952 1321027144"

AMQP.start(:host => 'localhost', :port => 5672, :user => 'graphite', :pass => 'gr4ph1t3') do |connection|
  channel  = AMQP::Channel.new(connection)
  exchange = channel.topic('graphite', :durable => true)

  puts "Sending #{key} #{msg}"
  exchange.publish("#{msg}", {:routing_key => key, :durable => true})
end
