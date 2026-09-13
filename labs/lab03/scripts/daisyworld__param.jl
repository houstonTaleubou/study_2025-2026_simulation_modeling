# # Параметрическое исследование Daisyworld
# В этом разделе мы проведем серию экспериментов, изменяя ключевые параметры: 
# максимальный возраст маргариток (`max_age`) и начальную плотность белых маргариток (`init_white`).
# Мы визуализируем состояние системы на разных этапах времени.

using DrWatson
@quickactivate "project"

using Agents, DataFrames, CairoMakie
include(srcdir("daisyworld.jl"))

# ## Определение параметров
# Мы создаем словарь параметров. Те значения, которые указаны в виде списков `[...]`, 
# будут автоматически скомбинированы для проведения нескольких экспериментов.
param_dict = Dict(
    :griddims => (30, 30),
    :max_age => [25, 40],        ## Сравниваем разную продолжительность жизни
    :init_white => [0.2, 0.8],   ## Сравниваем разную начальную плотность
    :init_black => 0.2,
    :albedo_white => 0.75,
    :albedo_black => 0.25,
    :surface_albedo => 0.4,
    :solar_change => 0.005,
    :solar_luminosity => 1.0,
    :scenario => :default,
    :seed => 165,
)

# Создаем список всех возможных комбинаций параметров.
params_list = dict_list(param_dict)

# ## Запуск экспериментов и визуализация
# Проходим циклом по каждой комбинации параметров.
for params in params_list
    ## Инициализация модели с текущим набором параметров
    model = daisyworld(;params...)
    
    ## Функция для определения цвета маргаритки на графике
    daisycolor(a::Daisy) = a.breed

    ## Настройки визуализации (общие для всех графиков)
    plotkwargs = (
        agent_color = daisycolor,
        agent_size = 20,
        agent_marker = '✿',
        heatarray = :temperature,
        heatkwargs = (colorrange = (-20, 60),),
    )

    # ### Шаг 0: Начальное состояние
    plt1, _ = abmplot(model; plotkwargs...)
    display(plt1) # Отображаем в Jupyter
    
    # ### Шаг 5: Состояние после короткого времени
    step!(model, 5)
    plt2, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)
    display(plt2) # Отображаем в Jupyter

    # ### Шаг 45: Состояние после длительной симуляции
    step!(model, 40)
    plt3, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)
    display(plt3) # Отображаем в Jupyter
    
    # ## Сохранение результатов
    # Используем `savename` из DrWatson для автоматического создания имен файлов на основе параметров.
    base_name = savename("daisyworld", params)
    
    mkpath(plotsdir())
    save(plotsdir(base_name * "_step01.png"), plt1)
    save(plotsdir(base_name * "_step05.png"), plt2)
    save(plotsdir(base_name * "_step45.png"), plt3)
    
    println("Результаты для параметров $(params) сохранены.")
end
