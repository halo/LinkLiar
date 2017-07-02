module Macs
  class Wireshark
    class Entry
      def initialize(row)
        @row = row.to_s.strip.squish
      end

      def to_s
        [address, name].join ' '
      end

      def ignore?
        comment? || empty? || address.ignore? || name.ignore?
      end

      def address
        Address.new parts.first
      end

      def name
        Name.new parts.second
      end

      private

      attr_reader :row

      def empty?
        row.blank?
      end

      def comment?
        row.start_with? '#'
      end

      def parts
        @parts ||= row.split
      end
    end
  end
end
