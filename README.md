# ai-diffraction

## Setup

```
pip install kaggle --user
```

If `kaggle` doesn't work, ensure you add python binaries to path. For a local user install on Linux, the default location is ~/.local/bin. On Windows, the default location is $PYTHON_HOME/Scripts.

You will also have to authenticate yourself with an API token. Go to [user profile](https://www.kaggle.com/settings/account) and select 'Create New Token' to download "kaggle.json". This then needs to be put in either "~/.kaggle/kaggle.json", or for windows "C:/Users/\<Windows-username>/.kaggle/kaggle.json"

To download the dataset, run:

```
kaggle datasets download wephys/felix-diffraction-patterns -p ./datasets --unzip
```

To download the precomputed results, run:
```
kaggle datasets download wephys/ai-diffraction-results --unzip
```




## Running

```
python train.py --split ./data/FDP_splits/random/0 --gpu_ids 0 --input structure --name pattern_random0
```

and to continue training

```
python train.py --split ./data/FDP_splits/random/0 --gpu_ids 0 --input structure --name pattern_random0 --continue_train --which_epoch 10
```