# ai-diffraction


## running

```
python train.py --split ./datasets/splits/random/0 --gpu_ids 0 --input structure --name pattern_random0
```

and to continue training

```
python train.py --split ./datasets/splits/random/0 --gpu_ids 0 --input structure --name pattern_random0 --continue_train --which_epoch 10
```