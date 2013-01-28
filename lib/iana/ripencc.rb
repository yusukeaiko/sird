# -*- coding: utf-8 -*-
# RIPE Network Coordination Centre
module Iana
  module Ripencc
    TMP = Rails.root.join(TMP_DIR + RIPENCC_FILE).to_s

    def self.exec()
      if download() then
        update()
      end
    end

    def self.download()
      return parent.download(RIPENCC_FILE, RIPENCC_URL)
    end

    def self.update()
      return parent.update(TMP)
    end
  end
end
