#!/bin/bash

set -e

echo "▶ Limpiando proyecto..."
flutter clean

echo "▶ Obteniendo dependencias..."
flutter pub get

echo "▶ Generando build web..."
flutter build web

echo "▶ Comprimiendo build web..."
rm -f build_web.zip
zip -r build_web.zip build/web

echo "✔ Build web completado: build_web.zip"
