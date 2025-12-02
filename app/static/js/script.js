// Основной скрипт для документации API клиники
document.addEventListener('DOMContentLoaded', function() {
    initializeDocumentation();
});

function initializeDocumentation() {
    setupSmoothScrolling();
    setupSectionHighlighting();
    setupCodeCopying();
    setupEndpointEnhancements();
    setupSearchFunctionality();
    setupThemeSwitcher();
    setupQuickTestButtons();
    setupPrintFunctionality();
}

// Плавная прокрутка к якорям
function setupSmoothScrolling() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                const headerOffset = 80;
                const elementPosition = targetElement.offsetTop;
                const offsetPosition = elementPosition - headerOffset;
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
                
                // Обновляем URL без перезагрузки страницы
                history.pushState(null, null, targetId);
            }
        });
    });
}

// Подсветка текущей секции в навигации
function setupSectionHighlighting() {
    const sections = document.querySelectorAll('.section');
    const navLinks = document.querySelectorAll('.toc a');
    
    if (sections.length === 0 || navLinks.length === 0) return;
    
    const observerOptions = {
        root: null,
        rootMargin: '-20% 0px -70% 0px',
        threshold: 0
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const currentId = entry.target.getAttribute('id');
                
                navLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === `#${currentId}`) {
                        link.classList.add('active');
                    }
                });
            }
        });
    }, observerOptions);
    
    sections.forEach(section => {
        observer.observe(section);
    });
}

// Копирование кода по клику
function setupCodeCopying() {
    const codeBlocks = document.querySelectorAll('pre code');
    
    codeBlocks.forEach(block => {
        // Создаем контейнер для кнопки копирования
        const container = document.createElement('div');
        container.className = 'code-block-container';
        container.style.position = 'relative';
        
        block.parentNode.insertBefore(container, block);
        container.appendChild(block);
        
        // Создаем кнопку копирования
        const copyButton = document.createElement('button');
        copyButton.innerHTML = '📋';
        copyButton.className = 'copy-button';
        copyButton.title = 'Копировать код';
        copyButton.style.cssText = `
            position: absolute;
            top: 8px;
            right: 8px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        `;
        
        copyButton.addEventListener('mouseenter', function() {
            this.style.background = 'rgba(255, 255, 255, 0.2)';
            this.style.transform = 'scale(1.05)';
        });
        
        copyButton.addEventListener('mouseleave', function() {
            this.style.background = 'rgba(255, 255, 255, 0.1)';
            this.style.transform = 'scale(1)';
        });
        
        container.appendChild(copyButton);
        
        copyButton.addEventListener('click', async function() {
            const text = block.textContent;
            
            try {
                await navigator.clipboard.writeText(text);
                showNotification('✅ Код скопирован в буфер обмена!');
                
                // Визуальный фидбэк
                const originalHTML = this.innerHTML;
                this.innerHTML = '✅';
                this.style.background = '#27ae60';
                
                setTimeout(() => {
                    this.innerHTML = originalHTML;
                    this.style.background = 'rgba(255, 255, 255, 0.1)';
                }, 2000);
                
            } catch (err) {
                console.error('Ошибка при копировании:', err);
                showNotification('❌ Ошибка при копировании', 'error');
            }
        });
        
        // Добавляем курсор pointer для интерактивности
        block.style.cursor = 'pointer';
    });
}

// Улучшение endpoint блоков
function setupEndpointEnhancements() {
    const endpoints = document.querySelectorAll('.endpoint');
    
    endpoints.forEach(endpoint => {
        const h3 = endpoint.querySelector('h3');
        if (!h3) return;
        
        const method = h3.textContent.split(' ')[0];
        
        if (method === 'GET') {
            endpoint.classList.add('get');
        } else if (method === 'POST') {
            endpoint.classList.add('post');
        }
        
        // Добавляем индикатор метода
        const methodBadge = document.createElement('span');
        methodBadge.className = 'method-badge';
        methodBadge.textContent = method;
        methodBadge.style.cssText = `
            background: ${method === 'GET' ? '#27ae60' : '#f39c12'};
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8em;
            font-weight: bold;
            margin-right: 10px;
        `;
        
        h3.insertBefore(methodBadge, h3.firstChild);
    });
}

