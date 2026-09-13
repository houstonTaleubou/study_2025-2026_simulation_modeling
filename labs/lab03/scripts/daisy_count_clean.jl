using DrWatson
@quickactivate "project"

using Agents, DataFrames, CairoMakie
include(srcdir("daisyworld.jl"))

black(a) = a.breed == :black
white(a) = a.breed == :white

adata = [(black, count), (white, count)]

model = daisyworld(; solar_luminosity = 1.0)
agent_df, model_df = run!(model, 1000; adata)

figure = Figure(size = (600, 400))
ax = figure[1, 1] = Axis(figure, xlabel = "Время (тики)", ylabel = "Количество маргариток")

blackl = lines!(ax, agent_df[!, :time], agent_df[!, :count_black], color = :black)
whitel = lines!(ax, agent_df[!, :time], agent_df[!, :count_white], color = :orange)

Legend(figure[1, 2], [blackl, whitel], ["Черные", "Белые"], labelsize = 12)

figure

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
