# -*- coding: utf-8 -*-
# American Registry for Internet Numbers
module Iana
  module Arin
    TMP = Rails.root.join(TMP_DIR + ARIN_FILE).to_s

    def self.exec()
      if download() then
        update()
      end
    end

    def self.download()
      return parent.download(ARIN_FILE, ARIN_URL)
    end

    def self.update()
      return parent.update(TMP)
    end
  end
end
