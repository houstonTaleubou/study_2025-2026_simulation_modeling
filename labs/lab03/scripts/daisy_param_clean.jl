using DrWatson
@quickactivate "project"

using Agents, DataFrames, CairoMakie
include(srcdir("daisyworld.jl"))

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

params_list = dict_list(param_dict)

for params in params_list
    # Инициализация модели с текущим набором параметров
    model = daisyworld(;params...)

    # Функция для определения цвета маргаритки на графике
    daisycolor(a::Daisy) = a.breed

    # Настройки визуализации (общие для всех графиков)
    plotkwargs = (
        agent_color = daisycolor,
        agent_size = 20,
        agent_marker = '✿',
        heatarray = :temperature,
        heatkwargs = (colorrange = (-20, 60),),
    )

    plt1, _ = abmplot(model; plotkwargs...)
    display(plt1) # Отображаем в Jupyter

    step!(model, 5)
    plt2, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)
    display(plt2) # Отображаем в Jupyter

    step!(model, 40)
    plt3, _ = abmplot(model; heatarray = model.temperature, plotkwargs...)
    display(plt3) # Отображаем в Jupyter

    base_name = savename("daisyworld", params)

    mkpath(plotsdir())
    save(plotsdir(base_name * "_step01.png"), plt1)
    save(plotsdir(base_name * "_step05.png"), plt2)
    save(plotsdir(base_name * "_step45.png"), plt3)

    println("Результаты для параметров $(params) сохранены.")
end

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
