# Интерактивный компонент PieChart с многоуровневыми категориями

Этот компонент предоставляет интерактивную круговую диаграмму с поддержкой иерархической структуры данных и возможностью перехода между уровнями категорий.

## Возможности

- Отображение категорий с возможностью перехода к подкатегориям
- Поддержка до 4 уровней вложенности (Category → SubCat → SubSubCat → SubSubSubCat)
- Интерактивные элементы для перехода между уровнями иерархии
- Отображение текущего процента заполнения
- Анимированные переходы между состояниями
- Настраиваемые цветовые схемы
- Возможность выбора отдельных сегментов для просмотра информации
- Поддержка градиентов и визуальных эффектов

## Структуры данных

```swift
struct Category: Identifiable {
    let id = UUID()
    /// процент от общего значения Category
    let totalValue: Double
    /// текущее заполнение конкретной Category
    let currentValue: Double
    let subCat: [SubCat]?
    let color: Color
    let title: String
}

struct SubCat: Identifiable {
    let id = UUID()
    /// процент от общего значения всех SubCat
    let totalValue: Double
    /// текущее заполнение конкретной SubCat
    let currentValue: Double
    let subSubCat: [SubSubCat]?
    let color: Color
    let title: String
}

struct SubSubCat: Identifiable {
    let id = UUID()
    /// процент от общего значения SubSubCat
    let totalValue: Double
    /// текущее заполнение конкретной SubSubCat
    let currentValue: Double
    let subSubSubCat: [SubSubSubCat]?
    let color: Color
    let title: String
}

struct SubSubSubCat: Identifiable {
    let id = UUID()
    /// процент от общего значения SubSubSubCat
    let totalValue: Double
    /// текущее заполнение конкретной SubSubSubCat
    let currentValue: Double
    let color: Color
    let title: String
}
```

## Использование

### Базовая диаграмма

```swift
// Создаем ViewModel и наполняем данными
let viewModel = PieChartViewModel()
viewModel.categories = [/* ваши категории */]

// Базовая версия
PieChartView(viewModel: viewModel)
    .frame(width: 300, height: 300)

// Улучшенная версия с дополнительными визуальными эффектами
EnhancedPieChartView(viewModel: viewModel)
    .frame(width: 300, height: 300)
```

### Варианты использования

В этом репозитории представлены примеры использования:

1. `PieChartDemoView.swift` - Базовая демонстрация возможностей диаграммы
2. `EnhancedPieChartDemoView.swift` - Улучшенная версия с дополнительными функциями, включая:
   - Выбор цветовых тем
   - Интерактивные подсказки
   - Анимированные переходы
   - Выделение выбранных сегментов

## Отличия между версиями

1. **PieChartView** - базовая версия для простых случаев использования

   - Минимальный набор зависимостей
   - Простая в интеграции
   - Легкая и производительная

2. **EnhancedPieChartView** - расширенная версия с дополнительными возможностями
   - Интерактивный выбор сегментов с выделением
   - Более детальное отображение информации о сегментах
   - Градиенты и тени для улучшенного визуального представления
   - Анимированные переходы между состояниями
   - Поворот диаграммы для фокусировки на выбранном сегменте

## Интеграция в свой проект

1. Скопируйте следующие файлы в свой проект:

   - `PieChartModel.swift` - модели данных
   - `PieChartViewModel.swift` - класс для управления состоянием
   - `PieChartView.swift` или `EnhancedPieChartView.swift` в зависимости от ваших потребностей

2. Создайте и настройте ViewModel:

   ```swift
   let viewModel = PieChartViewModel()
   // Заполнение данными...
   ```

3. Добавьте компонент в свою иерархию представлений:
   ```swift
   EnhancedPieChartView(viewModel: viewModel)
       .frame(width: 300, height: 300)
   ```
