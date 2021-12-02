# 001

## Dockerイメージをビルドして、Terraformを実行するまで。
### 事前に用意するファイルの紹介
#### .env
`docker-build.sh`で使用するファイル。Dockerイメージをビルドする際に`--build-arg`オプションで指定する各種環境変数が事前に記載されたファイル。 
```
AWS_ACCESS_KEY=XXXXXXX
AWS_SECRET_ACCESS_KEY=XXXXXXX
ENV=staging
IMAGE_VERSION=1.0.0
```
#### example.tfbackend
Terraformのbackendに関する各種設定が記載されたファイル。`terrform init --backend-config=example.tfbackend`のように指定する。
```
bucket   = "sample-bucket" # tfstateを格納するS3バケット名。
region   = "ap-northeast-1"
key      = "sample/state.tfstate" # tfstateのファイル名。
encrypt  = true # tfstateファイルを暗号化する。
role_arn = "arn:aws:iam::111111111:role/sts-role-name" # Terraformの実行はAssumeRoleを使用する。そのため、スイッチ先のIAMロールのARNを指定する。
```

#### example.tfvars
Terraformnの変数設定ファイル。
```
sts_iam_role = "arn:aws:iam::111111111:role/sts-role-name" # Terraformの実行はAssumeRoleを使用する。そのため、スイッチ先のIAMロールのARNを指定する。
tags = {
  "Env"    = "develop"
  "System" = "study-infra-tutorial"
}
```

### 手順
１．「XXX/001/infra」まで移動する。
```bash
$ pwd
→「XXX/study-infra-aws-tutorial/001/infra」に移動していること。  
```

２．Dockerイメージをビルドする。
```bash
$ docker build \
  -t study-infra-tf:1.0.0 \
  --build-arg AWS_ACCESS_KEY=${AWS_ACCESS_KEY} \ # IAMをユーザーのアクセスキー。
  --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \ # IAMユーザーのシークレットキー。
  --build-arg ENV=staging \
  .
```
※`.env`ファイルを用意して、`docker-build.sh`を使えばより簡単にビルドできます。
```bash
# 環境変数ファイルの用意。
$ touch .env
$ vi .env
→以下の環境変数を記載する。
AWS_ACCESS_KEY=XXXXXXX
AWS_SECRET_ACCESS_KEY=XXXXXXX
ENV=staging
IMAGE_VERSION=1.0.0

# docker-build.shでビルド。
$ chmod +x docker-build.sh
$ ./docker-build.sh
```

３．コンテナを起動する。
```bash
$ docker images
→２で作成したイメージのIDを確認する。

$ docker run --rm -v $PWD:/tf -it [イメージID] ash
```
`--rm`：コンテナからログアウトすると自動で削除する。  
`-v`：ローカルディレクトリをコンテナ内にマウントする。（ローカルの変更がコンテナにリアルタイムに反映されるように。）  
`-it`:コンテナにアタッチしてコンテナ内でコマンドが実行できるようにする。

４．Terraforを実行する。（３のコンテナ内で）
```bash
$ terraform init -backend-config=example.tfbackend
$ terraform plan -var-file=example.tfvars
```
