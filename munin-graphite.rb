#!/usr/bin/env ruby

require 'rubygems'
require 'munin-ruby'
require 'bunny'

munin = Munin::Node.new

metric_base = "servers"

all_metrics = Array.new

while true

  munin.nodes.each do |node|
    munin.list(node).each do |service|
      munin.fetch(service).each do |metrics|

        metrics[1].each do |k,v|

          msg = "%s.%s.%s.%s %s %d" % [
            metric_base,
            node.split('.').reverse.join('.'), # Reverse hostname parts
            service,
            k,
            v.to_s,
            Time.now.utc.to_i
          ]

          all_metrics << msg

        end
      end
    end
  end

  bunny = Bunny.new(
    :host    => 'localhost',
    :user    => 'graphite',
    :pass    => 'gr4ph1t3',
    :logging => false,
  )

  bunny.start

  exch = bunny.exchange("graphite", :type => "topic", :durable => true)

  all_metrics.each do |metric|
    puts "Sending #{metric}"
    exch.publish(metric)
  end

  bunny.stop

  sleep 60

end
