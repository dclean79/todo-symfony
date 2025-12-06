/** @type {import('tailwindcss').Config} */
module.exports = {
  // Klucz 'content' zastępuje 'purge'. Wskazuje pliki, w których Tailwind
  // ma szukać używanych klas do optymalizacji finalnego pliku CSS.
  content: [
    "./assets/**/*.js",
    "./templates/**/*.html.twig",
    "./src/Form/**/*.php", // Dodajemy dla formularzy Symfony, aby klasy w kodzie PHP były uwzględniane.
  ],
  
  // 'darkMode' - możesz zmienić na 'media' (domyślny) lub 'class', 
  // jeśli planujesz obsługę ciemnego trybu. 'false' (domyślny) jest nieużywany w T3+.
  // Zostawiam domyślne dla prostoty.
  
  theme: {
    extend: {
      // Tutaj dodasz własne kolory, fonty, czy inne rozszerzenia motywu.
    },
  },
  
  // Klucz 'variants' został usunięty w Tailwind CSS 3.x, 
  // ponieważ warianty są domyślnie włączone.
  
  plugins: [], 
  // Tutaj dodasz opcjonalne wtyczki Tailwind, np. @tailwindcss/forms.
}