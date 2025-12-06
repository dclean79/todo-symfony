#!/bin/sh
set -e

# Przechodzimy do katalogu aplikacji, aby ścieżki względne działały poprawnie
cd /var/www/symfony

# --- SEKCJA UPRAWNIEŃ DLA CLI (POPRAWKA CHOWN) ---

# Jawne tworzenie głównych katalogów cache i logów w var/.
# Jest to niezbędne, ponieważ są one anonimowymi wolumenami i są puste.
mkdir -p var/cache var/log

# Ustawiamy właściciela DLA CLI: Ponieważ komendy bin/console są uruchamiane przez
# użytkownika hosta (${UID}:${GID}), musimy mu nadać pełne uprawnienia do zapisu.
echo "Ustawiam właściciela anonimowych wolumenów var/cache i var/log na użytkownika hosta (${UID}:${GID})."
chown -R ${UID}:${GID} var/cache var/log

# --- Wstępne czyszczenie i rozgrzewanie cache jako www-data ---
echo "Wstępne czyszczenie i rozgrzewanie cache jako www-data..."
gosu www-data php bin/console cache:clear --no-warmup || true
gosu www-data php bin/console cache:warmup || true
echo "Cache został rozgrzany w var/cache."
# ----------------------------------------------------------------------

# Uruchomienie "composer install" (jeśli pominięto w Dockerfile)
if [ ! -d "vendor" ]; then
    echo "Brak katalogu vendor. Instaluję zależności..."
    gosu www-data composer install --prefer-dist --no-interaction
fi

# 1. Czekanie na bazę danych MySQL (usługa 'database')
DB_HOST=database
DB_PORT=3306

echo "Czekam na uruchomienie bazy danych MySQL na $DB_HOST:$DB_PORT..."
until nc -z $DB_HOST $DB_PORT; do
  echo "Baza danych niedostępna. Czekam..."
  sleep 1
done
echo "Baza danych jest dostępna."

# 3. Przekazanie kontroli do głównego procesu (czyli php-fpm)
exec "$@"
