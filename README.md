# lease-eda

## How to setup docker environment with linting and formatting

### Setup

`docker build -t lease-eda .`
`docker run -it -p 8888:8888 lease-eda`
`pipenv run jupyter notebook --ip 0.0.0.0 --no-browser --allow-root`

Download the ipynb file when you are done (Since it saves within its own container)

### Snippets

```py
%load_ext pycodestyle_magic
%flake8_on
```
