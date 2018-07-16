# rails-ecs

Rails on ECSを試してみるテスト

* Rails 5.2.0
* ECS
* Fargate
* RDS
* AWS CodeBuild

# ECS + Rails + Fargate + RDS

## タスク定義

• 割り振ったタスクサイズ(メモリ, CPU)に収まるようにコンテナないCPUユニット数は当てる
• コマンドはbundle,exec,puma
• 作業ディレクトリは/app
• ポートマッピングはホストポート80/コンテナポート80/プロトコルtcp
• DATABASE_URL,PORT,RAILS_ENVを環境変数で置いた
  • 今回はコンテナの定義で書いたけどもうちょっといい感じにできるかなぁ

## サービス

• ALBがないと外からアクセスするためのエンドポイントがなさそう
• 負荷分散用のコンテナは80番
  • コンテナの80でpumaを立たせておいてそれを見に行く
  • このフェーズはもう外からアクセスもできないのでhttpsは気にせずhttpで良いはず

## ALB

• リスナー443(80)からfargateターゲットグループへ転送
• 属性の `登録解除の遅延` は適宜設定したほうが良さそう
  • ここの設定時間分解除が遅くなる==デプロイが遅くなる
　　• オンライン処理をするコンテナがぶら下がるなら短くて良さそう

## security group系

• rdsのsecurity groupはインバウンドで3306をfargateからのみ許すと良い
• fargateとALBはsecurity group分けると良さそう
• fargateはコンテナの利用ポートを許可
  • 80のみ。証明書関連は上段で終わらせる
• ALBは80と443許可 or 443許可?
  • CFを挟んで80 to 443の設定をして80はALBでは通さないようにするのもありかも

## CodeBuild

• そんなに苦もなくすっとできたがGitHubのOAuthを使う感じ
• docker buildしてdocker pushして(migrateして？)みたいなのをbuildspec.ymlに書いていく感じ
• そのbuild&pushが終わったらそのできたてのimageを使ってデプロイする感じ

## CFや監視周り

今度やりたい
