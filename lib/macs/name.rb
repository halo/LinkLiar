# Copyright (c) halo https://github.com/halo/LinkLiar
# SPDX-License-Identifier: MIT

module Macs
  class Name
    def initialize(raw)
      @raw = raw
    end

    def to_s
      raw
    end

    def ignore?
      false
    end

    def popular?
      popular_names.include? raw
    end

    private

    attr_reader :raw

    def popular_names
      %w[
        3com
        3comEuro
        Apple
        Broadcom
        Cisco
        D-Link
        D-LinkIn
        Dell
        Fujitsu
        Google
        HewlettP
        HitachiH
        HuaweiTe
        Ibm
        Intel
        IntelCor
        LenovoMo
        LgElectr
        Microsof
        Motorola
        Netgear
        Nintendo
        Nokia
        Realtek
        Roku
        SamsungE
        Shanghai
        Shenzhen
        SiemensC
        SiemensE
        Toshiba
        Tp-LinkT
      ]
    end
  end
end
