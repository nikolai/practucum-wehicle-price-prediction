#!/usr/bin/env fish

# Проверяем версию Python
set PYTHON_VERSION (python3 --version 2>&1 | awk '{print $2}')
set REQUIRED_VERSION "3.9"

# Простая проверка версии для fish
set -l version_check (printf "%s\n%s\n" $REQUIRED_VERSION $PYTHON_VERSION | sort -V | head -n1)
if test "$version_check" != "$REQUIRED_VERSION"
    echo "Ошибка: Требуется Python $REQUIRED_VERSION или выше. Текущая версия: $PYTHON_VERSION"
    exit 1
end

echo "Python версия $PYTHON_VERSION"

# Проверяем наличие виртуального окружения и создаём, если его нет
if not test -d .venv
    echo "Виртуальное окружение не найдено. Создаём..."
    python3 -m venv .venv
    echo "Виртуальное окружение создано."
end

# Активируем виртуальное окружение
source .venv/bin/activate.fish

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
