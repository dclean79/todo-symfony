/*
 * Welcome to your app's main JavaScript file!
 *
 * This file will be included onto the page via the importmap() Twig function,
 * which should already be in your base.html.twig.
 */

import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap';
import 'bootstrap-icons/font/bootstrap-icons.css';

import './styles/app.css';

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.toggle-task').forEach(checkbox => {
        checkbox.addEventListener('change', async function() {
            const taskId = this.dataset.taskId;
            const title = this.closest('.row').querySelector('.task-title');

            try {
                const response = await fetch(`/${taskId}/toggle`, {
                    method: 'POST',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });

                console.log("📡 Wysłano żądanie AJAX do backendu:", response);

                const data = await response.json();

                if (data.success) {
                    if (data.isDone) {
                        console.log("✍️ Oznaczam zadanie jako zakończone:", taskId);
                        title.classList.add('text-decoration-line-through', 'text-muted');
                    } else {
                        console.log("✍️ Oznaczam zadanie jako aktywne:", taskId);
                        title.classList.remove('text-decoration-line-through', 'text-muted');
                    }
                } else {
                    console.warn("⚠️ Backend zwrócił success=false dla zadania:", taskId);
                }
            } catch (error) {
                console.error("❌ Błąd AJAX:", error);
            }
        });
    });
});

