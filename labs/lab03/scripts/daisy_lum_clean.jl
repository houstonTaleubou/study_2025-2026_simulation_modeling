using DrWatson
@quickactivate "project"

using Agents, DataFrames, CairoMakie, Statistics
include(srcdir("daisyworld.jl"))

black(a) = a.breed == :black
white(a) = a.breed == :white
adata = [(black, count), (white, count)]

temperature(model) = mean(model.temperature)
mdata = [temperature, :solar_luminosity]

model = daisyworld(; solar_luminosity = 1.0, scenario = :ramp)
agent_df, model_df = run!(model, 1000; adata = adata, mdata = mdata)

figure = Figure(size = (600, 800))

ax1 = figure[1, 1] = Axis(figure, ylabel = "Число маргариток")
blackl = lines!(ax1, agent_df[!, :time], agent_df[!, :count_black], color = :black)
whitel = lines!(ax1, agent_df[!, :time], agent_df[!, :count_white], color = :blue)
figure[1, 2] = Legend(figure, [blackl, whitel], ["Черные", "Белые"])

ax2 = figure[2, 1] = Axis(figure, ylabel = "Температура")
lines!(ax2, model_df[!, :time], model_df[!, :temperature], color = :red)

ax3 = figure[3, 1] = Axis(figure, xlabel = "Тики (время)", ylabel = "Светимость")
lines!(ax3, model_df[!, :time], model_df[!, :solar_luminosity], color = :orange)

for ax in (ax1, ax2)
    ax.xticklabelsvisible = false
end

mkpath(plotsdir())
save(plotsdir("daisy_luminosity.png"), figure)

figure

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
