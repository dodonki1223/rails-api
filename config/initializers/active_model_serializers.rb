# initializers フォルダ配下のファイルはサーバーが再起動するたびに実行される
# 出力形式を json:api の形にする設定
ActiveModelSerializers.config.adapter = :json_api
