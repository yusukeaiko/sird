# -*- coding: utf-8 -*-
# African Network Information Centre
module Iana
  module Afrinic
    TMP = Rails.root.join(TMP_DIR + AFRINIC_FILE).to_s

    def self.exec()
      if download() then
        update()
      end
    end

    def self.download()
      return parent.download(AFRINIC_FILE, AFRINIC_URL)
    end

    def self.update()
      return parent.update(TMP)
    end
  end
end
