# -*- coding: utf-8 -*-
class WelcomeController < ApplicationController
  def index
    @versions = StatisticsVersion.all
    @summaries = StatisticsSummary.all
    @records = StatisticsRecord.new

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