// Поиск по документации
function setupSearchFunctionality() {
    // Создаем поле поиска
    const searchContainer = document.createElement('div');
    searchContainer.className = 'search-container';
    searchContainer.style.cssText = `
        margin: 20px 0;
        text-align: center;
    `;
    
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.placeholder = '🔍 Поиск по документации...';
    searchInput.style.cssText = `
        width: 100%;
        max-width: 400px;
        padding: 12px 20px;
        border: 2px solid #e0e0e0;
        border-radius: 25px;
        font-size: 16px;
        outline: none;
        transition: all 0.3s ease;
        background: rgba(255, 255, 255, 0.9);
    `;
    
    searchInput.addEventListener('focus', function() {
        this.style.borderColor = '#3498db';
        this.style.boxShadow = '0 0 0 3px rgba(52, 152, 219, 0.1)';
    });
    
    searchInput.addEventListener('blur', function() {
        this.style.borderColor = '#e0e0e0';
        this.style.boxShadow = 'none';
    });
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase().trim();
        filterContent(searchTerm);
    });
    
    searchContainer.appendChild(searchInput);
    
    // Вставляем поле поиска после заголовка
    const header = document.querySelector('header');
    if (header) {
        header.parentNode.insertBefore(searchContainer, header.nextSibling);
    }
}

function filterContent(searchTerm) {
    const sections = document.querySelectorAll('.section');
    const endpoints = document.querySelectorAll('.endpoint');
    
    if (searchTerm.length < 2) {
        // Показываем все, если поисковый запрос короткий
        sections.forEach(section => section.style.display = 'block');
        endpoints.forEach(endpoint => endpoint.style.display = 'block');
        return;
    }
    
    let hasResults = false;
    
    sections.forEach(section => {
        const sectionText = section.textContent.toLowerCase();
        const sectionTitle = section.querySelector('h2');
        let sectionHasVisibleEndpoints = false;
        
        if (sectionTitle && sectionTitle.textContent.toLowerCase().includes(searchTerm)) {
            section.style.display = 'block';
            sectionHasVisibleEndpoints = true;
        } else {
            // Проверяем endpoints внутри секции
            const sectionEndpoints = section.querySelectorAll('.endpoint');
            sectionEndpoints.forEach(endpoint => {
                const endpointText = endpoint.textContent.toLowerCase();
                if (endpointText.includes(searchTerm)) {
                    endpoint.style.display = 'block';
                    sectionHasVisibleEndpoints = true;
                } else {
                    endpoint.style.display = 'none';
                }
            });
            
            section.style.display = sectionHasVisibleEndpoints ? 'block' : 'none';
        }
        
        if (sectionHasVisibleEndpoints) {
            hasResults = true;
        }
    });
    
    // Показываем уведомление, если нет результатов
    const existingNotification = document.querySelector('.no-results-notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    if (!hasResults) {
        const notification = document.createElement('div');
        notification.className = 'no-results-notification';
        notification.textContent = '😔 Ничего не найдено. Попробуйте другой запрос.';
        notification.style.cssText = `
            text-align: center;
            padding: 20px;
            color: #7f8c8d;
            font-style: italic;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            margin: 20px 0;
        `;
        
        const searchContainer = document.querySelector('.search-container');
        if (searchContainer) {
            searchContainer.parentNode.insertBefore(notification, searchContainer.nextSibling);
        }
    }
}

