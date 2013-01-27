# coding: utf-8
module Xay
  module Exceptions
    # エラー通知用例外
    class NoticeError < XayError
      attr_reader :code, :detail, :exception
      
      # 例外生成メソッド
      # code:: メッセージコード名
      # options:: メッセージ文字列生成時のオプション
      # detail:: 詳細メッセージ文字列
      # exception:: 関連する例外オブジェクト
      def initialize(code, options = {}, detail = nil, exception = nil)
        @code = code
        @detail = detail
        @exception = exception
        message = I18i.t("xay.error.#{code}", options)
        super "[#{code.upcase}] #{message}"
      end
      
      # 詳細を含むメッセージ文字列
      def full_message
        str = self.to_s
        str << " : #{detail}" unless detail.blank?
        str
      end
    end
  end
end
