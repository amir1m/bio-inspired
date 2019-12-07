using Distributions

f(x) = x^2 - 5 * x + 6

function get_best_solution(soln)
    best = soln[1]
    for s in soln
        if f(s) < f(best)
            best = s
        end
    end
    return best
end


function flower_pollination_algorithm(f;total_flowers=25,λ = 1.5,γ = 0.1,p = 0.8, MaxGenerations = 10)
    flowers = rand(Float64, total_flowers)
    L = Levy()

    global_best = get_best_solution(flowers)
    print("Start Global best:", global_best)
    println("Out of answers:", flowers)
    println("Best answer so far:", global_best)

    t = 1
    while t < MaxGenerations
        for i = 1:total_flowers
            new_value = nothing
            if rand() < p
                new_value = flowers[i] + γ * rand(L) * (global_best - flowers[i])
            else
                xj = rand(1:total_flowers)
                xk = rand(1:total_flowers)
                new_value = flowers[i] + rand() * (xj - xk)
            end
            if f(new_value) < f(flowers[i])
                flowers[i] = new_value
            end
        end
        global_best = get_best_solution(flowers)
        println("Global Best so far: ", global_best)
        t = t + 1
    end
    return global_best
end

global_minimum=flower_pollination_algorithm(f,total_flowers=25,λ = 1.5,γ = 0.1,p = 0.8)

println("Final Global Minimum: ", global_minimum)
