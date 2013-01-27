# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Xay

  # 例外対処
  def rescue_action(e)
    case e
    when NoticeError
      # エラーをログ出力
      logger.warn(e.full_message)
      logger.debug(e.exception) if e.exception
      # エラー画面を表示
      @error = e
      render 'shared/error'
    else
      super
    end
  end
end
