# -*- coding: utf-8 -*-
# Latin American and Caribbean Internet Address Registry
module Iana
  module Lacnic
    TMP = Rails.root.join(TMP_DIR + LACNIC_FILE).to_s

    def self.exec()
      if download() then
        update()
      end
    end

    def self.download()
      return parent.download(LACNIC_FILE, LACNIC_URL)
    end

    def self.update()
      return parent.update(TMP)
    end
  end
end
