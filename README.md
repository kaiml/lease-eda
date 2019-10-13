# lease-eda

## How to setup docker environment with linting and formatting

### Setup

Make sure that the port 8888 of your local computer is open.
```
docker-compose up --build
```

### Snippets

```py
%load_ext pycodestyle_magic
%flake8_on
```
