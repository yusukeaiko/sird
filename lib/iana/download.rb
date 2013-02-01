# -*- coding: utf-8 -*-
module Iana
  # registryテーブルの情報を元に、IPアドレスリストをそれぞれのレジストラからダウンロード担当するモジュール
  module Download
    # すべてのレジストラからファイルをダウンロードし、一時ディレクトリに格納(起点メソッド)
    # _registry_ :: Registry.allの実行結果を受け取ります。
    # 戻り値 :: すべてのファイルダウンロードが正常終了すれば *true* を返します。
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

    # レジストラが公開しているIPアドレスリストファイルを一時ディレクトリに格納
    # _uri_ :: レジストラが公開しているURL
    # _csv_ :: IPアドレスリストファイルのファイル名
    # 戻り値 :: ダウンロードが正常終了すれば *true* を返します。
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
