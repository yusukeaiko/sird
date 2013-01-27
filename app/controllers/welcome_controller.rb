# coding: utf-8
class WelcomeController < ApplicationController
  def index
    registry = 'apnic'
    @versions = ApnicVersion.find_by_registry(registry)
    @summaries = ApnicSummary.all
    @records = ApnicRecord.new
    
=begin
    @data = ApnicVersion.find(params[:id])
    unless @data.value == "valid"
      # オプション値を指定してエラーメッセージを生成
      raise NoticeError.new(:ERR_002, {:name => 'トップページ'}, 'データが不正です。')
    end
    
  rescue ActiveRecord::RecordNotFound => e
    # 開発者向け例外をユーザ表示用例外に変える。
    raise NoticeError.new(:ERR_001, {}, nil, e)
=end
  end
end
