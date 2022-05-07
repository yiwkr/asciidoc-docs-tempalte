# document sample (asciidoc)

## VS Codeの設定

`Ctrl+Shift+p`を押して`open settings json`を入力してEnter

下記を追加

```
    "asciidoc.asciidoctorpdf_command": "asciidoctor-pdf -a scripts=cjk -a pdf-theme=default-with-fallback-font -r asciidoctor-diagram -D build",
    "asciidoc.asciidoctor_command": "asciidoctor -r asciidoctor-diagram -D build",
    "asciidoc.use_asciidoctorpdf": true,
    "asciidoc.use_asciidoctor_js": false
```

`Ctrl+Shift+p`を押して`open folder in container`を入力してEnter

## ビルド

```
make all
```

### html

```
make html
```

### pdf

```
make pdf
```

## 参考

- https://qiita.com/tamikura@github/items/5d3f62dae55617ee42bb
- https://qiita.com/mitsu48/items/34875bbc8ba00760fe27
