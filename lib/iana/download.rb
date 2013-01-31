# -*- coding: utf-8 -*-
module Iana
  module Download
    # レジストラからファイルをダウンロードし、一時ディレクトリに格納
    def self.execute(registry)
      ret = true
      registry.each {|row|
        if !open_data(row.data_uri, row.data_file) then
          ret = false
          break
        end
      }

      return ret
    end

    def self.open_data(uri, csvfile)
      ret = false
      open(TMP_DIR + csvfile, 'w') {|file|
        OpenURI.open_uri(uri + csvfile) {|data|
          file.write(data.read)
          ret = true
        }
      }

      return ret
    end
  end
end
