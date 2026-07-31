# gh-ubuntu

gh extension として利用できる、Docker ベースの開発環境コマンドです。

- `gh ubuntu setup [20.04|22.04|24.04|26.04]`: Docker イメージをビルド
- `gh ubuntu shell`: コンテナ内シェルを起動
- `gh ubuntu shell <command...>`: コンテナ内で任意コマンドを実行

## 前提条件

- GitHub CLI (`gh`) がインストール済み
- Docker と Docker Compose Plugin がインストール済み

確認コマンド:

```bash
gh --version
docker --version
docker compose version
```

## インストール方法 (gh extension)

### 1) リポジトリから直接インストール

```bash
gh extension install <owner>/gh-ubuntu
```

### 2) ローカルリポジトリからインストール

このリポジトリを clone したディレクトリで実行:

```bash
gh extension install .
```

インストール確認:

```bash
gh extension list
```

## 使い方

### イメージのビルド

```bash
gh ubuntu setup
```

Ubuntu バージョンを指定してビルド:

```bash
gh ubuntu setup 20.04
gh ubuntu setup 22.04
gh ubuntu setup 24.04
gh ubuntu setup 26.04
```

引数未指定時は `24.04` を使用します。

### コンテナ内シェルへ入る

```bash
gh ubuntu shell
```

### コンテナ内でコマンド実行

```bash
gh ubuntu shell ./hello.sh
gh ubuntu shell id
```

## 動作仕様

- ホストの UID/GID を環境変数でコンテナに渡し、entrypoint で ubuntu ユーザへ反映します。
- `gh ubuntu shell` 実行時のホスト側カレントディレクトリは `/workdir` としてコンテナにマウントされます。
- そのため、どのディレクトリから実行しても、コンテナ内の作業ディレクトリは `/workdir` になります。
- コンテナの bash には `oh-my-posh` を導入し、テーマ `blueish.omp.json` を適用します。
- `gh ubuntu setup` で選んだ Ubuntu バージョンを、シェルプロンプトに表示します。

## トラブルシューティング

### ビルドをやり直したい

```bash
gh ubuntu setup
```

### コンテナ実行が失敗する

以下を確認してください。

- Docker デーモンが起動している
- `docker compose` が利用可能
- 実行ユーザが Docker を実行できる権限を持つ
