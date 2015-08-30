# 高専プロコン公式App

* App公式サイト: [https://proconapp.com](https://proconapp.com)
* プロコン公式: [http://procon.gr.jp/](http://procon.gr.jp/)

このリポジトリは高専プロコンアプリ(プロコンアプリ)のiOS版です。サーバーサイドなどの関連するサービスのリポジトリは以下にあります。

* APIサーバー [https://github.com/saga-dash/proconapp-server](https://github.com/saga-dash/proconapp-server)
* ランディングページ [https://github.com/novi/proconapp-lp](https://github.com/novi/proconapp-lp)
* ソーシャルフィードサーバー [https://github.com/novi/procon-social-server](https://github.com/novi/procon-social-server)
* iOS版 [https://github.com/novi/proconapp](https://github.com/novi/proconapp)
* Windows Phone版 [https://github.com/TK-R/wpproconapp](https://github.com/TK-R/wpproconapp)
* Android版 [https://github.com/sckm/ProconAppAndroid] (https://github.com/sckm/ProconAppAndroid)
* ランディングページ メール送信フォーム [https://github.com/saga-dash/proconapp-form](https://github.com/saga-dash/proconapp-form)


(※README準備中です)

# ライセンス
関連するリポジトリ含め、すべてMITです。詳細は各リポジトリ内のLICENSEをご覧ください。

# iOS版

## 動作環境

* Xcode 6.4 & Swift 1.2 (TODO: Swift 2.0)
* iOS 8 以上

## ビルド方法

ビルドするには、AppGroupおよびEntitlementsの設定が必要です。

また、APIサーバーへの接続先・AppGroupを書いた `Constants.swift` が必要です。以下のテンプレートから作成して、 `ProconApp/ProconBase/Constants.swift` に置いてください。

```swift
import Foundation

class Constants {
    #if HOST_DEV
    static var APIBaseURL = "https://someservice.azure-mobile.net/api/"
    static var AppGroupID = "group.jp.gr.procon.proconapp.dev"
    #elseif HOST_STAGING
    static var APIBaseURL = "..."
    static var AppGroupID = "group.jp.gr.procon.proconapp.staging"
    #elseif HOST_RELEASE
    static var APIBaseURL = "..."
    static var AppGroupID = "group.jp.gr.procon.proconapp"
    #endif
}
```

