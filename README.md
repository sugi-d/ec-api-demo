# ec-api-demo

See openapi.yaml for API definition

## development

```
$ docker compose build && docker compose up
```

The API endpoint will be http://localhost:3000/.

## production (simulator)

### setup

```
$ docker compose -f compose.prod.yml build
$ docker compose -f compose.prod.yml up pgpool
```

### boot

After pgpool boots properly you can boot the app

```
$ docker compose -f compose.prod.yml up
```

The API endpoint will be http://localhost:3000/.
