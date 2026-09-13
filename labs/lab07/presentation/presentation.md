---
apple-mobile-web-app-capable: "yes"
apple-mobile-web-app-status-bar-style: black-translucent
author: Талебу Тенке
generator: pandoc
lang: ru-RU
title: Лабораторная работа №7
viewport: width=device-width, initial-scale=1.0, maximum-scale=1.0,
  user-scalable=no, minimal-ui
---

::: reveal
::: slides
::: {#title-slide .section}
# Лабораторная работа №7 {#лабораторная-работа-7 .title}

Дискретно-событийное моделирование.

Талебу Тенке

Российский университет дружбы народов, Москва, Россия
:::

::: {.section .slide .level1}
## Цель работы

-   изучить методы дискретно‑событийного моделирования и применить их
    для анализа работы системы ремонта машин с ограниченным количеством
    запасных частей и ремонтников.

## Задание

**Модель M/M/c**

1.  Переведите в структуру DrWatson.
2.  Добавьте необходимые графики.

**Модель Росса**

1.  Переведите в структуру DrWatson.
2.  Добавьте нескольких ремонтников.
3.  Сделайте прогон для разного количества машин.
4.  Проведите мониторинг загрузки ремонтника, средней длины очереди на
    ремонт.
5.  Построение графиков изменения числа исправных машин во времени.
6.  Сравните с аналитическим решением.
:::

::: {#теоретическое-введение .section .slide .level1}
# Теоретическое введение

## Модель M/M/c

Модель M/M/c (по классификации Кендалла) --- это система массового
обслуживания со следующими свойствами:

-   M (Markovian) --- входящий поток заявок пуассоновский, интервалы
    между прибытиями распределены экспоненциально с параметром
    [*λ*]{.math .inline}.

-   M --- время обслуживания каждой заявки распределено экспоненциально
    с параметром [*μ*]{.math .inline}.

-   c --- количество идентичных обслуживающих приборов (каналов),
    работающих параллельно.

## Модель Росса

-   Модель представляет собой классический пример системы массового
    обслуживания с конечной популяцией, резервом и ремонтом.

**Формальная постановка задачи**

-   В системе находятся [*𝑁*]{.math .inline} идентичных машин, которые
    постоянно работают и могут выходить из строя.
-   [*𝑆*]{.math .inline} машин находятся в резерве и готовы немедленно
    заменить любую отказавшую.
-   Одно ремонтное устройство (ремонтник), которое может одновременно
    ремонтировать только одну машину.

## Модель Росса

-   Когда работающая машина ломается, происходит следующее:

1.  Немедленно берётся одна резервная машина (если она есть) и
    запускается в работу вместо сломавшейся.
2.  Сломанная машина отправляется в ремонт.
3.  Если резерва нет, система падает (crash). Моделирование
    заканчивается.
:::

::: {#выполнение-лабораторной-работы .section .slide .level1}
# Выполнение лабораторной работы

## Модель M/M/c

-   Сначала я создала файл "src/sumilation.jl" и написала код и
    запустила его.

<figure id="fig:001">

<figcaption>Fig</figcaption>
</figure>

::: {#cb1 .sourceCode}
``` {.sourceCode .julia}
function setup_and_run()

    sim = Simulation()
    server = Resource(sim, num_servers)

    arrival_time = 0.0

    for i in 1:num_customers
        arrival_time += rand(rng, arrival_dist)
        @process customer(sim, server, i, arrival_time, service_dist)
    end

    run(sim)

    return arrivals, service_start, service_end

end
```
:::

## Модель M/M/c

-   Код

<figure id="fig:007">

<figcaption>Fig</figcaption>
</figure>

## Модель M/M/c

-   Потом я создала файл "scripts/run.jl" и написала код и запустила
    его.

<figure id="fig:002">

<figcaption>Fig</figcaption>
</figure>

## Модель M/M/c

-   Мы получаем вот такой результат в консоле.

<figure id="fig:003">

<figcaption>Fig</figcaption>
</figure>

## Модель M/M/c

-   График 1

<figure id="fig:004">

<figcaption>Fig</figcaption>
</figure>

## Модель M/M/c

-   График 2

<figure id="fig:005">

<figcaption>Fig</figcaption>
</figure>

## Модель Росса

-   Сначала я создала файл "src/model.jl" и написала код и запустила
    его.

<figure id="fig:006">

<figcaption>Fig</figcaption>
</figure>

::: {#cb2 .sourceCode}
``` {.sourceCode .julia}
@resumable function start_sim(env, repair_facility, spares, N, S, $\lamba$, μ)

    # create spare machines
    for i in 1:S
        proc = @process machine(env, repair_facility, spares, $\lambda$, μ)
        @yield put!(spares, proc)
    end

    # create working machines
    for i in 1:N
        @process machine(env, repair_facility, spares, $\lambda$, μ)
    end

end
```
:::

## Модель Росса

-   Потом я создала файл "scripts/run_sum.jl" и написала код и запустила
    его.

<figure id="fig:008">

<figcaption>Fig</figcaption>
</figure>

## Модель Росса

-   Вывод в консоль.

<figure id="fig:009">

<figcaption>Fig</figcaption>
</figure>

## Модель Росса

-   График

<figure id="fig:010">

<figcaption>Fig</figcaption>
</figure>
:::

::: {#выводы .section .slide .level1}
# Выводы

-   Я выполнила лабораторную работу №7.
:::

::: {#список-литературы .section .slide .level1 .unnumbered}
# Список литературы {.unnumbered}

<https://esystem.rudn.ru/pluginfile.php/3145800/mod_resource/content/1/lab07.pdf%7D>
:::
:::
:::
