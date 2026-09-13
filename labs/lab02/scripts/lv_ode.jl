using DrWatson

@quickactivate "project"
using DifferentialEquations
using DataFrames
using StatsPlots
using LaTeXStrings
using Plots
using Statistics
using FFTW

script_name = splitext(basename(PROGRAM_FILE))[1]
mkpath(plotsdir(script_name))
mkpath(datadir(script_name))

# Описание модели Лотки-Вольтерры

function lotka_volterra!(du, u, p, t)
    x, y = u # x - жертвы, y - хищники
    α, β, δ, γ = p # параметры модели
    @inbounds begin
    du[1] = α*x - β*x*y # уравнение для жертв
    du[2] = δ*x*y - γ*y # уравнение для хищников
    end

end

p_lv = [0.1, # α: скорость размножения жертв
   0.02, # β: скорость поедания жертв хищниками
   0.01, # δ: коэффициент конверсии пищи (жертв) в хищников
   0.3] # γ: смертность хищников

# Начальные условия: [жертвы, хищники]
u0_lv = [40.0, 9.0] # начальная популяция

# Временные параметры
tspan_lv = (0.0, 200.0) # длительность симуляции
dt_lv = 0.01 # шаг интегрирования

# Создание и решение задачи
prob_lv = ODEProblem(lotka_volterra!, u0_lv, tspan_lv, p_lv)
sol_lv = solve(prob_lv,
               dt = dt_lv,
               Tsit5(), # Метод 5-го порядка
               reltol=1e-8, # Относительная точность
               abstol=1e-10, # Абсолютная точность
               saveat=0.1, # Сохраняем каждые 0.1 единицы времени
               dense=true # Включаем плотный вывод для интерполяции
)

# Подготовка данных
df_lv = DataFrame()
df_lv[!, :t] = sol_lv.t
df_lv[!, :prey] = [u[1] for u in sol_lv.u] # жертвы
df_lv[!, :predator] = [u[2] for u in sol_lv.u] # хищники

# Рассчет производных для анализа
df_lv[!, :dprey_dt] = p_lv[1] .* df_lv.prey .- p_lv[2] .* df_lv.prey .* df_lv.predator
df_lv[!, :dpredator_dt] = p_lv[3] .* df_lv.prey .* df_lv.predator .-p_lv[4] .* df_lv.predator

# Вывод информации о модели
println("="^60)
println("Модель Лотки-Вольтерры (хищник-жертва)")
println("="^60)
println("\nПараметры модели:")
println("α (скорость размножения жертв) = ", p_lv[1])
println("β (скорость поедания жертв) = ", p_lv[2])
println("δ (коэффициент конверсии) = ", p_lv[3])
println("γ (смертность хищников) = ", p_lv[4])
println("\nНачальные условия:")
println("Жертвы (x0) = ", u0_lv[1])
println("Хищники (y0) = ", u0_lv[2])

# Стационарные точки (нулевые изоклины)
x_star = p_lv[4] / p_lv[3] # стационарная точка для жертв
y_star = p_lv[1] / p_lv[2] # стационарная точка для хищников
println("\nСтационарные точки (положения равновесия):")
println("x* = γ/δ = ", round(x_star, digits=3))
println("y* = α/β = ", round(y_star, digits=3))

# Построение графиков

# График 1: Динамика популяций во времени
plt1 = plot(df_lv.t, [df_lv.prey df_lv.predator],
    label=[L"Жертвы (x)" L"Хищники (y)"],
    xlabel="Время",
    ylabel="Популяция",
    title="Модель Лотки-Вольтерры: Динамика популяций",
    linewidth=2,
    legend=:topright,
    grid=true,
    size=(900, 500),
    color=[:green :red])

# Добавление стационарных уровней
hline!(plt1, [x_star], color=:green, linestyle=:dash, alpha=0.5, label="x* (равновесие жертв)")
hline!(plt1, [y_star], color=:red, linestyle=:dash, alpha=0.5, label="y* (равновесие хищников)")

# График 2: Фазовый портрет (хищники vs жертвы)
plt2 = plot(df_lv.prey, df_lv.predator,
    label="Фазовая траектория",
    xlabel="Популяция жертв (x)",
    ylabel="Популяция хищников (y)",
    title="Фазовый портрет системы",
    color=:blue,
    linewidth=1.5,
    grid=true,
    size=(800, 600),
    legend=:topright,
   
# Добавление стрелок направления на фазовом портрете
step = 50 # шаг для отображения стрелок
for i in 1:step:length(df_lv.prey)-step
    plot!(plt2, 
        [df_lv.prey[i], df_lv.prey[i+step]],
        [df_lv.predator[i], df_lv.predator[i+step]],
        arrow=:closed, 
        color=:blue, 
        alpha=0.3, 
        label=false)
end

# Добавление стационарной точки
scatter!(plt2, [x_star], [y_star],
    color=:black, 
    markersize=8, 
    label="Стационарная точка (x*, y*)")
display(plt2)