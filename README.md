# REST API with Ruby on Rails: The Complete Guide

[Udemy](https://www.udemy.com/) の [REST API with Ruby on Rails: The Complete Guide](https://www.udemy.com/course/ruby-on-rails-api-the-complete-guide/) で作成した Rails 製の REST API です  
以下のリポジトリが元コードになります（若干変えています）

- [rails-api-complete-guide](https://github.com/driggl/rails-api-complete-guide)

## 環境について

### バージョン情報

| ソフトウェアスタック | バージョン |
|:---------------------|:----------:|
| Rails                | 6.0.3.2    |
| Ruby                 | 2.6.5      |
| SQLite               | 3.28.0     |

### Serializerについて

デフォルトだと [Jbuilder](https://github.com/rails/jbuilder) が入っているがオブジェクト指向的な書き方ができる [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers) を使用してAPIを作成している  
ただ、[ActiveModelSerializers](https://github.com/rails-api/active_model_serializers) は更新が止まっているので使うのは止めたほうがよい

候補としては以下の２つ

| Gem名 | 備考 |
|:-------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------|
| [Fast JSON API](https://github.com/Netflix/fast_jsonapi)                                   | Netflix製だが開発が止まっているので止めたほうが良さそう                                    |
| [JSON:API Serialization Library](https://github.com/jsonapi-serializer/jsonapi-serializer) | [Fast JSON API](https://github.com/Netflix/fast_jsonapi) をForkして作成されている Gem です |

メンテナンスされていないものが多いのでデフォルトの [Jbuilder](https://github.com/rails/jbuilder) を使用したほうが無難かもしれない……

## APIのJSONベースフォーマット

[JSON API](https://jsonapi.org/) の形式を採用しています

サンプル

```json
{
  "links": {
    "self": "http://example.com/articles",
    "next": "http://example.com/articles?page[offset]=2",
    "last": "http://example.com/articles?page[offset]=10"
  },
  "data": [{
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON:API paints my bikeshed!"
    },
    "relationships": {
      "author": {
        "links": {
          "self": "http://example.com/articles/1/relationships/author",
          "related": "http://example.com/articles/1/author"
        },
        "data": { "type": "people", "id": "9" }
      },
      "comments": {
        "links": {
          "self": "http://example.com/articles/1/relationships/comments",
          "related": "http://example.com/articles/1/comments"
        },
        "data": [
          { "type": "comments", "id": "5" },
          { "type": "comments", "id": "12" }
        ]
      }
    },
    "links": {
      "self": "http://example.com/articles/1"
    }
  }],
  "included": [{
    "type": "people",
    "id": "9",
    "attributes": {
      "firstName": "Dan",
      "lastName": "Gebhardt",
      "twitter": "dgeb"
    },
    "links": {
      "self": "http://example.com/people/9"
    }
  }, {
    "type": "comments",
    "id": "5",
    "attributes": {
      "body": "First!"
    },
    "relationships": {
      "author": {
        "data": { "type": "people", "id": "2" }
      }
    },
    "links": {
      "self": "http://example.com/comments/5"
    }
  }, {
    "type": "comments",
    "id": "12",
    "attributes": {
      "body": "I like XML better"
    },
    "relationships": {
      "author": {
        "data": { "type": "people", "id": "9" }
      }
    },
    "links": {
      "self": "http://example.com/comments/12"
    }
  }]
}
```

## 認証について

OAuthの認証の流れは画像の通りになります

![OAuth](https://i.udemycdn.com/redactor/raw/2018-06-16_11-30-31-5c1d94cb91beb75ceb3d805db4ce1ef5.png)

認証方法は２通りあります

- OAuth(Github) を使用して認証
- ログイン、パスワードを使用して認証（予め sign_up が必要）

UserAuthenticator.rb を元に受け取るパラメータにより上記、認証を切り分ける

### 未実装機能

- GitHub の2段階認証に未対応
    - 実装する場合は [こちら](https://github.com/octokit/octokit.rb#two-factor-authentication) を参考にすること

## 修正案

例外処理をもっといい感じに書けるので以下を参考にすると良さそう

- [Handling exceptions in Rails API applications](https://driggl.com/blog/a/handling-exceptions-in-rails-applications)
