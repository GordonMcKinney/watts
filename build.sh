#!/usr/bin/env bash
set -e

echo "Building Watts..."

mkdir -p bin
rm -rf bin/*

swiftc SMC/SMC.swift Watts/main.swift -o bin/watts

echo "Build complete. You can run the tool with './bin/watts'"