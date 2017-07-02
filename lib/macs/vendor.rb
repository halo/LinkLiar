module Macs
  class Vendor
    def initialize(name)
      @name = name
    end

    def to_s
      [name, addresses.join(' ')].join("\n")
    end

    def to_swift
      ["    // #{name}\n    ", addresses.map(&:to_hex).join(',')].join + ','
    end

    def add(address)
      addresses.push address
    end

    def popular?
      return false if addresses.count < 2
      name.popular?
    end

    def count
      addresses.count
    end

    private

    attr_reader :name

    def addresses
      @addresses ||= []
    end
  end
end