// Переключатель темы
function setupThemeSwitcher() {
    const themeToggle = document.createElement('button');
    themeToggle.innerHTML = '🌙';
    themeToggle.title = 'Переключить тему';
    themeToggle.className = 'theme-toggle';
    themeToggle.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: rgba(255, 255, 255, 0.9);
        border: none;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        font-size: 20px;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        z-index: 1000;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
    `;
    
    themeToggle.addEventListener('click', toggleTheme);
    themeToggle.addEventListener('mouseenter', function() {
        this.style.transform = 'scale(1.1) rotate(15deg)';
    });
    
    themeToggle.addEventListener('mouseleave', function() {
        this.style.transform = 'scale(1) rotate(0deg)';
    });
    
    document.body.appendChild(themeToggle);
    
    // Проверяем сохраненную тему
    const savedTheme = localStorage.getItem('docs-theme');
    if (savedTheme === 'dark') {
        enableDarkTheme();
        themeToggle.innerHTML = '☀️';
    }
}

function toggleTheme() {
    const themeToggle = document.querySelector('.theme-toggle');
    const isDark = document.body.classList.contains('dark-theme');
    
    if (isDark) {
        disableDarkTheme();
        themeToggle.innerHTML = '🌙';
        localStorage.setItem('docs-theme', 'light');
    } else {
        enableDarkTheme();
        themeToggle.innerHTML = '☀️';
        localStorage.setItem('docs-theme', 'dark');
    }
}

function enableDarkTheme() {
    document.body.classList.add('dark-theme');
    document.body.style.cssText = `
        background: linear-gradient(135deg, #2c3e50, #34495e) !important;
        color: #ecf0f1 !important;
    `;
    
    // Обновляем стили элементов для темной темы
    updateElementsForDarkTheme();
}

function disableDarkTheme() {
    document.body.classList.remove('dark-theme');
    document.body.style.cssText = `
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
        color: #333 !important;
    `;
    
    // Возвращаем исходные стили
    updateElementsForLightTheme();
}

function updateElementsForDarkTheme() {
    const elements = document.querySelectorAll('.section, .toc, header, .endpoint, .schema, .steps');
    elements.forEach(el => {
        el.style.background = 'rgba(44, 62, 80, 0.95)';
        el.style.color = '#ecf0f1';
    });
}

function updateElementsForLightTheme() {
    const elements = document.querySelectorAll('.section, .toc, header, .endpoint, .schema, .steps');
    elements.forEach(el => {
        el.style.background = '';
        el.style.color = '';
    });
}

// Кнопки быстрого тестирования API
function setupQuickTestButtons() {
    const endpoints = document.querySelectorAll('.endpoint');
    
    endpoints.forEach(endpoint => {
        const examples = endpoint.querySelectorAll('.example pre code');
        
        examples.forEach(example => {
            const curlText = example.textContent.trim();
            if (curlText.includes('curl')) {
                const testButton = document.createElement('button');
                testButton.textContent = '🚀 Тестировать';
                testButton.className = 'test-button';
                testButton.style.cssText = `
                    background: #e74c3c;
                    color: white;
                    border: none;
                    padding: 8px 16px;
                    border-radius: 6px;
                    cursor: pointer;
                    font-size: 12px;
                    margin-top: 10px;
                    transition: all 0.3s ease;
                `;
                
                testButton.addEventListener('mouseenter', function() {
                    this.style.background = '#c0392b';
                    this.style.transform = 'translateY(-2px)';
                });
                
                testButton.addEventListener('mouseleave', function() {
                    this.style.background = '#e74c3c';
                    this.style.transform = 'translateY(0)';
                });
                
                testButton.addEventListener('click', function() {
                    executeCurlCommand(curlText);
                });
                
                example.parentNode.appendChild(testButton);
            }
        });
    });
}

function executeCurlCommand(curlCommand) {
    // Эмуляция выполнения curl команды
    showNotification('🔧 Тестирование API...', 'info');
    
    // Здесь можно добавить реальную логику выполнения запросов
    // Для демонстрации просто показываем уведомление
    setTimeout(() => {
        showNotification('✅ Запрос выполнен! Проверьте консоль браузера.', 'success');
        console.log('Выполняем команду:', curlCommand);
        
        // В реальном приложении здесь будет fetch запрос
        simulateApiRequest(curlCommand);
    }, 1000);
}

function simulateApiRequest(curlCommand) {
    const urlMatch = curlCommand.match(/http:\/\/[^'\s]+/);
    if (!urlMatch) return;
    
    const url = urlMatch[0];
    const method = curlCommand.includes('-X POST') ? 'POST' : 'GET';
    
    console.group('📡 API Request Simulation');
    console.log('URL:', url);
    console.log('Method:', method);
    console.log('CURL Command:', curlCommand);
    console.groupEnd();
}

// Функция для показа уведомлений
function showNotification(message, type = 'success') {
    // Удаляем существующие уведомления
    const existingNotifications = document.querySelectorAll('.notification');
    existingNotifications.forEach(notification => notification.remove());
    
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'error' ? '#e74c3c' : type === 'info' ? '#3498db' : '#27ae60'};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        z-index: 10000;
        animation: slideInRight 0.3s ease-out;
        max-width: 300px;
        backdrop-filter: blur(10px);
    `;
    
    document.body.appendChild(notification);
    
    // Автоматическое скрытие через 4 секунды
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease-in';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 4000);
}

// Печать документации
function setupPrintFunctionality() {
    const printButton = document.createElement('button');
    printButton.innerHTML = '🖨️';
    printButton.title = 'Распечатать документацию';
    printButton.className = 'print-button';
    printButton.style.cssText = `
        position: fixed;
        bottom: 80px;
        right: 20px;
        background: rgba(255, 255, 255, 0.9);
        border: none;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        font-size: 20px;
        cursor: pointer;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        z-index: 1000;
        transition: all 0.3s ease;
        backdrop-filter: blur(10px);
    `;
    
    printButton.addEventListener('click', printDocumentation);
    printButton.addEventListener('mouseenter', function() {
        this.style.transform = 'scale(1.1)';
    });
    
    printButton.addEventListener('mouseleave', function() {
        this.style.transform = 'scale(1)';
    });
    
    document.body.appendChild(printButton);
}

function printDocumentation() {
    showNotification('🖨️ Подготовка к печати...', 'info');
    
    // Сохраняем текущие стили
    const originalStyles = {};
    const elementsToModify = document.querySelectorAll('*');
    
    elementsToModify.forEach(el => {
        originalStyles[el] = el.style.cssText;
    });
    
    // Применяем стили для печати
    document.body.style.background = 'white';
    document.body.style.color = 'black';
    
    const coloredElements = document.querySelectorAll('.section, .toc, header, .endpoint');
    coloredElements.forEach(el => {
        el.style.background = 'white';
        el.style.color = 'black';
        el.style.boxShadow = 'none';
        el.style.border = '1px solid #ddd';
    });
    
    // Скрываем ненужные элементы для печати
    const elementsToHide = document.querySelectorAll('.theme-toggle, .print-button, .test-button, .copy-button, .search-container');
    elementsToHide.forEach(el => {
        el.style.display = 'none';
    });
    
    // Печать
    setTimeout(() => {
        window.print();
        
        // Восстанавливаем стили после печати
        setTimeout(() => {
            elementsToModify.forEach(el => {
                if (originalStyles[el]) {
                    el.style.cssText = originalStyles[el];
                }
            });
            
            elementsToHide.forEach(el => {
                el.style.display = '';
            });
        }, 1000);
        
    }, 500);
}

// Анимации CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .dark-theme {
        background: linear-gradient(135deg, #2c3e50, #34495e) !important;
        color: #ecf0f1 !important;
    }
    
    .dark-theme .section,
    .dark-theme .toc,
    .dark-theme header,
    .dark-theme .endpoint,
    .dark-theme .schema,
    .dark-theme .steps {
        background: rgba(44, 62, 80, 0.95) !important;
        color: #ecf0f1 !important;
    }
    
    .dark-theme code {
        background: rgba(52, 152, 219, 0.3) !important;
        color: #ecf0f1 !important;
    }
    
    .dark-theme pre {
        background: #1a252f !important;
        color: #ecf0f1 !important;
    }
    
    @media print {
        .theme-toggle,
        .print-button,
        .test-button,
        .copy-button,
        .search-container {
            display: none !important;
        }
        
        body {
            background: white !important;
            color: black !important;
        }
        
        .section, .toc, header {
            background: white !important;
            color: black !important;
            box-shadow: none !important;
            border: 1px solid #ddd !important;
        }
    }
`;
document.head.appendChild(style);

// Обработка ошибок
window.addEventListener('error', function(e) {
    console.error('Произошла ошибка:', e.error);
});

// Export функций для глобального использования
window.DocsAPI = {
    testEndpoint: executeCurlCommand,
    showNotification: showNotification,
    toggleTheme: toggleTheme,
    printDocs: printDocumentation
};

console.log('🚀 Документация API клиники загружена и готова к использованию!');