# encoding: utf-8

require 'gosu'
require_relative '../NetworkClient.rb'

class GosuClient < Gosu::Window
    SPEED = 2

    def initialize
        super 800, 600, false
        @client = NetworkClient.new 'localhost', 9009
        @client.initialize_attributes ({
            'x' => 300, 
            'y' => 300
        })
        @client.start_recv_thread
        @img = Gosu::Image.new 'ball.png'
    end

    def update
        if button_down?(Gosu::KbLeft)
            @client.increment_attrib('x', -SPEED)
        elsif button_down?(Gosu::KbRight)
            @client.increment_attrib('x', SPEED)
        end

        if button_down?(Gosu::KbUp)
            @client.increment_attrib('y', -SPEED)
        elsif button_down?(Gosu::KbDown)
            @client.increment_attrib('y', SPEED)
        end
    end

    def draw
        if @client.get_attributes.size != 0
            @img.draw @client.get_attrib('x'), @client.get_attrib('y'), 0
        end
    end
end

GosuClient.new.show