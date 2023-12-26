# Copyright (c) halo https://github.com/halo/LinkLiar
# SPDX-License-Identifier: MIT

module Macs
  class Vendor
    def initialize(name:)
      @name = name
      @prefixes = []
    end

    def name
      return 'Cisco' if @name == 'Cisco Systems'
      return 'Huawei' if @name == 'Huawei Technologies'
      return 'Samsung' if @name == 'Samsung Electronics'
      return 'HP' if @name == 'Hewlett Packard'
      return 'TP-Link' if @name == 'TP-LINK Technologies'
      return 'LG' if @name == 'Lg Electronics Mobile Communications'
      return 'Vivo' if @name == 'Vivo Mobile Communication'
      return 'Asustek' if @name == 'Asustek Computer'
      return 'Sony' if @name == 'Sony Mobile Communications'
      return 'Motorola' if @name == 'Motorola Mobility Llc A Lenovo Company'
      return 'D-link' if @name == 'D-link International'
      return 'Xiaomi' if @name == 'Xiaomi Communications'

      @name
    end

    def id
      return 'cocacola' if name.include?('Coca')

      name.gsub(/[^0-9a-z ]/i, '').downcase.split.first
    end

    def to_s
      [name, id, prefixes.count].join(' – ')
    end

    def to_swift
      # E.g. `"ibm": ["IBM": [0x3440b5,0x40f2e9,0x98be94,0xa897dc]],`
      %|      // #{@name}   #{prefixes.join(',')}| + "\n" +
        %|      "#{id}": ["#{name}": [#{prefixes.map { "0x#{_1.to_i(16).to_s(16).to_s.rjust(6, '0')}" }.join(',')}]],|
    end

    def add_prefix(prefix)
      prefixes.push prefix.downcase
    end

    def popular?
      return true if name == 'Coca Cola Company' # I think this is just funny
      return true if name == 'Nintendo' # This too, really

      return true if name == '3com'
      return true if name == 'HTC'
      return true if name == 'Ibm'
      return true if name == 'Ericsson'

      return false if denylist.any? { name.include?(_1) }
      return false if name == 'Huawei Device' # Honestly don't know what it is

      return true if prefixes.count > 50
    end

    def <=>(other)
      other.count <=> count
    end

    def count
      prefixes.count
    end

    private

    attr_reader :prefixes

    # Excluding what naturally could not be a MacBook.
    def denylist
      %w[
        Arris
        IEEE
        Foxconn
        Juniper
        Fiberhome
        Sagemcom
        Private
        Guangdong
        Nortel
        Amazon
        Ruckus
        Technicolor
        Liteon
        Avaya
        Espressif
      ]
    end
  end
end
