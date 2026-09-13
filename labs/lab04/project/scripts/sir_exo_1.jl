using DifferentialEquations
using Plots

N = 1000.0          # Общая численность населения
I0 = 1.0            # 1 инфицированный в начале
R0_init = 0.0       # 0 выздоровевших в начале
S0 = N - I0 - R0_init
u0 = [S0, I0, R0_init] # Начальное состояние системы

beta = 0.3          # Коэффициент заражения (β)
infection_period = 10.0 # Длительность болезни (дней)
gamma = 1.0 / infection_period # Коэффициент выздоровления (γ)

p = [beta, gamma, N] # Параметры для передачи в модель
tspan = (0.0, 160.0) # Симуляция на 160 дней

function sir_model!(du, u, p, t)
    S, I, R = u
    β, γ, N = p
    du[1] = -β * S * I / N           # Изменение S
    du[2] = β * S * I / N - γ * I    # Изменение I (рост и спад эпидемии)
    du[3] = γ * I                    # Изменение R
end

prob = ODEProblem(sir_model!, u0, tspan, p)
sol = solve(prob)

R0_value = beta / gamma
println("--- Результаты задания №1 ---")
println("Базовое репродуктивное число R0 = ", R0_value)

plot(sol, 
     title="Динамика численности S, I, R (R0 = $R0_value)",
     xlabel="Время (дни)", 
     ylabel="Количество людей", 
     label=["S (Здоровые)" "I (Больные)" "R (Выздоровевшие)"],
     lw=2, 
     color=[:blue :red :green])
     
     
savefig(plotsdir("exo_1.png"))
