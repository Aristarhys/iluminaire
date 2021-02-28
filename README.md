# Image for Luminaire

[Luminaire](https://github.com/zillow/luminaire)

All rights belong to their respective owners

Warning - this image is very ascetic, but i hope get's work done

## Example of running shell

```
docker run --rm -ti aristarhys/luminaire python
```

## Example of running standalone script

```
mkdir -p data
cd ./data
# obtain dataset
curl https://raw.githubusercontent.com/Aristarhys/luminaire/master/luminaire/tests/datasets/daily_test_time_series.csv -so daily_test_time_series.csv
# put script.py in same folder
docker run --rm -v `pwd`/data:/data -t aristarhys/luminaire python /data/script.py
```

### Example of standalone script

```
import pandas as pd
from luminaire.model.lad_structural import *
from datetime import datetime

training_test_data = pd.read_csv('/data/daily_test_time_series.csv')
training_test_data['index'] = pd.DatetimeIndex(training_test_data['index'])
training_test_data['interpolated'] = training_test_data['raw']
training_test_data = pd.DataFrame(training_test_data, columns=['index', 'raw', 'interpolated']).set_index('index')

hyper_params = LADStructuralHyperParams(is_log_transformed=False, p=4, q=0).params
lad_struct_obj = LADStructuralModel(hyper_params, freq='D')
data_summary = {
    'ts_start': training_test_data.first_valid_index(),
    'ts_end': training_test_data.last_valid_index(),
    'is_log_transformed': False,
}

print(data_summary)

success, ts_end, model = lad_struct_obj.train(data=training_test_data, **data_summary)

print(success, ts_end)
```

## Example of running Jupiter lab

```
docker run -d --rm -p 8888:8888 -v `pwd`/data:/data -t aristarhys/luminaire sh -c "install_packages libsqlite3-dev && pip install jupyterlab && jupyter-lab --allow-root --ip 0.0.0.0 --no-browser --notebook-dir=/data"
# check readiness with docker logs <container_id>
```

## Development

Clone this repo, change dockerfile, build and push.

`--squash` is [experimental feature](https://docs.docker.com/engine/reference/commandline/cli/#experimental-features) which is [not supported yet](https://github.com/docker/hub-feedback/issues/955) in dockerhub autobuilds.

```
docker build --squash --rm -t <username>/luminaire:latest .
# after docker login
docker push <username>/luminaire --all-tags
```
