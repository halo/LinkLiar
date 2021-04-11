module Macs
  class Vendor
    def initialize(name:)
      @name = name
      @prefixes = []
    end

    def name
      return 'Cisco' if @name == 'Cisco Systems'

      @name
    end

    def to_s
      [name, prefixes.join(' ')].join("\n")
      [name, prefixes.count].join(' – ')
    end

    # def to_swift
    #   ["    // #{name}\n    ", addresses.map(&:to_hex).join(',')].join + ','
    # end

    def add_prefix(prefix)
      prefixes.push prefix.downcase
    end

    def popular?
      return true if name == 'Coca Cola Company' # I think this is just funny
      return true if name == 'Nintendo' # This too, really
      return false if prefixes.count < 3

      popular_names.include?(name)
    end

    def <=>(other)
      other.count <=> count
    end

    def count
      prefixes.count
    end

    private

    attr_reader :prefixes

    def popular_names
      %w[
        Apple
        Fujitsu
      ]
    end
  end
end
