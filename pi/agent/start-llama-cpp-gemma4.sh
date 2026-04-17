#!/bin/sh

set -eu

MODEL_REPO="${PI_LLAMA_CPP_MODEL_ID:-ggml-org/gemma-4-26B-A4B-it-GGUF}"
HOST="${PI_LLAMA_CPP_HOST:-127.0.0.1}"
PORT="${PI_LLAMA_CPP_PORT:-8012}"

exec llama-server \
	-hf "$MODEL_REPO" \
	--host "$HOST" \
	--port "$PORT" \
	--flash-attn on \
	--n-gpu-layers all \
	--ctx-size 64000 \
	--cache-type-k q8_0 \
  --cache-type-v q8_0
