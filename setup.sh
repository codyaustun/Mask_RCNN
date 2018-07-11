set -e

ROOT="$HOME/Mask_RCNN"

if [[ ! -d $ROOT ]]; then
  git clone https://github.com/robieta/Mask_RCNN.git
fi
cd "$ROOT"

pip install -r requirements.txt
python3 setup.py install

if [[ ! -d cocoapi ]]; then
  git clone https://github.com/cocodataset/cocoapi.git
fi

cd cocoapi/PythonAPI
make
cd ../..

if [[ ! -d pycocotools ]]; then
  ln -s cocoapi/PythonAPI/pycocotools/ .
fi


if [[ ! -d $HOME/coco_dataset ]]; then
  gsutil -m cp -r gs://garden-team-scripts/coco_dataset "$HOME/"
fi

sudo apt-get install python3-tk


if ! (echo "$PYTHONPATH" | grep "Mask_RCNN"); then export PYTHONPATH="$PYTHONPATH:$HOME/Mask_RCNN"; fi;
cd ~/Mask_RCNN
python3 samples/coco/coco.py train --dataset="$HOME/coco_dataset" --model=imagenet --logs="$HOME/rcnn_logs" \
		--year=2014 --download=true