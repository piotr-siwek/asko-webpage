#!/bin/bash

# Lista plików HTML do optymalizacji (bez index.html, który już jest zoptymalizowany)
files=(
    "podsufitka-siding.html"
    "o-firmie.html"
    "kontakt.html"
    "folia-pp.html"
    "folia-pvc.html"
    "folie.html"
    "panel-pvc-10.html"
    "produkty.html"
)

# Wczytaj krytyczny CSS
critical_css=$(cat critical.css)

for file in "${files[@]}"; do
    echo "Optymalizacja: $file"
    
    # Backup oryginalnego pliku
    cp "$file" "${file}.backup"
    
    # Użyj sed do zastąpienia sekcji head
    # Znajdź i zastąp linki do CSS
    sed -i '' \
        -e 's|<link rel="stylesheet" href="styles.css">|<!-- Critical CSS inline -->\n    <style>'"$critical_css"'</style>\n    <!-- Preload main CSS -->\n    <link rel="preload" href="styles.min.css" as="style" onload="this.onload=null;this.rel='"'"'stylesheet'"'"'">\n    <noscript><link rel="stylesheet" href="styles.min.css"></noscript>|' \
        -e 's|<link rel="preconnect" href="https://fonts.googleapis.com">|<!-- Preconnect for faster third-party requests -->\n    <link rel="preconnect" href="https://fonts.googleapis.com">|' \
        -e 's|<link href="https://fonts.googleapis.com/css2?family=Inter:wght=300;400;500;600;700\&display=swap" rel="stylesheet">|<link href="https://fonts.googleapis.com/css2?family=Inter:wght=300;400;500;600;700\&display=swap" rel="stylesheet" media="print" onload="this.media='"'"'all'"'"'">\n    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght=300;400;500;600;700\&display=swap" rel="stylesheet"></noscript>|' \
        -e 's|<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">|<link rel="preconnect" href="https://cdnjs.cloudflare.com">\n    <!-- Defer Font Awesome -->\n    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" media="print" onload="this.media='"'"'all'"'"'">\n    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"></noscript>|' \
        -e 's|<script src="script.js"></script>|<script src="script.js" defer></script>|' \
        "$file"
done

echo "Optymalizacja zakończona!"

