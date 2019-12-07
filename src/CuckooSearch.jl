using Distributions
using DataStructures

f(x) = x^2 - 5 * x + 6

function filter_best_solutions(solutions; pa=0.25)
    new_best_solutions=SortedDict(Dict{Float64, Float64}())
    println("***FILTER RCVD : ", length(solutions))
    println("Filterting : ", floor((length(solutions) - length(solutions)*pa)))
    let
        i = 1
        for (key, value) in solutions
            new_best_solutions[key] = value
            i = i + 1
            if i >= (length(solutions) - length(solutions)*pa)
                return merge(new_best_solutions, initialize_population(floor((length(solutions) - length(solutions)*pa))))
            end
        end
    end
end


function get_best_solution(soln)
    best = soln[1]
    for s in soln
        if f(s) < f(best)
            best = s
        end
    end
    return best
end

heaviside(x::AbstractFloat) = ifelse(x < 0, zero(x), ifelse(x > 0, one(x), oftype(x,0.5)))

function generate_new_population(population; pa=0.25)
    new_population=SortedDict(Dict{Float64, Float64}())
    for (key, value) in population
        new_value = value + heaviside(pa - rand()) * (rand(population)[2] - rand(population)[2])
        new_population[f(new_value)] = new_value
    end
    return new_population
end



function initialize_population(total)
    population = SortedDict(Dict{Float64,Float64}())
    for i=1:total
        soln = rand(Float64)
        population[f(soln)] = soln
    end
    return population
end


function cuckoo_search(f;total_cuckoos=25,pa = 0.25,α=0.01, λ=0.5, MaxGenerations = 15)
    cuckoos = initialize_population(total_cuckoos)
    println("Initial population of Cuckoos: ", length(cuckoos))
    L = Levy(λ)
    best = nothing
    t=1
    while t < MaxGenerations
        r_cuckoo = rand(cuckoos)
        new_best = r_cuckoo[2] + α * rand(L)
        if (f(new_best) < r_cuckoo[2])
            best = new_best
        end
        #
        cuckoos = filter_best_solutions(cuckoos, pa=pa)
        println("After FILTER Total Cuckoos: ", length(cuckoos))
        cuckoos = generate_new_population(cuckoos, pa=pa)
        best = first(cuckoos)[2]
        println("Current Best: ", best)
        println("Total Cuckoos: ", length(cuckoos))
        t = t +1
    end
    return best
end


global_minimum=cuckoo_search(f)

println("Final Global Minimum: ", global_minimum)
