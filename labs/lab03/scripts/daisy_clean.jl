using DrWatson
@quickactivate

using Agents, CairoMakie, DataFrames
include(srcdir("daisyworld.jl"))

function ac(a)
    if a.breed == :white
        return :white
    else
        return :black
    end
end

am(a) = '✿'

model = daisyworld()
mkpath(plotsdir())

plotkwargs = (
    agent_color = ac,
    agent_size = 20,
    agent_marker = am,
    heatarray = :temperature,
    heatkwargs = (colorrange = (-20, 60), colormap = :viridis),
)

fig, _ = abmplot(model; plotkwargs...)
save(plotsdir("daisy_report_fig.png"), fig)
fig

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
