#!/bin/bash

# Проверяем версию Python
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED_VERSION="3.9"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "Ошибка: Требуется Python $REQUIRED_VERSION или выше. Текущая версия: $PYTHON_VERSION"
    exit 1
fi

echo "Python версия $PYTHON_VERSION"

# Проверяем наличие виртуального окружения и создаём, если его нет
if [ ! -d ".venv" ]; then
    echo "Виртуальное окружение не найдено. Создаём..."
    python3 -m venv .venv
    echo "Виртуальное окружение создано."
fi

# Активируем виртуальное окружение
source .venv/bin/activate

# Обновляем pip
echo "Обновляем pip..."
pip install --upgrade pip -q

# Устанавливаем зависимости
echo "Устанавливаем зависимости..."
pip install -r requirements_jupyter.txt

# Регистрируем kernel для Jupyter
echo "Регистрируем Jupyter kernel..."
python -m ipykernel install --user --name=project_venv --display-name "project_venv"

echo "Настройка завершена. Запускаем Jupyter Lab..."

# Запускаем Jupyter Lab
jupyter lab --ServerApp.token='secret'