---
## Front matter
lang: ru-RU
title: Лабораторная работа №1
author: |
        Талебу Тенке Франк
        
## i18n babel
babel-lang: russian
babel-otherlangs: english

## i18n babel
babel-lang: russian
babel-otherlangs: english

## Formatting pdf
toc: false
toc-title: Содержание
slide_level: 2
aspectratio: 169
section-titles: true
theme: metropolis
header-includes:
 - \metroset{progressbar=frametitle,sectionpage=progressbar,numbering=fraction}
 - '\makeatletter'
 - '\beamer@ignorenonframefalse'
 - '\makeatother'
---

## Содержание

- Цель работы
- Задание
- Выполнение лабораторной работы
- Список литературы

## Цель

- Данная работа посвящена подготовке программной среды и освоению методологии современной программной инженерии для проведения научных исследований. Актуальность работы обусловлена необходимостью создания воспроизводимых вычислительных экспериментов, что требует владения не только языками программирования, но и инструментами управления проектами.


## Задание

1. Программная инженерия
2. Использование git
3. Литературное программирование
4. julia. Пакет DrWatson
5. Язык Markdown
6. Соглашение об именовании Denote
7. Настройка git
8. Рабочее пространство лабораторной работы
9. Создание проекта DrWatson для лабораторных работ
10. Модель экспоненциального роста

## Настройка git

- Мы зададим имя и email владельца репозитория, настроим utf-8 в выводе сообщений gitи зададим имя начальной ветки (будем называть её master). Параметр autocrlf и  safecrlf. 

![fig](image/1.jpg){#fig:001 width=70%}


## Создание ключи SSH и pgp

- По алгоритму rsa с ключём размером 4096 бит: ssh-keygen -t rsa -b 4096   

![fig](image/2.jpg){#fig:002 width=70%}

## Создание ключи SSH и pgp

- По алгоритму ed25519: ssh-keygen -t ed25519  

![fig](image/3.jpg){#fig:003 width=70%}

## Создание ключи SSH и pgp

- Генерируем ключ: gpg --full-generate-key

![fig](image/4.jpg){#fig:004 width=70%}

## Сознание репозитория курса на основе шаблона

— Сделать свой репозиторий на основе шаблона можно и вручную: https://docs
.github.com/ru/repositories/creating-and-managing-repositories/creating-a-
repository-from-a-template.
— Авторизуйтесь на https://gitverse.ru.
— Перейдите в репозиторий https://gitverse.ru/dharma/course-directory-student-
template.
— Найдите кнопку (ссылку) «Использовать как шаблон» https://gitverse.ru/new?te
mplate_id=195300.
— После нажатия откроется форма для создания нового репозитория.
— Укажите название для вашего нового проекта: 2026-1--study--simulation-
modeling
— Укажите описание для вашего проекта.
— Выберите уровень доступа (публичный).
— Нажмите кнопку для подтверждения создания. 


## Создание проекта DrWatson для лабораторных

- Установка скриптом 

![fig](image/10.jpg){#fig:010 width=70%}


## Создание проекта DrWatson для лабораторных

- Создание файла add_packages.jl в корне проекта и запустим её. 

![fig](image/23.jpg){#fig:023 width=70%}


## Создание проекта DrWatson для лабораторных

- Проверка установки

![fig](image/11.jpg){#fig:011 width=70%}


## Модель экспоненциального роста

- Реализация модели скрипта 
 
![fig](image/13.jpg){#fig:013 width=70%}


## Модель экспоненциального роста

- Создание  следующий скрипт (scripts/01_exponential_growth.jl) и запустим его. 

![fig](image/14.jpg){#fig:014 width=70%}


## Модель экспоненциального роста

- Результ графики в каталоге plots/. 

![fig](image/15.jpg){#fig:015 width=70%}


## Литературная реализация модели

- Создание производных форматов 
 
![fig](image/19.jpg){#fig:019 width=70%}


## Литературная реализация модели

- Создадим скрипт для генерации производных форматов (scripts/tangle.jl) и запустим его. Создайте производные форматы 

![fig](image/20.jpg){#fig:020 width=70%}


# Выводы

- В этой лаборатории мы успели подговить стенду.

## Список литературы

## {.standout}

Спасибо за внимание 

