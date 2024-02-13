# Copyright (c) halo https://github.com/halo/LinkLiar
# SPDX-License-Identifier: MIT

module Macs
  module Vendors
    def self.all
      result = {}

      rows do |row|
        vendor = ::Macs::Vendor.new(name: row.last)
        result[vendor.name] ||= vendor
        result[vendor.name].add_prefix row.first
      end

      result.values.select(&:popular?).sort
    end

    def self.as_json
      result = {}

      rows do |row|
        result[row.first] = row.last
      end

      result
    end

    # See https://mac2vendor.com/articles/download
    def self.rows
      URI.open('https://mac2vendor.com/download/vendorMacs.prop') do |file|
        CSV.foreach(file, liberal_parsing: true, col_sep: '=') do |row|
          next if row.first.start_with?('*')
          yield row
        end
      end
    end
    private_class_method :rows
  end
end
