# ai-diffraction

## Setup

#### Downloading the dataset

```
pip install kaggle --user
```

If `kaggle` doesn't work, ensure you add python binaries to path. For a local user install on Linux, the default location is ~/.local/bin. On Windows, the default location is $PYTHON_HOME/Scripts.

You will also have to authenticate yourself with an API token. Go to [user profile](https://www.kaggle.com/settings/account) and select 'Create New Token' to download "kaggle.json". This then needs to be put in either "~/.kaggle/kaggle.json", or for windows "C:/Users/\<Windows-username>/.kaggle/kaggle.json"

To download the dataset, run:

```
kaggle datasets download -d wephys/electron-diffraction-patterns-for-ml --unzip
```

#### Downloading precomputed results

To download the precomputed results for 10 random splits for both predicting patterns and structures, run:
```
kaggle datasets download wephys/felix-ai-results --unzip
```


## Training

```
python train.py --dataroot datasets/patterns-primary --direction 0 --thickness 2000 --gpu_ids 0 --split data/splits/patterns-primary/0
```

## Predicting Patterns

To predict patterns, there must a structure as follows:
```txt
ai-diffraction/
├── checkpoints/
│   └── experiment-name/
│       ├── 10_net_D.pth
│       └── 10_net_G.pth
└── ...
```
where 10_net_D.pth and 10_net_G.pth are epoch 10 models for the discriminator and generator respectively, and they are fall under the an arbitrarily chosen name 'pattern_random0'. Using these we can predicting charge density structures for all ML phases, the first five random patterns splits, and for epochs 10.

```sh
for PHASE in train test val
do
    for SPLIT in 0
    do
        for EPOCH in 10
        do
            python test.py --dataroot datasets/FDP --gpu_ids 0 --split data/FDP_splits/random/${SPLIT} --input pattern --name structure_random${SPLIT} --how_many 99999 --phase ${PHASE} --which_epoch ${EPOCH}
        done
    done
done
```