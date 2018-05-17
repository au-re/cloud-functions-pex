#!/bin/bash

echo "building pex file..."
pip wheel --no-cache-dir --wheel-dir=./wheels -r shared/requirements.txt
pex -r shared/requirements.txt --repo=./wheels --no-pypi --no-build -o shared/env.pex
echo "done!"
