# LOKALIZACJA: todo-symfony/docker/php/entrypoint.sh
#!/bin/sh
set -e

# Wymuszenie zmiennych środowiskowych do katalogu /tmp
export SYMFONY_CACHE_DIR="/tmp/symfony/cache"
export SYMFONY_LOG_DIR="/tmp/symfony/log"

# Wymuszenie utworzenia katalogów cache i logów w /tmp
mkdir -p "$SYMFONY_CACHE_DIR" "$SYMFONY_LOG_DIR"
chown -R www-data:www-data /tmp/symfony

# Uruchomienie "composer install" (jeśli pominięto w Dockerfile)
if [ ! -d "vendor" ]; then
    echo "Brak katalogu vendor. Instaluję zależności..."
    # Używamy gosu, aby wykonać polecenie jako www-data
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


# 2. Uruchomienie migracji i czyszczenie cache
# Wykonujemy to jako www-data, używając gosu
if [ "$APP_ENV" = "dev" ] || [ "$APP_ENV" = "prod" ]; then
    echo "Inicjalizacja i migracja bazy danych..."
    gosu www-data bin/console doctrine:database:create --if-not-exists --no-interaction
    gosu www-data bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
    
    echo "Czyszczenie i przebudowa cache..."
    # Cache trafi do /tmp zgodnie z SYMFONY_CACHE_DIR
    gosu www-data bin/console cache:clear --env=$APP_ENV
    gosu www-data bin/console cache:warmup --env=$APP_ENV
fi

# 3. Przekazanie kontroli do głównego procesu
exec "$@"