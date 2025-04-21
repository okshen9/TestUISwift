# Универсальная модель для PieChart

В этой версии компонента `PieChart` реализована универсальная модель данных с поддержкой неограниченной вложенности категорий.

## Особенности универсальной модели

- **Единая структура данных** - вместо отдельных типов для каждого уровня вложенности используется рекурсивная модель
- **Произвольная глубина вложенности** - нет ограничений на количество уровней категорий
- **Упрощенная навигация** - использование стека навигации для перемещения между уровнями
- **Хлебные крошки** - отображение пути навигации по уровням категорий
- **Оптимизированная логика** - более эффективный код с меньшим дублированием

## Структура данных

```swift
struct PieModel: Identifiable {
    let id = UUID()
    /// процент от общего значения модели
    let totalValue: Double
    /// текущее заполенение конкретной модели
    let currentValue: Double
    /// дочерние модели
    let subModels: [PieModel]?
    /// цвет для модели
    let color: Color
    /// название модели
    let title: String

    var fillPercentage: Double {
        return currentValue / totalValue * 100
    }

    /// Проверяет наличие дочерних моделей
    var hasSubModels: Bool {
        return subModels != nil && !subModels!.isEmpty
    }
}
```

## Использование

Для работы с диаграммой достаточно создать модели данных и заполнить их:

```swift
// Создание моделей с произвольной вложенностью
let childModels = [
    PieModel(totalValue: 60, currentValue: 30, subModels: nil, color: .green, title: "Подкатегория 1"),
    PieModel(totalValue: 40, currentValue: 20, subModels: nil, color: .blue, title: "Подкатегория 2")
]

let rootModels = [
    PieModel(totalValue: 70, currentValue: 40, subModels: childModels, color: .red, title: "Категория 1"),
    PieModel(totalValue: 30, currentValue: 15, subModels: nil, color: .orange, title: "Категория 2")
]

// Инициализация ViewModel
let viewModel = UniversalPieChartViewModel()
viewModel.models = rootModels

// Отображение диаграммы (базовой или улучшенной версии)
UniversalPieChartView(viewModel: viewModel)
// или
EnhancedUniversalPieChartView(viewModel: viewModel)
```

## Компоненты

1. **UniversalPieModel.swift** - содержит универсальную модель данных
2. **UniversalPieChartViewModel.swift** - ViewModel для управления состоянием диаграммы
3. **UniversalPieChartView.swift** - базовая версия представления диаграммы
4. **EnhancedUniversalPieChartView.swift** - улучшенная версия с дополнительными возможностями

## Преимущества по сравнению с предыдущей реализацией

1. **Упрощение кода** - вместо 4 разных структур данных используется одна рекурсивная модель
2. **Гибкость** - возможность создавать категории с произвольной глубиной вложенности
3. **Лучшая поддержка** - проще поддерживать и расширять один тип модели вместо нескольких
4. **Улучшенная навигация** - более интуитивный переход между уровнями с хлебными крошками
5. **Рекурсивная обработка** - логика отображения и расчетов работает для любой глубины иерархии

## Особенности компонентов

### UniversalPieChartViewModel

- Управляет стеком навигации для перемещения между уровнями
- Предоставляет методы для получения текущих данных для отображения
- Вычисляет общий процент заполнения для текущего уровня

### UniversalPieChartView (базовая версия)

- Простая отрисовка сегментов диаграммы
- Отображение текущего заголовка и процента заполнения
- Поддержка анимаций при переходах между уровнями

### EnhancedUniversalPieChartView (улучшенная версия)

- Продвинутая визуализация с градиентами и тенями
- Выделение сегментов при выборе
- Ротация диаграммы для центрирования выбранного сегмента
- Отображение хлебных крошек для навигации
- Индикаторы наличия дочерних моделей
- Анимированный прогресс заполнения

## Пример создания глубокой иерархии

```swift
// Уровень 4
let level4 = [
    PieModel(totalValue: 60, currentValue: 30, subModels: nil, color: .orange, title: "Уровень 4-1"),
    PieModel(totalValue: 40, currentValue: 20, subModels: nil, color: .yellow, title: "Уровень 4-2")
]

// Уровень 3
let level3 = [
    PieModel(totalValue: 50, currentValue: 25, subModels: level4, color: .green, title: "Уровень 3-1"),
    PieModel(totalValue: 50, currentValue: 30, subModels: nil, color: .blue, title: "Уровень 3-2")
]

// Уровень 2
let level2 = [
    PieModel(totalValue: 70, currentValue: 40, subModels: level3, color: .purple, title: "Уровень 2-1"),
    PieModel(totalValue: 30, currentValue: 15, subModels: nil, color: .pink, title: "Уровень 2-2")
]

// Уровень 1 (корень)
let rootModels = [
    PieModel(totalValue: 100, currentValue: 50, subModels: level2, color: .red, title: "Корень")
]
```
