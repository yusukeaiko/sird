# -*- coding: utf-8 -*-
# Asia-Pacific Network Information Centre
module Iana
  module Apnic
    TMP = Rails.root.join(TMP_DIR + APNIC_FILE).to_s

    def self.exec()
      if download() then
        update()
      end
    end

    def self.download()
      return parent.download(APNIC_FILE, APNIC_URL)
    end

    def self.update()
      return parent.update(TMP)
    end
  end
end
