using ResumableFunctions
using ConcurrentSim
using Distributions
using DataFrames


mutable struct SIRPerson
    id::Int64
    status::Symbol # :S, :E, :I, :R, :D (D pour Décédé)
end


mutable struct SIRModel
    sim::Simulation
    β::Float64        
    c::Float64        # Taux de contact
    γ::Float64        # Taux de récupération (I -> R)
    σ::Float64        # Taux d'incubation (E -> I)
    μ::Float64        # Taux de mortalité et natalité
    ta::Vector{Float64}
    Sa::Vector{Int64}
    Ea::Vector{Int64}
    Ia::Vector{Int64}
    Ra::Vector{Int64}
    allIndividuals::Vector{SIRPerson}
end

function update_stats!(m::SIRModel, env::Simulation)
    push!(m.ta, now(env))
    push!(m.Sa, count(p -> p.status == :S, m.allIndividuals))
    push!(m.Ea, count(p -> p.status == :E, m.allIndividuals))
    push!(m.Ia, count(p -> p.status == :I, m.allIndividuals))
    push!(m.Ra, count(p -> p.status == :R, m.allIndividuals))
end

@resumable function live(env::Simulation, individual::SIRPerson, m::SIRModel)
    
    # 1. Stade S (Sain)
    while individual.status == :S
        # Temps avant prochain contact OU mort
        dt_contact = rand(Exponential(1/m.c))
        dt_death = rand(Exponential(1/m.μ))
        
        if dt_death < dt_contact
            @yield timeout(env, dt_death)
            individual.status = :D
            update_stats!(m, env)
            return # Fin du processus
        else
            @yield timeout(env, dt_contact)
            # Tentative d'infection
            if !isempty(m.allIndividuals)
                alter = rand(m.allIndividuals)
                if alter.status == :I && rand() < m.β
                    individual.status = :E
                    update_stats!(m, env)
                end
            end
        end
    end

    # 2. Stade E (Exposé / Incubation)
    if individual.status == :E
        dt_incubation = rand(Exponential(1/m.σ))
        dt_death = rand(Exponential(1/m.μ))

        if dt_death < dt_incubation
            @yield timeout(env, dt_death)
            individual.status = :D
            update_stats!(m, env)
            return
        else
            @yield timeout(env, dt_incubation)
            individual.status = :I
            update_stats!(m, env)
        end
    end

    # 3. Stade I (Infecté)
    if individual.status == :I
        dt_recovery = rand(Exponential(1/m.γ))
        dt_death = rand(Exponential(1/m.μ))

        if dt_death < dt_recovery
            @yield timeout(env, dt_death)
            individual.status = :D
            update_stats!(m, env)
            return
        else
            @yield timeout(env, dt_recovery)
            individual.status = :R
            update_stats!(m, env)
        end
    end

    # 4. Stade R (Rétabli)
    if individual.status == :R
        # L'individu peut encore mourir de vieillesse
        dt_death = rand(Exponential(1/m.μ))
        @yield timeout(env, dt_death)
        individual.status = :D
        update_stats!(m, env)
    end
end

@resumable function birth_process(env::Simulation, m::SIRModel)
    while true
        # Taux de naissance basé sur la population initiale N
        # On peut aussi utiliser la population actuelle
        N = length(m.allIndividuals)
        @yield timeout(env, rand(Exponential(1/(m.μ * N))))
        
        # Création d'un nouveau "S"
        new_id = length(m.allIndividuals) + 1
        baby = SIRPerson(new_id, :S)
        push!(m.allIndividuals, baby)
        
        update_stats!(m, env)
        @process live(env, baby, m)
    end
end

function MakeSIRModel(u0::Vector{Int64}, p::Vector{Float64})
    sim = Simulation()
    β, c, γ, σ, μ = p
    
    allIndividuals = SIRPerson[]
    
    # Initialisation de la population selon u0 [S, E, I, R]
    for _ in 1:u0[1] push!(allIndividuals, SIRPerson(length(allIndividuals)+1, :S)) end
    for _ in 1:u0[2] push!(allIndividuals, SIRPerson(length(allIndividuals)+1, :E)) end
    for _ in 1:u0[3] push!(allIndividuals, SIRPerson(length(allIndividuals)+1, :I)) end
    for _ in 1:u0[4] push!(allIndividuals, SIRPerson(length(allIndividuals)+1, :R)) end
    
    # Historiques
    ta = [0.0]; Sa = [u0[1]]; Ea = [u0[2]]; Ia = [u0[3]]; Ra = [u0[4]]
    
    return SIRModel(sim, β, c, γ, σ, μ, ta, Sa, Ea, Ia, Ra, allIndividuals)
end

function activate(m::SIRModel)
    for p in m.allIndividuals
        @process live(m.sim, p, m)
    end
end

function sir_run(m::SIRModel, tf::Float64)
    run(m.sim, tf)
end

function out(m::SIRModel)
    return DataFrame(t=m.ta, S=m.Sa, E=m.Ea, I=m.Ia, R=m.Ra)
end
